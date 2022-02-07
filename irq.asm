stm8/

	#include "STM8L101.inc"
	#include "mapping.inc"

	extern main
	
	extern TxBuffer
	extern RxBuffer
	extern TxBuff
	extern RxBuff
	
	extern uartrx
	extern uartrx_cnt
	
	extern uarttx
	extern uarttx_cnt
	extern uartrx_cnt_save
	
	extern parse_modbus
	extern crc
	
	extern i2c_ads_read
	
    segment 'rom'
		
reset.l
    ; initialize SP
    ldw X,#$03ff
    ldw SP,X
    jp main
    jra reset

    interrupt NonHandledInterrupt
NonHandledInterrupt.l
    iret

    interrupt Timer4UpdateInterupt
Timer4UpdateInterupt
  bres	TIM4_SR1,#0				;
	bres	TIM4_EGR,#0				;
	bcpl	PB_ODR,#4					; моргнул светиком на прием пакета
	mov uartrx_cnt_save, uartrx_cnt
	mov uartrx_cnt,#0				; подготовил к прин€тию следующего пакета	
	call i2c_ads_read				; считываю значени€ с датчиков
	call parse_modbus				; парсинг пакета
	iret

		interrupt Int28				; UART Receive register DATA FULL
Int28_UART_RX.l
	sim	
	ldw x, #0								; надо обнулить оба байта регистра
	ld a, uartrx_cnt
	ld xl, a
	ld a, USART_DR
	ld (RxBuff,x),a
	inc uartrx_cnt
	bres	USART_SR,	#5			; RXNEЦ приемный регистр не пустой (прин€ты данные)
endreceive
	; включаю таймер		
	;bres TIM4_CR1,#0				; set CEN bit to enable the timer
	;bres TIM4_CR1,#1				; UDIS: Update disable
	bres TIM4_CR1,#0				; set CEN bit to enable the timer	
	bres TIM4_IER,#0				; set bit 0 for update irq's
	mov TIM4_PSCR,#$0E			; timer prescaler	
	mov TIM4_ARR,#3
	bset TIM4_EGR,#0				; UG: Update generation	
	bset TIM4_CR1,#3				; OPM: One Pulse Mode.	
	bset TIM4_IER,#0				; set bit 0 for update irq's
	bset TIM4_CR1,#2				; URS: Update Request Source
	;bset TIM4_CR1,#7				; Auto-Reload Preload Enable
	bset TIM4_CR1,#0				; set CEN bit to enable the timer	
	rim
	iret
	
	
	
    segment 'vectit'
    dc.l {$82000000+reset}                  ; reset
    dc.l {$82000000+NonHandledInterrupt}    ; trap
    dc.l {$82000000+NonHandledInterrupt}    ; irq0
    dc.l {$82000000+NonHandledInterrupt}    ; irq1
    dc.l {$82000000+NonHandledInterrupt}    ; irq2
    dc.l {$82000000+NonHandledInterrupt}    ; irq3
    dc.l {$82000000+NonHandledInterrupt}    ; irq4
    dc.l {$82000000+NonHandledInterrupt}    ; irq5
    dc.l {$82000000+NonHandledInterrupt}    ; irq6
    dc.l {$82000000+NonHandledInterrupt}    ; irq7
    dc.l {$82000000+NonHandledInterrupt}    ; irq8
    dc.l {$82000000+NonHandledInterrupt}    ; irq9
    dc.l {$82000000+NonHandledInterrupt}    ; irq10
    dc.l {$82000000+NonHandledInterrupt}    ; irq11
    dc.l {$82000000+NonHandledInterrupt}    ; irq12
    dc.l {$82000000+NonHandledInterrupt}    ; irq13
    dc.l {$82000000+NonHandledInterrupt}    ; irq14
    dc.l {$82000000+NonHandledInterrupt}    ; irq15
    dc.l {$82000000+NonHandledInterrupt}    ; irq16
    dc.l {$82000000+NonHandledInterrupt}    ; irq17
    dc.l {$82000000+NonHandledInterrupt}    ; irq18
    dc.l {$82000000+NonHandledInterrupt}    ; irq19 TIM2 Update/Overflow/Trigger/Break
    dc.l {$82000000+NonHandledInterrupt}    ; irq20 TIM2 Capture/Compare
    dc.l {$82000000+NonHandledInterrupt}    ; irq21 TIM3 Update /Overflow/Break
    dc.l {$82000000+NonHandledInterrupt}    ; irq22 TIM3 Capture/Compare
    dc.l {$82000000+NonHandledInterrupt}    ; irq23
    dc.l {$82000000+NonHandledInterrupt}    ; irq24
    dc.l {$82000000+Timer4UpdateInterupt}    ; irq25 TIM4
    dc.l {$82000000+NonHandledInterrupt}    ; irq26
    dc.l {$82000000+NonHandledInterrupt}    ; irq27 USART TX
    dc.l {$82000000+Int28_UART_RX}    			; irq28 USART RX
    dc.l {$82000000+NonHandledInterrupt}    ; irq29 I2C
	
		END
