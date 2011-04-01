XMOS Parallel Audio DSP example

:Stable release: 0.6.0  `versioning <https://github.com/xcore/Community/wiki/Versioning>`_)

:Status:  Alpha

:Maintainer:  ThomasGmeinder

:Description:  Configurable Application example for parallel DSP processing of several audio channels

Key Features
============

* Up to 6 channels in, 8 channels out
  IN 1/2 : processed by eq_wrapper (see below), OUT 1/2
  IN 2/3 : processed by crossover thread (see below), OUT 2/3 (below 500Hz), OUT 4/5 (above 500Hz)
  Note: OUT 6/7 are the same as OUT 4/5 on the HW.
  Note: delays is a thread that can be plugged instead of crossover or eq_wrapper
* Audio DSP using concurrent threads. 2 Threads processing 4 channels each in this example.
* Two configurations of Biquad filter (derived from https://github.com/xcore/sc_dsp_filters)
  biquad_cascade_eq.xc : Cascade of 5 Biquads used for the 5-band equaliser
  biquad_crossover.xc. Single Biquad configured as either highshelf or lowshelf filter
* Audio samples are communicated to a configurable set of DSP threads using streaming channels
* Delay buffer example (see delay_bufs and shared_mem_dsp.c)
* Configurability. See User Guide Section
* Wealth of Debug Features (See Debug section)


To Do
=====

* <Bullet pointed list of missing features>

Firmware Overview
=================
* HW Platform: XR-USB-AUDIO-2.0-MC
* DSP Threads:
 - eq_wrapper
 5-Band Equaliser processing 2 channels using peak EQ filters.
 receives control commands to change EQ settings
 Can send level metering data
 - crossover
 Using highshelf filter to suppress frequs above 500Hz, lowshelf filter to suppress freqs below 500Hz
 Note: crossover_proc produces 2 output channels (low and high freqs) from 1 input channel
 - delays
 Using a delay buffer, delays audio of left channel by 5000 samples (0.1 seconds at 48kHz)
 - eq_client
 Periodically Changes Equaliser setup on the fly by switching between different Equaliser Presets.
* Other Threads:
 - iis: 
 I2S interface to codec. up to 6 channels in, 8 channels out
 See Audio Data Flow
 - audio_buffers
 Receives sample stream into input buffers (pingpong buffer per channel)
 Sends sample stream from output buffers (pingpong buffer per channel) 
 Switches pingpong buffers
 Note: the buffers are in shared memory between this thread and the DSP processing threads
* Timing Checks:
 - timing_checks.xta defines static timing checks on real time code
 The checks are run at compile time
 To analyse the routes it in the GUI, Click "Timing->Time" and then run the .xta script
 Note: The script is tool generated but I added comments denoted by #####
 The script is automatically run at compile time, does the xta check and prints a summary:
  Route(0) function: biquad_cascade_block
    Pass, Num Paths: 9, Slack: 480.4 us, Required: 667.0 us, Worst: 186.6 us, Min Core Frequency: 139 MHz
 Note: This means the equaliser needs 29% of the max time it can take at 48kHz. 
  This means it would meet the timing at 96kHz sampling rate as well
* Audio Data Flow (per channel):
 - iis thread 
  ouputs samples of NUM_IN stereo channels over NUM_IN streaming channels
  inputs samples of NUM_OUT stereo channels over NUM_IN streaming channels
 - DSP threads
  input samples over streaming channel(s)
  process the stream on a per-sample basis 
  output samples over streaming channel(s). 
* Input-Output latency: <= one sample period
* Coefficient Generation:
 - All coefficients were created with https://github.com/xcore/sc_dsp_filters 
 - The Makefile configurations can be found in in the source code next to the coefficients
* Debug Support: (controlled by Debug Switches in defines.h)
 - XScope Probes for Equaliser input and output (Oscilloscope view of sample streams from HW in realtime)
 - Ability to override ADC audio input with custom reference signals.
 - Option to run on simulator (for development/debug without HW)
 - Audio Loopback (to test iis interface)
 - XTA timing checks
* User Guide:
 - DSP threads can be plugged in to process selected channels on core0 as shown in main()
 - Configuration Options:
  Number of input and output channels (NUM_IN, NUM_OUT)
  Set of DSP threads (see main()) 
  EQ Bands (EQ_BANKS)
  Optimised assembly Biquad (
  Debug Switches (see defines.h). 
Note: To use XScope XDE 11.2 tools are required. Add xscope library to compile.
Note: Make sure NUM_IN and NUM_OUT matches the set of DSP threads connected to the streaming channels
 - Tool aspects
  Device options (Simulator or Hardware) can be selected in "Run Configurations" and "Debug Configurations"
  For more information see Tools User Guide.

Known Issues
============
* Level metering output from Equaliser not activated
* Limited testing of configuration space. E.g. only at 48kHz
* biquadAsmXover not operational. Must be changed to take coefficient object as argument
* Unexpected data type errors from XScope


Required Repositories
================

* xcommon git\@github.com:xcore/xcommon.git

Support
=======

Issues may be submitted via the Issues tab in this github repo. Response to any issues submitted as at the discretion of the maintainer for this line.