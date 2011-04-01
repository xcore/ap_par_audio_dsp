// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

#include <xs1.h>
#include <xclib.h>
#include <stdio.h>
#include <assert.h>
#include <stdlib.h>
#include "xai2_ports.h"
#include "iis.h"

#include "defines.h"
#include "biquad_coeffs.h"
#include "crossover.h"
#include "equaliser.h"
#include "eq_client.h"


// XMOS Parallel DSP example
// See README.rst for details


struct iis r_iis = {
		on stdcore[1] : XS1_CLKBLK_1,
		on stdcore[1] : XS1_CLKBLK_2,
		MCK_1, BCK, WCK,
		{ ADC0, ADC1, ADC2 },
		{ DAC0, DAC1, DAC2, DAC3 }
};

out port scl = I2C_SCL;
port sda = I2C_SDA;

out port sync_out = SYNC_OUT_4BIT;
out port rst = SEL_MOD_RST;

void init_pll(unsigned mult, out port scl, port sda);
void reset_codec(out port rst);
void init_codec(out port scl, port sda, int codec_is_master, int mic_input, int instr_input);

void clkgen(int freq, out port p, chanend stop);

extern void dsp_bypass(unsigned achan_idx);
extern void sine_out(unsigned achan_idx);
extern void init_states();
extern void init_xover(biquad_state_xover_s &state, int zeroDb);
extern int sine(int x);

extern int delay_proc(unsigned achan_idx, signed in_sample, unsigned delay_buf_idx, unsigned delay);
extern int biquad_xover(biquad_state_xover_s &state, coeffs_s &coeffs, int xn);

void mswait(int ms)
{
	timer tmr;
	unsigned t;
	tmr :> t;
	for (int i = 0; i < ms; i++) {
		t += 100000;
		tmr when timerafter(t) :> void;
	}
}

void crossover(unsigned idx, streaming chanend c_in, streaming chanend c_out_a, streaming chanend c_out_b) {
	signed in_sample=0;
	unsigned sample_count=0;

	// HPF: -50 DB below 500Hz
	// swc_cascaded_biquad Makefile config: FILTER= -min -50 -max 0 -low 500 -step 10
	coeffs_s lowshelf = {  27106380,  -11382399,   13969018,  -27631332,   13665645};

	// LPF: -50 DB above 500Hz
	// swc_cascaded_biquad Makefile config: FILTER= -min -50 -max 0 -high 500 -step 10
	coeffs_s highshelf = { 32681149,  -15926091,    1774726,   -3258144,    1505576};

	biquad_state_xover_s state_hs_0;
	biquad_state_xover_s state_hs_1;
	biquad_state_xover_s state_ls_0;
	biquad_state_xover_s state_ls_1;

	init_xover(state_hs_0,0);
	init_xover(state_hs_1,0);
	init_xover(state_ls_0,0);
	init_xover(state_ls_1,0);

	while(1) {
		//sync means input buffer contains block ready for processing
		//c_sync :> unsigned;
		// filters operate on input and output buffers (shared memory)
		// Process a number of channels per thread

		if(sample_count & 1) {
			// right sample
			c_out_a <: biquad_xover(
					state_hs_1,
					highshelf,
					in_sample
			);
			c_out_b <: biquad_xover(
					state_ls_1,
					lowshelf,
					in_sample
			);
		} else {
			// left sample
			c_out_a <: biquad_xover(
					state_hs_0,
					highshelf,
					in_sample
			);
			c_out_b <: biquad_xover(
					state_ls_0,
					lowshelf,
					in_sample
			);
		}

		// input happens after output in iis thread!
		c_in :> in_sample;

		sample_count++;
	}

}

void loopback(unsigned idx, streaming chanend c_in[], streaming chanend c_out[]) {
	signed in_sample[NUM_OUT]; //more out than in

	while(1) {
		for(int i=0; i<NUM_OUT; i++) {
			c_out[i] <: in_sample[i];
		}
		for(int i=0; i<NUM_IN; i++) {
			c_in[i] :> in_sample[i];
		}
		//printf("samples looped back\n");
	}
}

void delays(unsigned idx, streaming chanend c_in, streaming chanend c_out) {
	signed sample=0; //more out than in
	unsigned sample_count=0;
	while(1) {
		c_out <: sample;

		c_in :> sample;
		if(sample_count & 1) {
            // right sample
			sample = delay_proc(1, sample, 1, 5000); // delay by 5000 samples
		} else {
			sample = delay_proc(1, sample, 0, 0);
		}
		sample_count++;
		//printf("delays: sample processed\n");
	}
}


void busy_thread() {
	set_thread_fast_mode_on();
	while (1);
}

void eq_wrapper(unsigned idx, chanend cCtrl, streaming chanend cDSPActivityOutput, streaming chanend c_in, streaming chanend c_out);

int main()
{

	streaming chan c_in[NUM_IN], c_out[NUM_OUT];
	streaming chan c_DSP_activity[NUM_EQ_THREADS];
	chan c_ctrl[NUM_EQ_THREADS];

	par {


#ifdef AUDIO_LOOPBACK
		on stdcore[0] : loopback(0, c_in, c_out);
#else
		on stdcore[0] : eq_wrapper(0, c_ctrl[0], c_DSP_activity[0], c_in[0], c_out[0]);

#ifndef XSIM  // reduce the "noise" in the simulator trace
		// good practise to keep other threads busy
		on stdcore[0] : busy_thread();
		on stdcore[0] : busy_thread();
		on stdcore[0] : busy_thread();
		on stdcore[0] : busy_thread();
		on stdcore[0] : busy_thread();
		on stdcore[0] : busy_thread();
#endif

		// on core1 because there's a limit of 4 streaming channels across cores.
		on stdcore[1] : crossover(1, c_in[1], c_out[1], c_out[2]);
		//on stdcore[1] : delays(1, c_in[1], c_out[1]);
		on stdcore[0] : eq_client(c_ctrl, c_DSP_activity);
#endif

		// Init PLL, Codec, start I2S tread
		on stdcore[1] : {
			chan stop;
			char name[3][4] = { "1/2", "3/4", "5/6" };
			int mode = 0x0;  // clocks connected together
			int sel = 0x0;   // XCore sync rather than BNC input

#ifndef XSIM
			// 1kHz -> 24.576MHz
			init_pll(24576000 / 1000, scl, sda);
			reset_codec(rst);
			rst <: 0x8 | mode | sel;
			init_codec(scl, sda, 0, 0, 0);
#else
			printf("Running on Simulator\n");
#endif

			par {
				clkgen(1000, sync_out, stop);
				{
#ifndef XSIM // don't wait 300ms when simulating
					mswait(300);
#endif
					iis(r_iis, c_in, c_out);
				}
			}
		}
	}
	return 0;
}
