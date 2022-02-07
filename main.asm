stm8/
	#include "STM8L101.inc"
	#include "macros.inc"

;	#include "STM8L101.asm"

F_CPU					equ 16000	
LED						equ 4
	
;RX_SIZE				equ 31      ; UART Rx buffer size
;TX_SIZE				equ 31      ; UART Tx buffer size

UniqueID			equ $4925		; ��������� �� �� ����������� 

  segment byte at 0 'ram0'
; �������� �������� �� Inputs � Holding
; 0 - ads_h
; 1 - ads_l
; 2 - ������������ �������� ���� Hiest
; 3 - ������������ �������� ���� Hi
; 4 - ������������ �������� ���� Lo
; 5 - ������������ �������� ���� Lowest
; 6 - ads_h ������
; 7 - ads_l
.RegInput					ds.b 	8
; 0 - ������ ����� ���������� Hi - �� ������������
; 1 - ������ ����� ���������� Lo
; 2 - �������� ���� Hi
; 3 - �������� ����  Lo
; 4 - ����������� ���������� Hi	(Hi:Lo	- 3E8 - 1000)
; 5 - ����������� ���������� Lo
; 6 - ������������� ADS1115 Hi	(Hi:Lo	- 0e03 - �������� 0,256 �, 8 sps)
; 7 - ������������� ADS1115 Lo
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
	bres PB_CR2, #LED					; 2 ��� - ����� ������
		
	mov CLK_CKDIVR,#$0				; ������������ �� ��������
	mov CLK_PCKENR,#$3F				; ������������ ���������
		
clear_ram										; ������� ��� (��� �������)
	ldw X,#0
clear_ram0.l
	clr (X)
	incw X
	cpw X,#ram0_end
	jrule clear_ram0	

	
	ldw	x, mb_address					; �������� ������� ��������� ������ ����������
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
	
	; ����� ������� ������������� ���������
	ldw	x, #$1234							; �������� ������� ��������� ������ ����������
	ldw RegInput,x
	ldw	y, #2	
	ldw	x, #$5678
	ldw	(RegInput,y),x
	ldw	y, #4	
	ldw	x, #$1122
	ldw	(RegInput,y),x
	

	; ������� ������ ����������� ����� ������� (4 ���� ��� 9600)
	bres TIM4_CR1,#0					; set CEN bit to enable the timer	
	bres TIM4_IER,#0					; set bit 0 for update irq's
	mov	TIM4_PSCR,#$0E				; timer prescaler	
	mov TIM4_ARR,#3
	bset TIM4_EGR,#0					; UG: Update generation	
	bset TIM4_CR1,#3					; OPM: One Pulse Mode.	
	bset TIM4_IER,#0					; set bit 0 for update irq's
	bset TIM4_CR1,#2					; URS: Update Request Source
	bset TIM4_CR1,#0					; set CEN bit to enable the timer		
		
	; ������� i2c	
	; (������� ��������� ������ ������������� ����� ������� ������ �� mb)
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
  bres FLASH_IAPSR,#1				; PUL - ���� ������������
  bres FLASH_IAPSR,#3				; DUL - ������ ������������
	ret
	

	end
