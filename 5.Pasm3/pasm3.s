
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
; get 2 bytes parameter value in X
;
debug2 START
parm	equ	4	passed parameter
ret	equ	1	return address
	
        tsc             ;record current stack pointer
        phd             ;save old DP
        tcd             ;set new DP to stack pointer   

        lda parm        ; get parameter
        tax             ; save in X
	lda ret+1
        sta parm
        lda ret-1
        sta ret+1
        pld             ; restore old DP
        pla             ; set up stack for return from subroutine
        txa             ; put the function result in A
;jsl debug      ; for break if needed
        rtl
        END	   	


;
; get 4 bytes parameter value in X/A (hi/lo words)
;
debug4 START
parm	equ	4	passed parameter
ret	equ	1	return address
        
        tsc             ;record current stack pointer
        phd             ;save old DP
        tcd             ;set new DP to stack pointer
                
        lda parm        ; get parameter
        tay             ; save in Y (least significant word)
        lda parm+2
        tax             ; save in X (most significant word)

	lda ret+1
        sta parm+2
        lda ret-1
        sta parm

        pld             ; restore old DP

        pla             ; set up stack for return from subroutine
        pla 

        tya             ; least significant word in A

;jsl debug      ; for break if needed
        rtl
        END	 

dblong  START
parm	equ	4	passed parameter
ret	equ	1	return address
        
        tsc             ;record current stack pointer
        phd             ;save old DP
        tcd             ;set new DP to stack pointer
                
        lda parm        ; get parameter
        asl A           ; x 2
        tay             ; save in Y (least significant word)
        lda parm+2
        rol A           ; x 2
        tax             ; save in X (most significant word)

	lda ret+1
        sta parm+2
        lda ret-1
        sta parm

        pld             ; restore old DP

        pla             ; set up stack for return from subroutine
        pla 

        tya             ; least significant word in A

;jsl debug      ; for break if needed
        rtl
        END	