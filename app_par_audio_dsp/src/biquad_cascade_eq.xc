// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

#include <xs1.h>
#include "equaliser.h"
#include "equaliser_coeffs.h"
#include "defines.h"

#include <stdio.h>
#include <xs1.h>
#include <print.h>

void init_equaliser(biquad_cascade_state_eq_s &state, int zeroDb) {
    for(int i = 0; i <= EQ_BANKS; i++) {
        state.b[i].xn1 = 0;
        state.b[i].xn2 = 0;
    }
    for(int i = 0; i < EQ_BANKS; i++) {
        state.b[i].db = zeroDb;
        state.desiredDb[i] = zeroDb;
    }
    state.adjustCounter = EQ_BANKS;
    state.adjustDelay = 0;
}

extern int biquadAsmEQ(int xn, biquad_cascade_state_eq_s &state);

#pragma unsafe arrays
int biquad_cascade_eq(biquad_cascade_state_eq_s &state, int xn, int power[]) {

	// difference equation
	//y(n) = b_0 * x(n) + b_1 * x(n-1) + b_2 * x(n-2) - a_1 * y(n-1) - a_2 * y(n-2)

#ifdef ASM_BIQUAD_EQ
//#error "biquadAsmEQ integration not working yet"
    #pragma xta call "call_0"
    xn = biquadAsmEQ(xn, state);
#else
    unsigned int ynl;
    int ynh;
#pragma loop unroll (5)
    for(int j=0; j<EQ_BANKS; j++) {
        ynl = (1<<(FRACTIONALBITS-1)); // 0.5, for rounding, could be triangular noise
        ynh = 0;
        {ynh, ynl} = macs( eq_coeffs[state.b[j].db][j].b0, xn, ynh, ynl);
        {ynh, ynl} = macs( eq_coeffs[state.b[j].db][j].b1, state.b[j].xn1, ynh, ynl);
        {ynh, ynl} = macs( eq_coeffs[state.b[j].db][j].b2, state.b[j].xn2, ynh, ynl);
        {ynh, ynl} = macs( eq_coeffs[state.b[j].db][j].a1, state.b[j+1].xn1, ynh, ynl);
        {ynh, ynl} = macs( eq_coeffs[state.b[j].db][j].a2, state.b[j+1].xn2, ynh, ynl);
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

		power[j] += (ynh * ynh) >> 10; //for graphic equaliser display
    }
    state.b[EQ_BANKS].xn2 = state.b[EQ_BANKS].xn1;
    state.b[EQ_BANKS].xn1 = ynh;
    if (state.adjustDelay > 0) {
        state.adjustDelay--;
    } else {
        state.adjustCounter--;
        if (state.b[state.adjustCounter].db > state.desiredDb[state.adjustCounter]) {
            state.b[state.adjustCounter].db--;
        }
        if (state.b[state.adjustCounter].db < state.desiredDb[state.adjustCounter]) {
            state.b[state.adjustCounter].db++;
        }
        if (state.adjustCounter == 0) {
            state.adjustCounter = EQ_BANKS;
        }
        state.adjustDelay = 40;
    }
#endif

    return xn;
};

void update_eq_gain(int bank, int gain, biquad_cascade_state_eq_s &state)
{
	state.desiredDb[bank] = gain;
}
