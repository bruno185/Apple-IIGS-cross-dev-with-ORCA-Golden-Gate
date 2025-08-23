
; wait for a keypress
keypress start
        sep #$30
        sta >$00C010
loop2   anop
        lda >$00C000     ; Read the keyboard status from memory address 0xC000
        bpl loop2        ; If not pressed, loop until a key is pressed
        rep #$30
;jsl debug
        rtl
        END
        

; To use with an emulator
; With Crossrunner, you can set a breakpoint to break when
; registers have specific values. For instance : 0xAAAA in register A 
; and 0xBBBB in register X.
debug   start
        pha
        phx
        lda #$AAAA
        ldx #$BBBB      ; will break after this instruction if you set a breakpoint
        plx             ; restore X
        pla             ; restore A
        rtl             ; return from subroutine
        END

;
; Reverse the bits in an integer (from ORCA/C documentation)
;
reverse START
parm	equ	4	passed parameter
ret	equ	1	return address
	
        tsc             ; record current stack pointer
        phd             ; save old DP
        tcd             ; set new DP to stack pointer
                
        jsl debug       ; to break, if needed
	ldx #16
lb1     asl parm
        ror A
        dex 
        bne lb1
        tax	        ; save result in X

	lda ret+1
        sta parm
        lda ret-1
        sta ret+1
        pld             ; restore old DP
        pla             ; set up stack for return from subroutine
        txa             ; put the function result in A
        rtl
        END	   	




      