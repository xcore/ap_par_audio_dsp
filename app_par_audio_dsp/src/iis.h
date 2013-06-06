// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

///////////////////////////////////////////////////////////////////////////////
//
// Multichannel IIS master receiver-transmitter
//
// Version 1.0
// 9 Dec 2009
//
// iis.h
//


#include "defines.h"

#ifndef _iis_h_
#define _iis_h_

// BCK is soft divided off MCK
// MCK frequency is MCK_BCK_RATIO times BCK frequency
#ifndef MCK_BCK_RATIO
#define MCK_BCK_RATIO 8
#endif

// resources for IIS
struct iis {
  // clock blocks
  // one for MCK, one for BCK
  clock cb1, cb2;

  // clock ports
  in port mck;
  out buffered port:32 bck;
  out buffered port:32 wck;

  // data ports
  in buffered port:32 din[NUM_IN];
  out buffered port:32 dout[NUM_OUT];
};

// samples are returned left-aligned
// e.g. 24-bit audio will look like 0x12345600 (positive) or 0xFF123400 (negative)
// termination: send a control token down c_out, will be pinged back via c_in
void iis(struct iis &r_iis, streaming chanend c_in[NUM_IN], streaming chanend c_out[NUM_OUT]);

#endif
