// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

#include <xs1.h>
#include "eq_client.h"
#include "defines.h"
#include "commands.h"

#define NUM_PRESETS 3
char equaliser_presets[NUM_PRESETS][EQ_BANKS] = {
		{20, 20, 20, 20, 20}, // all 0 dB
		{0, 5, 10, 15, 20}, // ramp: -20dB, -15dB, -10dB, -dB, 0dB
		{20, 15, 5, 15, 20}, // reduce mid ranges: -0dB, -5, -15dB, -5dB, 0dB
};
unsigned preset = 0;

void eq_client(chanend c_ctrl[], streaming chanend c_DSP_activity[]) {
	timer tmr;
	unsigned time;
	unsigned update_cnt;
	tmr :> time;

	while(1) {
        time += EQ_UPDATE_PERIOD;
        tmr when timerafter(time) :> void;

        // Example: Periodically change DB settings for frequency bands
        // of equaliser connected to c_ctrl[0]
		for(int i=0; i<EQ_BANKS; i++) {
			//Both cause ET_ILLEGAL_RESOURCE
			eq_client_set_band_db(c_ctrl[0], i, equaliser_presets[preset][i]);
			update_cnt++;
			if(update_cnt % 2000 == 0) {
				preset++; // cycle through the presets
				if(preset==NUM_PRESETS) {
					preset=0;
				}
			}

		}
		// Todo:
		// Use c_DSP_activity for level metering
	}
}

void eq_client_set_band_db(chanend c_ctrl, char band, char db_idx) {
	c_ctrl <: (char) DSP_COMMAND_XMOS_SIMPLEGFXEQ_MESSAGE;
	c_ctrl <: (char) COMMAND_XMOS_SIMPLEGFXEQ_SetBandBoost;
	c_ctrl <: (char) band;
	c_ctrl <: (char) db_idx;
}
