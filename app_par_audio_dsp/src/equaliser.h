/**
 * Module:  module_ipod_support
 * Version: 1v35alpha1
 * Build:   e51ffa39ccfdf0ef71ad86838df99eb5ed8916a5
 * File:    blockBiquad.h
 *
 * The copyrights, all other intellectual and industrial 
 * property rights are retained by XMOS and/or its licensors. 
 * Terms and conditions covering the use of this code can
 * be found in the Xmos End User License Agreement.
 *
 * Copyright XMOS Ltd 2010
 *
 * In the case where this code is a modification of existing code
 * under a separate license, the separate license terms are shown
 * below. The modifications to the code are still covered by the 
 * copyright notice above.
 *
 **/                                   
// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

#include "defines.h"

#ifndef EQUALISER_H_
#define EQUALISER_H_

#define EQ_DBS 21

typedef struct {
    struct {int xn1; int xn2; int db;} b[EQ_BANKS+1];
    int adjustDelay;
    int adjustCounter;
    int desiredDb[EQ_BANKS];

} biquad_cascade_state_eq_s;

void init_equaliser(biquad_cascade_state_eq_s &state, int zeroDb);

int biquad_cascade_eq(biquad_cascade_state_eq_s &state, int xn, int power[]);

void update_eq_gain(int bank, int gain, biquad_cascade_state_eq_s &state);

#endif /* EQUALISER_H_ */
