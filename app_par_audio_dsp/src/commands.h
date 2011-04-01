// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

#ifndef commands_H_
#define commands_H_

/*
 * com.xmos.simplegfxeq protocol demo
 */
#define COMMAND_XMOS_SIMPLEGFXEQ_RequestBandFreqs 0x01
#define COMMAND_XMOS_SIMPLEGFXEQ_SetBandFreqs 0x02
#define COMMAND_XMOS_SIMPLEGFXEQ_SetBandBoost 0x03
#define COMMAND_XMOS_SIMPLEGFXEQ_BandPowerOutput 0x04

#define COMMAND_XMOS_SIMPLEGFXEQ_RequestBandFreqs_messageSize 1
#define COMMAND_XMOS_SIMPLEGFXEQ_SetBandFreqs_messageSize 2 + (5 * 4) //2 + number of bands * size of int
#define COMMAND_XMOS_SIMPLEGFXEQ_SetBandBoost_messageSize 3
#define COMMAND_XMOS_SIMPLEGFXEQ_BandPowerOutput_messageSize 1 + (5 * 2) //2 + (number of bands * number of channels)

#define COMMAND_XMOS_SIMPLEGFXEQ_SetBandFreqs_DataOffset_messageType 0
#define COMMAND_XMOS_SIMPLEGFXEQ_SetBandFreqs_DataOffset_NumberOfBands 1
#define COMMAND_XMOS_SIMPLEGFXEQ_SetBandFreqs_DataOffset_BandFreqsStart 2

#define COMMAND_XMOS_SIMPLEGFXEQ_SetBandBoost_DataOffset_messageType 0
#define COMMAND_XMOS_SIMPLEGFXEQ_SetBandBoost_DataOffset_bandNumber 1
#define COMMAND_XMOS_SIMPLEGFXEQ_SetBandBoost_DataOffset_boostValue 2

#define COMMAND_XMOS_SIMPLEGFXEQ_BandPowerOutput_DataOffset_messageType 0
#define COMMAND_XMOS_SIMPLEGFXEQ_BandPowerOutput_DataOffset_PowerOutputStart 1

#define MAX_PENDING_MESSAGE_SIZE 8
#define COMMANDS_TO_SEND_OFFSET 0
#define DSP_CONTROL_STATE_OFFSET 1
#define UPDATE_BOOST_SETTINGS_START_OFFSET 2

#define DSP_CONTROL_STATE_MASK 0x01
#define SEND_BAND_FREQS_MASK 0x02
#define UPDATE_BOOST_SETTINGS_MASK 0x04
#define PROTOCOL_INIT_COMPLETE_MASK 0x08

#endif
