// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>


#ifndef DEFINES_H_
#define DEFINES_H_

/*********  Debug Switches: ********/
//#define DEBUG        	// debug tracing
//#define INPUT_OVERRIDE
//#define USE_XSCOPE
//#define AUDIO_LOOPBACK
//#define XSIM    // run on simulator

/********* Config Switches: ********/
#define EQ_BANKS 5
#define EQ_UPDATE_PERIOD 1000000; //thread cycles
#define XOVER_BANKS 1

#define ASM_BIQUAD_EQ
//#define ASM_BIQUAD_XOVER

#define NUM_EQ_THREADS 1

#define NUM_IN 2  	// input stereo channels
#define NUM_OUT 3		// output stereo channels
#define NUM_INP_ACHANS NUM_IN*2
#define NUM_OUTP_ACHANS NUM_OUT*2

#define DELAY_SAMPLES 5120

#define NUM_DELAY_BUFS 2

#define DELAY_BUF_SIZE DELAY_SAMPLES

#define MCK_BCK_RATIO 8
// With MCK 24.576MHz and MCK_BCK_RATIO 8
// sample rate =  24.576MHz / 8 / 64 = 48kHz

#define DSP_COMMAND_CONTROL_STATE 0x10
#define DSP_COMMAND_XMOS_SIMPLEGFXEQ_MESSAGE 0x11

#define FRACTIONALBITS 24

#endif /* DEFINES_H_ */
