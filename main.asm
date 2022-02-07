stm8/
	#include "STM8L101.inc"
	#include "macros.inc"

;	#include "STM8L101.asm"

F_CPU					equ 16000	
LED						equ 4
	
;RX_SIZE				equ 31      ; UART Rx buffer size
;TX_SIZE				equ 31      ; UART Tx buffer size

UniqueID			equ $4925		; указатель на ИД контроллера 

  segment byte at 0 'ram0'
; Раскидал регистры по Inputs и Holding
; 0 - ads_h
; 1 - ads_l
; 2 - рассчитанное значение тока Hiest
; 3 - рассчитанное значение тока Hi
; 4 - рассчитанное значение тока Lo
; 5 - рассчитанное значение тока Lowest
; 6 - ads_h модуль
; 7 - ads_l
.RegInput					ds.b 	8
; 0 - модбас адрес устройства Hi - не используется
; 1 - модбас адрес устройства Lo
; 2 - смещение нуля Hi
; 3 - смещение нуля  Lo
; 4 - коэффициент приведения Hi	(Hi:Lo	- 3E8 - 1000)
; 5 - коэффициент приведения Lo
; 6 - инициализация ADS1115 Hi	(Hi:Lo	- 0e03 - диапазон 0,256 В, 8 sps)
; 7 - инициализация ADS1115 Lo
.RegHolding				ds.b 	8

.RegMult_Hiest		ds.b
.RegMult_Hi				ds.b
.RegMult_Lo				ds.b
.RegMult_Loest		ds.b


  segment byte at 18 'ram0'
.uartrx_cnt				ds.b
.RxBuff
.RxBuff_addr			ds.b
.RxBuff_comm			ds.b
.RxBuff_a					ds.w
.RxBuff_q					ds.w
.RxBuff_n					ds.b

  segment byte at 38 'ram0'
.uarttx_cnt				ds.b
.TxBuff
.TxBuff_addr			ds.b
.TxBuff_comm			ds.b
.TxBuff_a
.TxBuff_n					ds.b
.TxBuff_d					ds.b
.TxBuff_q					ds.w

  segment byte at 58 'ram0'
.uartrx_cnt_save	ds.b	8

.crc_hi						ds.b                   
.crc_lo						ds.b
.crc_cnt					ds.b
.crc_index				ds.b

  segment byte at 78 'ram0'
.temp1_w					ds.w
.temp2_w					ds.w
.temp3_w					ds.w
.temp4_w					ds.w
.temp1_b					ds.b
.temp2_b					ds.b
.temp3_b					ds.b
.temp4_b					ds.b

ram0_end					ds.b

	extern delay
	
	extern i2c_init
	extern i2c_ads_init	
	
	extern uart_init
	extern uart_write_str
	extern modbus_TX

	extern CRC_Hi_table
	extern CRC_Lo_table
	
	extern mb_address
	extern adc_shift
	extern adc_koef
	extern adc_reg_init	
	
		segment 'rom'		
.main
	bset PB_DDR, #LED
	bset PB_CR1, #LED
	bres PB_CR2, #LED					; 2 МГц - можно убрать
		
	mov CLK_CKDIVR,#$0				; Тактирование на максимум
	mov CLK_PCKENR,#$3F				; Тактирование периферии
		
clear_ram										; очистка озу (для отладки)
	ldw X,#0
clear_ram0.l
	clr (X)
	incw X
	cpw X,#ram0_end
	jrule clear_ram0	

	
	ldw	x, mb_address					; заполняю таблицу регистров модбас значениями
	ldw RegHolding,x
	ldw	y, #2	
	ldw	x, adc_shift
	ldw	(RegHolding,y),x
	ldw	y, #4	
	ldw	x, adc_koef
	ldw	(RegHolding,y),x
	ldw	y, #6	
	ldw	x, adc_reg_init
	ldw	(RegHolding,y),x
	
	; Можно удалить инициализацию регистров
	ldw	x, #$1234							; заполняю таблицу регистров модбас значениями
	ldw RegInput,x
	ldw	y, #2	
	ldw	x, #$5678
	ldw	(RegInput,y),x
	ldw	y, #4	
	ldw	x, #$1122
	ldw	(RegInput,y),x
	

	; включаю таймер определения конца посылки (4 мсек для 9600)
	bres TIM4_CR1,#0					; set CEN bit to enable the timer	
	bres TIM4_IER,#0					; set bit 0 for update irq's
	mov	TIM4_PSCR,#$0E				; timer prescaler	
	mov TIM4_ARR,#3
	bset TIM4_EGR,#0					; UG: Update generation	
	bset TIM4_CR1,#3					; OPM: One Pulse Mode.	
	bset TIM4_IER,#0					; set bit 0 for update irq's
	bset TIM4_CR1,#2					; URS: Update Request Source
	bset TIM4_CR1,#0					; set CEN bit to enable the timer		
		
	; Включаю i2c	
	; (сделать повторный запуск инициализации после каждого ответа по mb)
	call i2c_init
	call i2c_ads_init
	
	mov uartrx_cnt, #0
	mov uartrx_cnt_save, #0
	call uart_init
	
	rim
	;call unlock_PROG
	;mov	mb_address,#2
	
mloop:
	jp mloop

.unlock_PROG:
	mov	FLASH_PUKR,#$56
	mov	FLASH_PUKR,#$AE
	ret
	
.unlock_DATA:
	mov	FLASH_DUKR,#$AE
	mov	FLASH_DUKR,#$56
	ret

.lock_memory:
  bres FLASH_IAPSR,#1				; PUL - флеш заблокировал
  bres FLASH_IAPSR,#3				; DUL - еепром заблокировал
	ret
	

	end
