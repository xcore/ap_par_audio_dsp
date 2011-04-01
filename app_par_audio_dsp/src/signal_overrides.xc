// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>


#include <xs1.h>
#include "signal_overrides.h"
#include "defines.h"

unsigned out_x[NUM_OUTP_ACHANS] = {0,0,0,0,0,0,0,0};
unsigned in_x[NUM_INP_ACHANS] = {0,0,0,0,0,0};

extern int sine(int x);

// change this for custom input signal generators
signed override_input(unsigned achan_idx) {
	signed sample;

	sample = sine(in_x[achan_idx]);
	sample += sine(in_x[achan_idx]*10); // add 10x harmonic

	in_x[achan_idx]+= 5;  // sine freq will be: 10 * (48000Hz / 2048) ~ 234 Hz
	return sample >> 1;
}

// change this for custom input signal generators
signed override_output(unsigned achan_idx) {
	signed sample;

	sample = sine(out_x[achan_idx]);
	sample += sine(out_x[achan_idx]*10); // add 10x harmonic
	out_x[achan_idx]+= 5 ;  // sine freq will be: 10 * (48000Hz / 2048) ~ 234 Hz

	return sample >> 1;
}

