stm8/
	
    segment 'rom'
		
.delay:
	ld a,#$01
	ldw y,#$1500               ; 
loop:
	subw y, #$01                ; 
	sbc a,#0                    ; 
	jrne loop
	ret

.delay_10ms:
	ldw x, #$D400              ; 
loop2:
	decw x       	             ; 
	jrne loop2
	ret

	end
