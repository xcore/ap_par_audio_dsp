// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>


#ifndef EQ_CLIENT_H_
#define EQ_CLIENT_H_


#endif /* EQ_CLIENT_H_ */
/** eq_client
*
* Client to control Equaliser Settings
*
* \param c_ctrl[] : array of control channels
* \param c_DSP_activity[] : array of DSP monitoring channels
**/
void eq_client(chanend c_ctrl[], streaming chanend c_DSP_activity[]);


/** eq_client
*
* Set new desiredDb index for a chosen frequency band
* See eq_dsp_wrapper.xc for the complementary side of the communication protocol.
*
* \param c_ctrl : control channel
* \param band : filter bank index [0..EQ_BANKS-1]
* \param db_idx : Db index  [0..20] ([0dB..-20dB])
**/
void eq_client_set_band_db(chanend c_ctrl, char band, char db_idx);
