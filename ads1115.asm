stm8/
	#include "STM8L101.inc"

; Config Register $683

i2c_addr_w	EQU $90
i2c_addr_r	EQU $91

sda					EQU 0
scl					EQU 1

	extern RegInput	

	extern mb_address
	extern adc_shift
	extern adc_koef
	extern adc_reg_init
	
	
	extern RegHolding
	extern RegMult_Hiest
	extern RegMult_Hi
	extern RegMult_Lo
	extern RegMult_Loest



	segment 'rom'		
		
.i2c_init:
	bset PC_DDR, #sda							; sda
	bset PC_CR1, #sda							; открытый коллектор
	bset PC_CR2, #sda							; быстрый
	bset PC_DDR, #scl							; scl
	bset PC_CR2, #scl							; быстрый
	
	mov I2C_FREQR,#16							; 1 MHz
	mov I2C_CCRL,#$50							; 100 к√ц
	mov I2C_CCRH,#$0							; 
	mov I2C_ITR,#$0								; выключил прерывани€
	mov I2C_TRISER,#$9						; фронты
	
	bset I2C_CR2, #2 							; вкл ack
	bset I2C_CR1, #0 							; вкл периферии
	ret
	
.i2c_wait_busy:
	btjt I2C_SR3,#1,i2c_wait_busy	; Busy	
	ret

.i2c_wait_TX:
	btjf I2C_SR1,#7,i2c_wait_TX		; TX пуст	
	ret
	
.i2c_start_condition:
	bset I2C_CR2,#0								; старт
i2c_start_condition_wait:				; старт бит сгенерирован?
	btjf I2C_SR1,#0,i2c_start_condition_wait
	ret														; мастер сгенерировал старт-посылку
	
.i2c_stop_condition:
	bset I2C_CR2,#1								; стоп
	ret
	
.i2c_test_addr_complete:
	btjf I2C_SR1,#1,i2c_test_addr_complete	; мастер передал адрес	
i2c_test_master_bit:
	btjf I2C_SR3,#0,i2c_test_master_bit			; установлен режим мастера
	ret
	
.i2c_ads_init:
	call i2c_wait_busy
	call i2c_start_condition
	mov I2C_DR, #i2c_addr_w
	call i2c_test_addr_complete	
	mov I2C_DR, #$01
	call i2c_wait_TX
	;mov I2C_DR, #$06							; диапазон 1 ¬
	;mov I2C_DR, #$0e							; диапазон 0,256 ¬	
	ldw	Y, adc_reg_init
	ld a, yh
	ld	I2C_DR,a
	call i2c_wait_TX
	;mov I2C_DR, #$83							; 128 sps
	;mov I2C_DR, #$03							; 8 sps
	;ldw	Y, adc_reg_init
	ld a, yl
	call i2c_wait_TX	
	bset I2C_CR2, #1							; стоп	
	ret
	
.i2c_ads_read:
	call i2c_wait_busy
	call i2c_start_condition
	mov I2C_DR, #i2c_addr_w
	call i2c_test_addr_complete	
	mov I2C_DR, #$00
	call i2c_wait_TX
	bset I2C_CR2, #1							; стоп
	
	call i2c_wait_busy
	call i2c_start_condition
	mov I2C_DR, #i2c_addr_r
	bset I2C_CR2, #3 							; вкл pos
	bset I2C_CR2, #2 							; вкл ack
	call i2c_test_addr_complete	
i2c_btf_wait:										; 
	btjf I2C_SR1,#2,i2c_btf_wait
	bset I2C_CR2, #1							; стоп
	;mov ads_h,I2C_DR		
	;mov ads_l,I2C_DR	
	;ldw	x, #0											; указатель на ads_h
	ld	a, I2C_DR
	ld	yh,a
	;incw x
	ld	a, I2C_DR
	ld	yl, a
	addw y, adc_shift							;  орректирую по смещению 0
	ldw	RegInput,y
	
		
	clr	RegMult_Hiest
	clr	RegMult_Hi
	clr	RegMult_Lo
	clr	RegMult_Loest

; проверка знака и если он отрицательный, то приведение по модулю
	ldw x,RegInput
	jrpl	znak_ok_1
	negw	x
	
znak_ok_1:
	ldw	y, #6		
	ldw (RegInput,y),x

	ldw y,#7
	ld a,(RegInput,y)
	ldw	y, #4	
	ldw	y,(RegHolding,y)
	mul Y,a		
	addw Y, RegMult_Lo
	ldw	RegMult_Lo, y
	
	
	ldw y,#7
	ld a,(RegInput,y)
	ldw	y, #3	
	ldw	y,(RegHolding,y)
	mul Y,a	
	addw Y, RegMult_Hi
	jrnc	inc_Hi_0
	inc		RegMult_Hiest
inc_Hi_0:
	ldw	RegMult_Hi, y
	
	
	ldw y,#6
	ld a,(RegInput,y)
	ldw	y, #4	
	ldw	y,(RegHolding,y)
	mul Y,a	
	addw Y, RegMult_Hi
	jrnc	inc_Hi_1
	inc		RegMult_Hiest
inc_Hi_1:
	ldw	RegMult_Hi, y
	
	ldw y,#6
	ld a,(RegInput,y)
	ldw	y, #3	
	ldw	y,(RegHolding,y)
	mul Y,a	
	addw Y, RegMult_Hiest
	ldw	RegMult_Hiest, y	

; проверка знака и если он отрицательный, то приведение по модулю
	ldw x,RegInput
	jrpl	znak_ok_2
	
	clrw x
	subw	x, RegMult_Hiest	
	decw	x
	ldw	y, #2	
	ldw	(RegInput,y),x	
	
	clrw x		
	subw	x, RegMult_Lo	
	ldw	y, #4	
	ldw	(RegInput,y),x	
	ret
	
znak_ok_2:
	ldw x,RegMult_Hiest
	ldw	y, #2	
	ldw	(RegInput,y),x

	ldw x,RegMult_Lo
	ldw	y, #4	
	ldw	(RegInput,y),x
	ret
	
	end
	
	