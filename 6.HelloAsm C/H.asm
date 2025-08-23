        case on

; ****************************************************
; Clear the keyboard strobe
;
clear   start
        sep #$20
        sta >$C010
        rep #$20
        rtl
        end

; ****************************************************
; Wait for a keypress
keypress        START
                sep #$30
                sta >$00C010
loop2           anop
                lda >$00C000     ; Read the keyboard status from memory address 0xC000
                bpl loop2        ; If not pressed, loop until a key is pressed
                rep #$30
                rtl
                END
        

; ****************************************************
; To use with an emulator.
; With Crossrunner, you can set a breakpoint to break when
; registers have specific values. For instance : 0xAAAA in register A 
; and 0xBBBB in register X.
debug   START
        pha
        phx
        lda #$AAAA
        ldx #$BBBB      ; will break after this instruction if you set a breakpoint
        plx             ; restore X
        pla             ; restore A
        rtl             ; return from subroutine
        END


; ****************************************************
; Get 2 bytes value from parameter, double it, return it
;
dbint START
parm	equ	4	passed parameter
ret	equ	1	return address (3 bytes)
	
        tsc             ;record current stack pointer
        phd             ;save old DP
        tcd             ;set new DP to stack pointer   

        lda parm        ; get parameter
        asl A
        tax             ; save in X
	lda ret+1
        sta parm
        lda ret-1
        sta ret+1
        pld             ; restore old DP
        pla             ; set up stack for return from subroutine
        txa             ; put the function result in A
        rtl
        END


; ****************************************************
; get 4 bytes value in X/A (hi/lo words)
; poke it in a C variable (a_C_var)
; and return value 
;
.import a_C_var    
debug4 START
parm	equ	4	; passed parameter
ret	equ    1	; return address

        tsc             ;record current stack pointer
        phd             ;save old DP
        tcd             ;set new DP to stack pointer
                
        ldy parm        ; save in Y (least significant word)
        ldx parm+2      ; save in X (most significant word)

	lda ret+1
        sta parm+2
        lda ret-1
        sta parm

        pld             ; restore old DP
        pla             ; set up stack for return from subroutine
        pla 
 
        stx a_C_var+2   ; poke value in a C vat
        sty a_C_var

        tya             ; restore least significant word (most significant word is already in X)

        rtl
        END

; ****************************************************
; Poke a value into the C variable (a_C_var)
;
pokeValue  start
        lda #$5678
        sta a_C_var
        ldy #$1234
        sty a_C_var+2
        rtl
        end
 
; ****************************************************
; Get 4 bytes value from parameter, double it, return it
;
dblong  START
parm	equ	4	; passed parameter
ret	equ    1	; return address

        tsc             ; record current stack pointer
        phd             ; save old DP
        tcd             ; set new DP to stack pointer
      
        lda parm        ; save in Y (least significant word)
        asl A 
        tay 
        lda parm+2      ; save in X (most significant word)
        rol A
        tax 
 
	lda ret+1
        sta parm+2
        lda ret-1
        sta parm

        pld             ; restore old DP
        pla             ; set up stack for return from subroutine
        pla 

        tya             ; restore least significant word
        rtl
        END

