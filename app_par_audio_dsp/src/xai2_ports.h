// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

#include <platform.h>

// 1V1 board

// SPI
#define SPI_MISO       on stdcore[0] : XS1_PORT_1A
#define SPI_SS         on stdcore[0] : XS1_PORT_1B
#define SPI_SCK        on stdcore[0] : XS1_PORT_1C
#define SPI_MOSI       on stdcore[0] : XS1_PORT_1D

// clocking
// also WCK_BNC on 4B
#define WCK_BNC        on stdcore[0] : XS1_PORT_1I
#define SYNC_OUT_4BIT  on stdcore[1] : XS1_PORT_4E
#define MCK_0          on stdcore[0] : XS1_PORT_1L
#define MCK_1          on stdcore[1] : XS1_PORT_1L

// I2S
#define BCK            on stdcore[1] : XS1_PORT_1I
#define WCK            on stdcore[1] : XS1_PORT_1E
#define DAC0           on stdcore[1] : XS1_PORT_1M
#define DAC1           on stdcore[1] : XS1_PORT_1F
#define DAC2           on stdcore[1] : XS1_PORT_1H
#define DAC3           on stdcore[1] : XS1_PORT_1N
#define ADC0           on stdcore[1] : XS1_PORT_1G
#define ADC1           on stdcore[1] : XS1_PORT_1A
#define ADC2           on stdcore[1] : XS1_PORT_1B

// S/PDIF
#define COAXIAL_RX     on stdcore[0] : XS1_PORT_1K
#define COAXIAL_TX     on stdcore[1] : XS1_PORT_1K
#define OPTICAL_RX     on stdcore[0] : XS1_PORT_1J
#define OPTICAL_TX     on stdcore[1] : XS1_PORT_1J

// MIDI
#define MIDI_OUT       on stdcore[1] : XS1_PORT_1O
#define MIDI_IN        on stdcore[1] : XS1_PORT_1P

// control
// SEL_MOD_RST  bit 0: SYNC SEL, bit 1: CODEC MODE, bit 3: CODEC RST (active low)
// PLL_BNC_INT  bit 1: PLL LOCK, bit 2: WCK BNC, bit 3: CODEC INT
#define PHY_RST        on stdcore[0] : XS1_PORT_1M
#define I2C_SDA        on stdcore[1] : XS1_PORT_1C
#define I2C_SCL        on stdcore[1] : XS1_PORT_1D
#define LEDS           on stdcore[1] : XS1_PORT_8B
#define GPIO           on stdcore[1] : XS1_PORT_4F
#define PLL_BNC_INT    on stdcore[1] : XS1_PORT_4B  
#define SEL_MOD_RST    on stdcore[1] : XS1_PORT_4A  

// UIFM
#define UIFM_TXD       on stdcore[0] : XS1_PORT_8A
#define UIFM_RXD       on stdcore[0] : XS1_PORT_8B
#define UIFM_STP_SUS   on stdcore[0] : XS1_PORT_1E
#define UIFM_USB_CLK   on stdcore[0] : XS1_PORT_1H
#define UIFM_REG_WR    on stdcore[0] : XS1_PORT_8C
#define UIFM_REG_RD    on stdcore[0] : XS1_PORT_8D
#define UIFM_FLAG_0    on stdcore[0] : XS1_PORT_1N
#define UIFM_FLAG_1    on stdcore[0] : XS1_PORT_1O
#define UIFM_FLAG_2    on stdcore[0] : XS1_PORT_1P

// ULPI (internal)
#define ULPI_STP       on stdcore[0] : XS1_PORT_1E
#define ULPI_NXT       on stdcore[0] : XS1_PORT_1F
#define ULPI_DATA      on stdcore[0] : XS1_PORT_8B
#define ULPI_DIR       on stdcore[0] : XS1_PORT_1G
#define ULPI_CLK       on stdcore[0] : XS1_PORT_1H

// XSYS / link A (internal)
#define XSYS           on stdcore[0] : XS1_PORT_4B
#define LINK_A         on stdcore[0] : XS1_PORT_4B

// 1V0 board
#if 0

// SPI
#define SPI_MISO      on stdcore[0] : XS1_PORT_1A
#define SPI_SS        on stdcore[0] : XS1_PORT_1B
#define SPI_SCK       on stdcore[0] : XS1_PORT_1C
#define SPI_MOSI      on stdcore[0] : XS1_PORT_1D

// clocking
#define WCK_BNC       on stdcore[0] : XS1_PORT_1I
#define SYNC_0        on stdcore[0] : XS1_PORT_1J
#define SYNC_1        on stdcore[1] : XS1_PORT_1K
#define MCK_0         on stdcore[0] : XS1_PORT_1L
#define MCK_1         on stdcore[1] : XS1_PORT_1L

// I2S
#define BCK           on stdcore[1] : XS1_PORT_1I
#define WCK           on stdcore[1] : XS1_PORT_1E
#define DAC0          on stdcore[1] : XS1_PORT_1M
#define DAC1          on stdcore[1] : XS1_PORT_1F
#define DAC2          on stdcore[1] : XS1_PORT_1H
#define DAC3          on stdcore[1] : XS1_PORT_1N
#define ADC0          on stdcore[1] : XS1_PORT_1G
#define ADC1          on stdcore[1] : XS1_PORT_1A
#define ADC2          on stdcore[1] : XS1_PORT_1B

// S/PDIF
#define SPDIF_RX      on stdcore[0] : XS1_PORT_1K
#define SPDIF_TX      on stdcore[1] : XS1_PORT_1J

// MIDI
#define MIDI_OUT      on stdcore[1] : XS1_PORT_1O
#define MIDI_IN       on stdcore[1] : XS1_PORT_1P

// control
// RST_MCK_BUF  bit 0: MCK SEL, bit 1: CODEC MODE, bit 3: CODEC RST (active low)
// INT_LOCK     bit 1: PLL LOCK, bit 3: CODEC INT
#define PHY_RST       on stdcore[0] : XS1_PORT_1M
#define I2C_SDA       on stdcore[1] : XS1_PORT_1C
#define I2C_SCL       on stdcore[1] : XS1_PORT_1D
#define LEDS          on stdcore[1] : XS1_PORT_8B
#define INT_LOCK      on stdcore[1] : XS1_PORT_4B  
#define RST_MCK_BUF   on stdcore[1] : XS1_PORT_4A  

// UIFM
#define UIFM_TXD      on stdcore[0] : XS1_PORT_8A
#define UIFM_RXD      on stdcore[0] : XS1_PORT_8B
#define UIFM_STP_SUS  on stdcore[0] : XS1_PORT_1E
#define UIFM_USB_CLK  on stdcore[0] : XS1_PORT_1H
#define UIFM_REG_WR   on stdcore[0] : XS1_PORT_8C
#define UIFM_REG_RD   on stdcore[0] : XS1_PORT_8D
#define UIFM_FLAG_0   on stdcore[0] : XS1_PORT_1N
#define UIFM_FLAG_1   on stdcore[0] : XS1_PORT_1O
#define UIFM_FLAG_2   on stdcore[0] : XS1_PORT_1P

// ULPI (internal)
#define ULPI_STP      on stdcore[0] : XS1_PORT_1E
#define ULPI_NXT      on stdcore[0] : XS1_PORT_1F
#define ULPI_DATA     on stdcore[0] : XS1_PORT_8B
#define ULPI_DIR      on stdcore[0] : XS1_PORT_1G
#define ULPI_CLK      on stdcore[0] : XS1_PORT_1H

// XSYS / link A (internal)
#define XSYS          on stdcore[0] : XS1_PORT_4B
#define LINK_A        on stdcore[0] : XS1_PORT_4B

#endif
