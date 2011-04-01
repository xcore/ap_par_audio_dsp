// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>


#include <xs1.h>
#include "defines.h"

signed delay_bufs[NUM_DELAY_BUFS][DELAY_BUF_SIZE];
unsigned delay_buf_wr_idx[NUM_DELAY_BUFS] = {0,0};

int delay_proc(unsigned achan_idx, signed in_sample, unsigned delay_buf_idx, unsigned delay) {
	signed out_sample;

	int delay_buf_rd_idx;

	delay_bufs[delay_buf_idx][delay_buf_wr_idx[delay_buf_idx]] = in_sample;
	//from_dsp_bufs[1][prev_sel_from_buf][i] = to_dsp_bufs[1][prev_sel_to_buf][i];

	delay_buf_rd_idx = delay_buf_wr_idx[delay_buf_idx] - delay;

	if(delay_buf_rd_idx < 0) {
		// wrap read index
		delay_buf_rd_idx = DELAY_SAMPLES + delay_buf_rd_idx;  // add negative number
	}

    out_sample = delay_bufs[delay_buf_idx][delay_buf_rd_idx];

    // Update Write Index
	delay_buf_wr_idx[delay_buf_idx]++;
	if(delay_buf_wr_idx[delay_buf_idx]  >= DELAY_SAMPLES) {
		// wrap write index
		delay_buf_wr_idx[delay_buf_idx] = 0;
	}

	return out_sample;
}
