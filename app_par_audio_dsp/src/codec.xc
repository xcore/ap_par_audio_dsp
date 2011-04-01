// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

#include <platform.h>
#include <assert.h>
#include <print.h>

int regrd(int addr, int device, out port scl, port sda);
void regwr(int addr, int data, int device, out port scl, port sda);

#define REGRD_CODEC(reg) regrd(reg, 0x90, scl, sda)
#define REGWR_CODEC(reg, val) regwr(reg, val, 0x90, scl, sda)

void reset_codec(out port rst)
{
  int mode = 0x2;  // clocks disconnected
  int sel = 0x0;   // XCore sync rather than BNC input
  timer tmr;
  unsigned t;
  tmr :> t;

  rst <: 0x8 | mode | sel;
  t += 10000;
  tmr when timerafter(t) :> void;

  rst <: 0x0 | mode | sel;
  t += 10000;
  tmr when timerafter(t) :> void;

  rst <: 0x8 | mode | sel;
  t += 10000;
  tmr when timerafter(t) :> void;
}

void init_codec(out port scl, port sda, int codec_is_master, int mic_input, int instr_input)
{
  // Interface Formats Register (Address 04h)
  // 7    Freeze Controls                    (FREEZE)  = 0
  // 6    Auxiliary Digital Interface Format (AUX_DIF) = 0
  // 5:3  DAC Digital Interface Format       (DAC_DIF) = 001 (I2S, 24bit)
  // 2:0  ADC Digital Interface Format       (ADC_DIF) = 001 (I2S, 24bit)
  REGWR_CODEC(0x04, 0b00001001);
	assert(REGRD_CODEC(0x04) == 0b00001001);

  // ADC Control & DAC De-Emphasis (Address 05h)
  // 7   ADC1-2_HPF FREEZE = 0
  // 6   ADC3_HPF FREEZE = 0
  // 5   DAC_DEM = 0
  // 4   ADC1_SINGLE = 1(single ended)
  // 3   ADC2_SINGLE = 1
  // 2   ADC3_SINGLE = 1
  // 1   AIN5_MUX = microphone input
  // 0   AIN6_MUX = instrument input
  REGWR_CODEC(0x05, 0b00011100 | (mic_input << 1) | instr_input);
	assert(REGRD_CODEC(0x05) == (0b00011100 | (mic_input << 1) | instr_input));

  // Functional Mode (Address 03h)
  if (codec_is_master) {
    // 7:6 	DAC Functional Mode  (single speed master) = 00
    // 5:4	ADC Functional Mode  (single speed master) = 00
    // 3:1	MCLK Frequency       (2.048-25.6MHz, MCK=512WCK) = 010
    // 0		Reserved
    REGWR_CODEC(0x03, 0b00000100);
    assert(REGRD_CODEC(0x03) == 0b00000100);
  }
  else {
    // 7:6 	DAC Functional Mode  (slave auto detect) = 11
    // 5:4	ADC Functional Mode  (slave auto detect) = 11
    // 3:1	MCLK Frequency       (2.048-25.6MHz, MCK=512WCK) = 010
    // 0		Reserved
    REGWR_CODEC(0x03, 0b11110100);
    assert(REGRD_CODEC(0x03) == 0b11110100);
  }

#ifndef SHARED_SILENT
	printstr("CODEC present and configured as ");
  if (codec_is_master)
    printstrln("master");
  else
    printstrln("slave");

  if (mic_input) {
    printstrln("microphone input enabled");
  }
  if (instr_input) {
    printstrln("instrument input enabled");
  }
#endif
}
