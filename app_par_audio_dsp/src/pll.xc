// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

#include <platform.h>
#include <assert.h>
#include <print.h>

int regrd(int addr, int device, out port scl, port sda);
void regwr(int addr, int data, int device, out port scl, port sda);

#define REGRD_PLL(reg) regrd(reg, 0x9C, scl, sda)
#define REGWR_PLL(reg, val) regwr(reg, val, 0x9C, scl, sda)

void init_pll(unsigned mult, out port scl, port sda)
{
  REGWR_PLL(0x03, 0x03);
  REGWR_PLL(0x05, 0x01);
  REGWR_PLL(0x16, 0x00);

  // check
  assert(REGRD_PLL(0x03) == 0x03);
  assert(REGRD_PLL(0x05) == 0x01);
  assert(REGRD_PLL(0x16) == 0x00);  // PLL lock active low

  // multiplier is translated to 20.12 format by shifting left by 12
  REGWR_PLL(0x06, (mult >> 12) & 0xFF);
  REGWR_PLL(0x07, (mult >> 4) & 0xFF);
  REGWR_PLL(0x08, (mult << 4) & 0xFF);
  REGWR_PLL(0x09, 0x00);

  // check
  assert(REGRD_PLL(0x06) == ((mult >> 12) & 0xFF));
  assert(REGRD_PLL(0x07) == ((mult >> 4) & 0xFF));
  assert(REGRD_PLL(0x08) == ((mult << 4) & 0xFF));
  assert(REGRD_PLL(0x09) == 0x00);

#ifndef SHARED_SILENT
  printstrln("CS2300 present and configured");
#endif
}

void clkgen(int freq, out port p, chanend stop)
{
  timer tmr;
  int period = XS1_TIMER_MHZ * 1000000 / freq / 2;
  unsigned t;
  int x = 0;
  tmr :> t;
  while (1) {
    t += period;
    select {
      case tmr when timerafter(t) :> void: break;
      case stop :> int: return;
    }
    p <: x;
    x = !x;
  }
}
