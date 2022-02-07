stm8/
	#include "STM8L101.inc"

UartRX equ 2
UartTX equ 3
UartDE equ 4

; Переменные в озу
	extern RegInput
	extern RegHolding

	extern uartrx_cnt
	extern RxBuff
	extern RxBuff_addr
	extern RxBuff_comm
	extern RxBuff_a
	extern RxBuff_q
	extern RxBuff_n

	extern uarttx_cnt
	extern TxBuff	
	extern TxBuff_addr
	extern TxBuff_comm
	extern TxBuff_a
	extern TxBuff_n
	extern TxBuff_d
	extern TxBuff_q
	
	extern uartrx_cnt_save

	extern crc_hi                
	extern crc_lo
	extern crc_cnt
	extern crc_index	
	
	extern temp1_w
	extern temp2_w
	extern temp3_w
	extern temp4_w
	extern temp1_b
	extern temp2_b
	extern temp3_b
	extern temp4_b

; Переменные в eeprom
	extern CRC_Hi_table
	extern CRC_Lo_table
	
	extern mb_address
	extern adc_shift
	extern adc_koef
	extern adc_reg_init
	
; Внешние функции	
	extern i2c_ads_read

	extern unlock_PROG
	extern unlock_DATA
	extern lock_memory
	
	extern delay_10ms

	segment 'rom'	
.uart_init:
	bres PC_DDR, #UartRX			; вход RX
	bset PC_CR1, #UartRX			; подтяжка
	bset PC_DDR, #UartTX			; выход TX 
	bset PC_CR1, #UartTX
	bset PC_DDR, #UartDE			; выход DE
	bset PC_CR1, #UartDE

	mov USART_BRR1,#$68				; настройка UART
	mov USART_BRR2,#$03	

	bres USART_CR1,#0					; CR1_PIEN прерывания на четность отключены
	bres USART_CR1,#2					; CR1_PCEN контроль четности отключен
	bres USART_CR1,#4					; CR1_M 8-битный режим
	bres USART_CR1,#5					; CR1_UARTD 8-битный режим

	bres PC_ODR, #UartDE			; DE - на прием
	bset USART_CR2, #2				; Вкл прием
	bset USART_CR2, #3				; Вкл передачу
	bset USART_CR2, #5				; Вкл прерывание
	;rim
	ret

.parse_modbus:
parse_test_1	
	ld	a,#$8									; проверка - длина пакета 8 байт ($01$03$00$01$00$01$D5$CA)
	sub a,uartrx_cnt_save
	jreq parse_test_2					; пакет слишком короткий или длинный
	ret
	
parse_test_2								; проверка 
	ldw	x,RegHolding
	subw x,uartrx_cnt					; включает в себя RxBuff_addr
	;jrne parse_modbus_end_ret	; адрес неверный
	jreq parse_CRC					; адрес неверный
	ret
parse_CRC
	call RX_CRC
	ldw	y,RxBuff_n
	subw y,crc_hi
;	jrne parse_modbus_end			; КС не корректная	
parse_test_3								; проверка номера команды
	ld	a,#$4
	sub a,RxBuff_comm
	jreq parse_modbus_input_read
parse_test_4								; проверка номера команды	
	ld	a,#$3
	sub a,RxBuff_comm
	jreq parse_modbus_holding_read
parse_test_5								; проверка номера команды	
	ld	a,#$6									
	sub a,RxBuff_comm
	jreq parse_modbus_holding_write
	ld a,#$1										; 
	ld TxBuff_n,a
	jp	parse_modbus_end			; команда не поддерживается

parse_modbus_input_read:		; проверка диапазона (два регистра)
;	ldw x,#$0001
;	subw x,RxBuff_a
;	jrmi parse_modbus_end			; начальный адрес за диапазоном
	ldw x,RxBuff_a
	addw x,RxBuff_q
	subw x,#$0004
	jrpl parse_modbus_end			; выбраны регистры за диапазоном
	jp	mb_input_read

parse_modbus_holding_read:	; проверка диапазона (четыре регистра)
;	ldw x,#$0001
;	subw x,RxBuff_a
;	jrmi parse_modbus_end			; начальный адрес за диапазоном
	ldw x,RxBuff_a
	addw x,RxBuff_q
	subw x,#$0005
	jrpl parse_modbus_end			; выбраны регистры за диапазоном
	jp mb_holding_read

parse_modbus_holding_write:	; проверка диапазона (четыре регистра)
;	ldw x,#$0003
;	subw x,RxBuff_a
;	jrmi parse_modbus_end			; начальный адрес за диапазоном
	ldw x,RxBuff_a
;	addw x,RxBuff_q
	subw x,#$0004
	jrpl parse_modbus_end			; выбраны регистры за диапазоном
	jp mb_holding_write

parse_modbus_end:						; формирую ответ на ошибочный запрос
	ld a,#$3
	ld uarttx_cnt,a
	mov	TxBuff_addr,RxBuff_addr
	mov	TxBuff_comm,RxBuff_comm
	bset TxBuff_comm,#$7				; ответ содержит сообщение об ошибке
	ld a,#$3										; Значение, содержащееся в поле данных запроса, является недопустимой величиной
	ld TxBuff_n,a	
	call TX_CRC	
	
parse_modbus_end_ret:
	ret

.mb_input_read:
	mov	TxBuff_addr,RxBuff_addr
	mov	TxBuff_comm,RxBuff_comm	
	ldw x,RxBuff_q
	ld	a,#2
	mul	X,a
	ld	a,xl
	ld	TxBuff_n,a						; записал количество передаваемых байт из регистров
	ldw x,RxBuff_a
	ld	a,#2
	mul	X,a
	addw x,#RegInput					; смещение
	ld	a,xl									; 
	add a,TxBuff_n
	ld	temp1_b,a	
	clrw y
modbus_input_read_data_copy
	ld a,xl
	cp a,temp1_b              ; 
	jreq modbus_input_read_CRC
	ld a,(RegInput,x)
	ld (TxBuff_d,y),a	
	incw y
	incw x
	jp modbus_input_read_data_copy	
modbus_input_read_CRC
	ld	a,yl
	add a,#3
	ld uarttx_cnt,a
	call TX_CRC
	ret
	
.mb_holding_read:
	mov	TxBuff_addr,RxBuff_addr
	mov	TxBuff_comm,RxBuff_comm	
	ldw x,RxBuff_q
	ld	a,#2
	mul	X,a
	ld	a,xl
	ld	TxBuff_n,a						; записал количество передаваемых байт из регистров
	ldw x,RxBuff_a
	ld	a,#2
	mul	X,a
	addw x,#RegHolding				; смещение
	ld	a,xl									; 
	add a,TxBuff_n
	ld	temp1_b,a	
	clrw y
modbus_holding_read_data_copy
	ld a,xl
	cp a,temp1_b              ; 
	jreq modbus_holding_read_CRC
	ld a,(RegInput,x)
	ld (TxBuff_d,y),a	
	incw y
	incw x
	jp modbus_holding_read_data_copy	
modbus_holding_read_CRC
	ld	a,yl
	add a,#3
	ld uarttx_cnt,a
	call TX_CRC
	ret


.mb_holding_write:					; запись данных в еепром
	call unlock_PROG
	;lock_memory
	ldw y,RxBuff_a
	decw y
	jrmi modbus_holding_write_0
	decw y
	jrmi modbus_holding_write_1
	decw y
	jrmi modbus_holding_write_2
	decw y
	jrmi modbus_holding_write_3
	jp	parse_modbus_end
modbus_holding_write_0:
	ldw	y,RxBuff_q
	ldw	RegHolding,y
	ldw	mb_address,y
	jp	modbus_holding_write_OK
modbus_holding_write_1:
	ldw	y,RxBuff_q
	ldw	x,#2
	ldw	(RegHolding,x),y
	ldw	adc_shift,y
	jp	modbus_holding_write_OK
modbus_holding_write_2:
	ldw	y,RxBuff_q
	ldw	x,#4
	ldw	(RegHolding,x),y
	ldw	adc_koef,y
	jp	modbus_holding_write_OK
modbus_holding_write_3:
	ldw	y,RxBuff_q
	ldw	x,#6
	ldw	(RegHolding,x),y
	ldw	adc_reg_init,y
	jp	modbus_holding_write_OK

modbus_holding_write_OK:	
	mov	TxBuff_addr,RxBuff_addr
	mov	TxBuff_comm,RxBuff_comm
	mov	TxBuff_a,RxBuff_a
	ldw y,RxBuff_a
	ldw TxBuff_a,y
	ldw y,RxBuff_q
	ldw TxBuff_q,y
modbus_holding_write_CRC
	ld	a,#6
	ld uarttx_cnt,a
	call TX_CRC
	call delay_10ms
	call lock_memory
	ret
	
.RX_CRC:
	mov crc_lo,$FF						;первоначально загружаем 0xFF в оба регистра
	mov crc_hi,$FF
	mov crc_cnt, #0						; начинаю с 0-го байта
	; тест на 0 uartrx_cnt_save
	tnz	uartrx_cnt_save
	jreq RX_CRC_cycle_end
	dec uartrx_cnt_save
	dec uartrx_cnt_save
RX_CRC_cycle
	ldw	x, #0									; надо обнулить оба байта регистра
	ld	a, crc_cnt
	ld	xl, a
	ld	a,(RxBuff,x)					; взял байт из сообщения
	xor a,crc_hi
	ld	crc_index,a						; получил индекс-смещения в таблицах
	ld	xl, a
	ld	a,(CRC_Hi_table,x)		; взял байт из таблицы
	xor a,crc_lo
	ld	crc_hi,a
	ld	a,(CRC_Lo_table,x)		; взял байт из таблицы
	ld	crc_lo,a
	inc	crc_cnt
	ld	a,uartrx_cnt_save			; здесь буду тестировать на конец пакета
	cp	a,crc_cnt
	jrne RX_CRC_cycle
RX_CRC_cycle_end
	ret  
	
TX_CRC:
	mov	crc_lo,#$FF						;первоначально загружаем 0xFF в оба регистра
	mov	crc_hi,#$FF
	mov	crc_cnt,#0						; начинаю с 0-го байта
TX_CRC_cycle:
	ldw	x,#0									; надо обнулить оба байта регистра
	ld	a,crc_cnt
	ld	xl,a
	ld	a,(TxBuff,x)					; взял байт из сообщения
	xor a,crc_hi
	ld	crc_index,a						; получил индекс-смещения в таблицах
	ld	xl,a
	ld	a,(CRC_Hi_table,x)		; взял байт из таблицы
	xor a,crc_lo
	ld	crc_hi,a
	ld	a,(CRC_Lo_table,x)		; взял байт из таблицы
	ld	crc_lo,a
	inc	crc_cnt
	ld	a,uarttx_cnt					; здесь буду тестировать на конец пакета
	cp	a,crc_cnt
	jrne TX_CRC_cycle
TX_CRC_cycle_end:
	ld	a, crc_cnt
	ld	xl,a
	ld	a,crc_hi
	ld	(TxBuff,x),a
	incw x
	ld	a,crc_lo
	ld	(TxBuff,x),a					; пакет сформирован
	incw x
	ldw	temp1_w,x
	call uart_mb_write
	ret

.uart_mb_write:
	;bres USART_CR2, #3				; Выкл передачу
	bres USART_CR2, #5				; прерывание выкл
	bset PC_ODR, #UartDE			; DE - на прием
	ldw	x, #0									; надо обнулить оба байта регистра
next:	
	cpw	x,temp1_w
	jreq end_tx	
	ld	a,(TxBuff,x)					; взял байт из сообщения
wait_tx:
	btjf	USART_SR, #7, wait_tx	; wait until TX buffer is empty
	ld		USART_DR, a					; print out the character
	;bset USART_CR2, #3				; Вкл передачу
	incw	x										; increment the character address
	jp		next								; process next character
end_tx:
	btjf	USART_SR, #6, end_tx	; wait for the transmission to complete	
	bres PC_ODR, #UartDE			; DE - на прием
	;bres USART_CR2, #3				; Выкл передачу
	bset USART_CR2, #5				; Вкл прерывание прима
	ret	


	end
	