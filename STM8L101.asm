stm8/

; STM8L101.asm
; Copyright (c) 2003-2017 STMicroelectronics
; STM8L101

	BYTES		; following addresses are 8-bit length

	segment byte at 0-7F 'periph'

	WORDS		; following addresses are 16-bit length

	segment byte at 5000 'periph2'


; Port A at 0x5000
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.PA_ODR			DS.B 1		; Port A data output latch register
.PA_IDR			DS.B 1		; Port A input pin value register
.PA_DDR			DS.B 1		; Port A data direction register
.PA_CR1			DS.B 1		; Port A control register 1
.PA_CR2			DS.B 1		; Port A control register 2

; Port B at 0x5005
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.PB_ODR			DS.B 1		; Port B data output latch register
.PB_IDR			DS.B 1		; Port B input pin value register
.PB_DDR			DS.B 1		; Port B data direction register
.PB_CR1			DS.B 1		; Port B control register 1
.PB_CR2			DS.B 1		; Port B control register 2

; Port C at 0x500a
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.PC_ODR			DS.B 1		; Port C data output latch register
.PC_IDR			DS.B 1		; Port C input pin value register
.PC_DDR			DS.B 1		; Port C data direction register
.PC_CR1			DS.B 1		; Port C control register 1
.PC_CR2			DS.B 1		; Port C control register 2

; Port D at 0x500f
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.PD_ODR			DS.B 1		; Port D data output latch register
.PD_IDR			DS.B 1		; Port D input pin value register
.PD_DDR			DS.B 1		; Port D data direction register
.PD_CR1			DS.B 1		; Port D control register 1
.PD_CR2			DS.B 1		; Port D control register 2
reserved1		DS.B 60		; unused

; Flash at 0x5050
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.FLASH_CR1			DS.B 1		; Flash control register 1
.FLASH_CR2			DS.B 1		; Flash control register 2
.FLASH_PUKR			DS.B 1		; Flash Program memory unprotection register
.FLASH_DUKR			DS.B 1		; Data EEPROM unprotection register
.FLASH_IAPSR			DS.B 1		; Flash in-application programming status register
reserved2		DS.B 75		; unused

; External Interrupt Control Register (ITC) at 0x50a0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.EXTI_CR1			DS.B 1		; External interrupt control register 1
.EXTI_CR2			DS.B 1		; External interrupt control register 2
.EXTI_CR3			DS.B 1		; External interrupt control register 3
.EXTI_SR1			DS.B 1		; External interrupt status register 1
.EXTI_SR2			DS.B 1		; External interrupt status register 2
.EXTI_CONF			DS.B 1		; External interrupt port select register

; Wait For Event (WFE) at 0x50a6
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.WFE_CR1			DS.B 1		; WFE control register 1
.WFE_CR2			DS.B 1		; WFE control register 2
reserved3		DS.B 8		; unused

; Reset (RST) at 0x50b0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.RST_CR			DS.B 1		; Reset control register
.RST_SR			DS.B 1		; Reset status register
reserved4		DS.B 14		; unused

; Clock Control (CLK) at 0x50c0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.CLK_CKDIVR			DS.B 1		; Clock divider register
reserved5		DS.B 2		; unused
.CLK_PCKENR			DS.B 1		; Peripheral clock gating register
reserved6		DS.B 1		; unused
.CLK_CCOR			DS.B 1		; Configurable clock control register
reserved7		DS.B 26		; unused

; Independent Watchdog (IWDG) at 0x50e0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.IWDG_KR			DS.B 1		; IWDG Key Register
.IWDG_PR			DS.B 1		; IWDG Prescaler Register
.IWDG_RLR			DS.B 1		; IWDG Reload Register
reserved8		DS.B 13		; unused

; Auto Wake-Up (AWU) at 0x50f0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.AWU_CSR			DS.B 1		; AWU Control/Status Register
.AWU_APR			DS.B 1		; AWU asynchronous prescaler buffer register
.AWU_TBR			DS.B 1		; AWU Timebase selection register

; Beeper (BEEP) at 0x50f3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.BEEP_CSR			DS.B 1		; BEEP Control/Status Register
reserved9		DS.B 268		; unused

; Serial Peripheral Interface (SPI) at 0x5200
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.SPI_CR1			DS.B 1		; SPI Control Register 1
.SPI_CR2			DS.B 1		; SPI Control Register 2
.SPI_ICR			DS.B 1		; SPI Interrupt Control Register
.SPI_SR			DS.B 1		; SPI Status Register
.SPI_DR			DS.B 1		; SPI Data Register
reserved10		DS.B 11		; unused

; I2C Bus Interface (I2C) at 0x5210
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.I2C_CR1			DS.B 1		; I2C control register 1
.I2C_CR2			DS.B 1		; I2C control register 2
.I2C_FREQR			DS.B 1		; I2C frequency register
.I2C_OARL			DS.B 1		; I2C Own address register low
.I2C_OARH			DS.B 1		; I2C Own address register high
reserved11		DS.B 1		; unused
.I2C_DR			DS.B 1		; I2C data register
.I2C_SR1			DS.B 1		; I2C status register 1
.I2C_SR2			DS.B 1		; I2C status register 2
.I2C_SR3			DS.B 1		; I2C status register 3
.I2C_ITR			DS.B 1		; I2C interrupt control register
.I2C_CCRL			DS.B 1		; I2C Clock control register low
.I2C_CCRH			DS.B 1		; I2C Clock control register high
.I2C_TRISER			DS.B 1		; I2C TRISE register
reserved12		DS.B 18		; unused

; Universal synch/asynch receiver transmitter (USART) at 0x5230
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.USART_SR			DS.B 1		; USART Status Register
.USART_DR			DS.B 1		; USART Data Register
.USART_BRR1			DS.B 1		; USART Baud Rate Register 1
.USART_BRR2			DS.B 1		; USART Baud Rate Register 2
.USART_CR1			DS.B 1		; USART Control Register 1
.USART_CR2			DS.B 1		; USART Control Register 2
.USART_CR3			DS.B 1		; USART Control Register 3
.USART_CR4			DS.B 1		; USART Control Register 4
reserved13		DS.B 24		; unused

; 16-Bit Timer 2 (TIM2) at 0x5250
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.TIM2_CR1			DS.B 1		; TIM2 Control register 1
.TIM2_CR2			DS.B 1		; TIM2 Control register 2
.TIM2_SMCR			DS.B 1		; TIM2 Slave Mode Control register
.TIM2_ETR			DS.B 1		; TIM2 External trigger register
.TIM2_IER			DS.B 1		; TIM2 Interrupt enable register
.TIM2_SR1			DS.B 1		; TIM2 Status register 1
.TIM2_SR2			DS.B 1		; TIM2 Status register 2
.TIM2_EGR			DS.B 1		; TIM2 Event Generation register
.TIM2_CCMR1			DS.B 1		; TIM2 Capture/Compare mode register 1
.TIM2_CCMR2			DS.B 1		; TIM2 Capture/Compare mode register 2
.TIM2_CCER1			DS.B 1		; TIM2 Capture/Compare enable register 1
.TIM2_CNTRH			DS.B 1		; Data bits High
.TIM2_CNTRL			DS.B 1		; Data bits Low
.TIM2_PSCR			DS.B 1		; TIM2 Prescaler register
.TIM2_ARRH			DS.B 1		; Data bits High
.TIM2_ARRL			DS.B 1		; Data bits Low
.TIM2_CCR1H			DS.B 1		; Data bits High
.TIM2_CCR1L			DS.B 1		; Data bits Low
.TIM2_CCR2H			DS.B 1		; Data bits High
.TIM2_CCR2L			DS.B 1		; Data bits Low
.TIM2_BKR			DS.B 1		; TIM2 Break register
.TIM2_OISR			DS.B 1		; TIM2 Output idle state register
reserved14		DS.B 26		; unused

; 16-Bit Timer 3 (TIM3) at 0x5280
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.TIM3_CR1			DS.B 1		; TIM3 Control register 1
.TIM3_CR2			DS.B 1		; TIM3 Control register 2
.TIM3_SMCR			DS.B 1		; TIM3 Slave Mode Control register
.TIM3_ETR			DS.B 1		; TIM3 External trigger register
.TIM3_IER			DS.B 1		; TIM3 Interrupt enable register
.TIM3_SR1			DS.B 1		; TIM3 Status register 1
.TIM3_SR2			DS.B 1		; TIM3 Status register 2
.TIM3_EGR			DS.B 1		; TIM3 Event Generation register
.TIM3_CCMR1			DS.B 1		; TIM3 Capture/Compare mode register 1
.TIM3_CCMR2			DS.B 1		; TIM3 Capture/Compare mode register 2
.TIM3_CCER1			DS.B 1		; TIM3 Capture/Compare enable register 1
.TIM3_CNTRH			DS.B 1		; Data bits High
.TIM3_CNTRL			DS.B 1		; Data bits Low
.TIM3_PSCR			DS.B 1		; TIM3 Prescaler register
.TIM3_ARRH			DS.B 1		; Data bits High
.TIM3_ARRL			DS.B 1		; Data bits Low
.TIM3_CCR1H			DS.B 1		; Data bits High
.TIM3_CCR1L			DS.B 1		; Data bits Low
.TIM3_CCR2H			DS.B 1		; Data bits High
.TIM3_CCR2L			DS.B 1		; Data bits Low
.TIM3_BKR			DS.B 1		; TIM3 Break register
.TIM3_OISR			DS.B 1		; TIM3 Output idle state register
reserved15		DS.B 74		; unused

; 8-Bit  Timer 4 (TIM4) at 0x52e0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.TIM4_CR1			DS.B 1		; TIM4 Control register 1
.TIM4_CR2			DS.B 1		; TIM4 Control register 2
.TIM4_SMCR			DS.B 1		; TIM4 Slave Mode Control register
.TIM4_IER			DS.B 1		; TIM4 Interrupt enable register
.TIM4_SR1			DS.B 1		; TIM4 Status register 1
.TIM4_EGR			DS.B 1		; TIM4 Event Generation register
.TIM4_CNTR			DS.B 1		; TIM4 Counter
.TIM4_PSCR			DS.B 1		; TIM4 Prescaler register
.TIM4_ARR			DS.B 1		; TIM4 Auto-reload register
reserved16		DS.B 22		; unused

; Infra Red Interface (IR) at 0x52ff
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.IR_CR			DS.B 1		; Infra-red control register

; Comparators (CMP) at 0x5300
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.COMP_CR			DS.B 1		; Comparator control register
.COMP_CSR			DS.B 1		; Comparator status register
.COMP_CCS			DS.B 1		; Comparator channel selection register
reserved17		DS.B 11357		; unused

;  Global configuration register (CFG) at 0x7f60
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.CFG_GCR			DS.B 1		; CFG Global configuration register
reserved18		DS.B 15		; unused

; Interrupt Software Priority Register (ITC) at 0x7f70
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.ITC_SPR1			DS.B 1		; Interrupt Software priority register 1
.ITC_SPR2			DS.B 1		; Interrupt Software priority register 2
.ITC_SPR3			DS.B 1		; Interrupt Software priority register 3
.ITC_SPR4			DS.B 1		; Interrupt Software priority register 4
.ITC_SPR5			DS.B 1		; Interrupt Software priority register 5
.ITC_SPR6			DS.B 1		; Interrupt Software priority register 6
.ITC_SPR7			DS.B 1		; Interrupt Software priority register 7
.ITC_SPR8			DS.B 1		; Interrupt Software priority register 8

	end
