/*
 * xover.h
 *
 *  Created on: Mar 28, 2011
 *      Author: thomas_mac
 */

#include "defines.h"
#include "biquad_coeffs.h"

#ifndef XOVER_H_
#define XOVER_H_

typedef struct {
    struct {int xn1; int xn2; int db;} b[XOVER_BANKS+1];
    int adjustDelay;
    int adjustCounter;
    int desiredDb[XOVER_BANKS];
} biquad_state_xover_s;

void init_xover(biquad_state_xover_s &state, int zeroDb);

int biquad_xover(biquad_state_xover_s &state, coeffs_s &coeffs, int xn);

#endif /* XOVER_H_ */
