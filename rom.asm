stm8/
; ????????????? ???????????? ?????? ?????????
;	segment byte at 8700-87FF 'eprom'
;		segment at 8700 'eprom'
	segment byte at 85F0-85FF 'eprom'
		segment at 85F0 'eprom'
; ????????? ?? ????????? ???????? ??? ???????????????? ?? ??????
.mb_address:		dc.w $0001			; ????? ??????????
.adc_shift:			dc.w $0000			; ???????? ???? ????????
.adc_koef:			dc.w 1000				; ??????????? ???????? ? ??? (???????????)
.adc_reg_init:	dc.w $0e03			; ????????????? ??? 1115 ???? ????????? 
																; (0e03 - ???????? 0,256 ?, 8 sps)
																; (0683 - ???????? 1,000 ?, 128 sps)


;	segment byte at 8500-87FF 'table'	
;		segment 'table'
	segment byte at 8600-87FF 'table'	
		segment 'table'
.CRC_Hi_table:
  dc.b $00,$c1,$81,$40,$01,$c0,$80,$41
  dc.b $01,$c0,$80,$41,$00,$c1,$81,$40
  dc.b $01,$c0,$80,$41,$00,$c1,$81,$40
  dc.b $00,$c1,$81,$40,$01,$c0,$80,$41
  dc.b $01,$c0,$80,$41,$00,$c1,$81,$40
  dc.b $00,$c1,$81,$40,$01,$c0,$80,$41
  dc.b $00,$c1,$81,$40,$01,$c0,$80,$41
  dc.b $01,$c0,$80,$41,$00,$c1,$81,$40 
  dc.b $01,$c0,$80,$41,$00,$c1,$81,$40
  dc.b $00,$c1,$81,$40,$01,$c0,$80,$41
  dc.b $00,$c1,$81,$40,$01,$c0,$80,$41
  dc.b $01,$c0,$80,$41,$00,$c1,$81,$40
  dc.b $00,$c1,$81,$40,$01,$c0,$80,$41
  dc.b $01,$c0,$80,$41,$00,$c1,$81,$40
  dc.b $01,$c0,$80,$41,$00,$c1,$81,$40
  dc.b $00,$c1,$81,$40,$01,$c0,$80,$41
  dc.b $01,$c0,$80,$41,$00,$c1,$81,$40
  dc.b $00,$c1,$81,$40,$01,$c0,$80,$41
  dc.b $00,$c1,$81,$40,$01,$c0,$80,$41
  dc.b $01,$c0,$80,$41,$00,$c1,$81,$40
  dc.b $00,$c1,$81,$40,$01,$c0,$80,$41
  dc.b $01,$c0,$80,$41,$00,$c1,$81,$40
  dc.b $01,$c0,$80,$41,$00,$c1,$81,$40
  dc.b $00,$c1,$81,$40,$01,$c0,$80,$41
  dc.b $00,$c1,$81,$40,$01,$c0,$80,$41
  dc.b $01,$c0,$80,$41,$00,$c1,$81,$40
  dc.b $01,$c0,$80,$41,$00,$c1,$81,$40
  dc.b $00,$c1,$81,$40,$01,$c0,$80,$41
  dc.b $01,$c0,$80,$41,$00,$c1,$81,$40
  dc.b $00,$c1,$81,$40,$01,$c0,$80,$41
  dc.b $00,$c1,$81,$40,$01,$c0,$80,$41
  dc.b $01,$c0,$80,$41,$00,$c1,$81,$40

.CRC_Lo_table:
  dc.b $00,$c0,$c1,$01,$c3,$03,$02,$c2
  dc.b $c6,$06,$07,$c7,$05,$c5,$c4,$04
  dc.b $cc,$0c,$0d,$cd,$0f,$cf,$ce,$0e
  dc.b $0a,$ca,$cb,$0b,$c9,$09,$08,$c8
  dc.b $d8,$18,$19,$d9,$1b,$db,$da,$1a
  dc.b $1e,$de,$df,$1f,$dd,$1d,$1c,$dc
  dc.b $14,$d4,$d5,$15,$d7,$17,$16,$d6
  dc.b $d2,$12,$13,$d3,$11,$d1,$d0,$10
  dc.b $f0,$30,$31,$f1,$33,$f3,$f2,$32
  dc.b $36,$f6,$f7,$37,$f5,$35,$34,$f4
  dc.b $3c,$fc,$fd,$3d,$ff,$3f,$3e,$fe
  dc.b $fa,$3a,$3b,$fb,$39,$f9,$f8,$38
  dc.b $28,$e8,$e9,$29,$eb,$2b,$2a,$ea
  dc.b $ee,$2e,$2f,$ef,$2d,$ed,$ec,$2c
  dc.b $e4,$24,$25,$e5,$27,$e7,$e6,$26
  dc.b $22,$e2,$e3,$23,$e1,$21,$20,$e0
  dc.b $a0,$60,$61,$a1,$63,$a3,$a2,$62
  dc.b $66,$a6,$a7,$67,$a5,$65,$64,$a4
  dc.b $6c,$ac,$ad,$6d,$af,$6f,$6e,$ae
  dc.b $aa,$6a,$6b,$ab,$69,$a9,$a8,$68
  dc.b $78,$b8,$b9,$79,$bb,$7b,$7a,$ba
  dc.b $be,$7e,$7f,$bf,$7d,$bd,$bc,$7c
  dc.b $b4,$74,$75,$b5,$77,$b7,$b6,$76
  dc.b $72,$b2,$b3,$73,$b1,$71,$70,$b0
  dc.b $50,$90,$91,$51,$93,$53,$52,$92
  dc.b $96,$56,$57,$97,$55,$95,$94,$54
  dc.b $9c,$5c,$5d,$9d,$5f,$9f,$9e,$5e
  dc.b $5a,$9a,$9b,$5b,$99,$59,$58,$98
  dc.b $88,$48,$49,$89,$4b,$8b,$8a,$4a
  dc.b $4e,$8e,$8f,$4f,$8d,$4d,$4c,$8c
  dc.b $44,$84,$85,$45,$87,$47,$46,$86
  dc.b $82,$42,$43,$83,$41,$81,$80,$40	
																
	end
