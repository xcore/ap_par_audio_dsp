// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

#include <xs1.h>
#include <stdio.h>
#include "biquad_coeffs.h"
#include "crossover.h"
#include "defines.h"


void init_xover(biquad_state_xover_s &state, int zeroDb) {
    for(int i = 0; i <= XOVER_BANKS; i++) {
        state.b[i].xn1 = 0;
        state.b[i].xn2 = 0;
    }
    for(int i = 0; i < XOVER_BANKS; i++) {
        state.b[i].db = zeroDb;
        state.desiredDb[i] = zeroDb;
    }
    state.adjustCounter = XOVER_BANKS;
    state.adjustDelay = 0;
}

extern int biquadAsmXover(int xn, biquad_state_xover_s &state);

#pragma unsafe arrays
int biquad_xover(biquad_state_xover_s &state, coeffs_s &coeffs, int xn) {
	// difference equation
	//y(n) = b_0 * x(n) + b_1 * x(n-1) + b_2 * x(n-2) - a_1 * y(n-1) - a_2 * y(n-2)

#ifdef ASM_BIQUAD_XOVER
#error "biquadAsmXover not operational yet, Must be changed to take coefficient object as argument"
    //xn = biquadAsmXover(xn, state);
#else
    unsigned int ynl;
    int ynh;
#pragma loop unroll(1)
    for(int j=0; j<XOVER_BANKS; j++) {
        ynl = (1<<(FRACTIONALBITS-1)); // 0.5, for rounding, could be triangular noise
        ynh = 0;
        {ynh, ynl} = macs( coeffs.b0, xn, ynh, ynl);
        {ynh, ynl} = macs( coeffs.b1, state.b[j].xn1, ynh, ynl);
        {ynh, ynl} = macs( coeffs.b2, state.b[j].xn2, ynh, ynl);
        {ynh, ynl} = macs( coeffs.a1, state.b[j+1].xn1, ynh, ynl);
        {ynh, ynl} = macs( coeffs.a2, state.b[j+1].xn2, ynh, ynl);
        if (sext(ynh,FRACTIONALBITS) == ynh) {
            ynh = (ynh << (32-FRACTIONALBITS)) | (ynl >> FRACTIONALBITS);
        } else if (ynh < 0) {
            ynh = 0x80000000;
        } else {
            ynh = 0x7fffffff;
        }
        state.b[j].xn2 = state.b[j].xn1;
        state.b[j].xn1 = xn;

        xn = ynh;
    }
    state.b[XOVER_BANKS].xn2 = state.b[XOVER_BANKS].xn1;
    state.b[XOVER_BANKS].xn1 = ynh;
#endif
    
    return xn;
}



