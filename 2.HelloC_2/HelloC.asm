        case on
; get a keypress from the user
; This function will wait until a key is pressed and then return.
keypress START     
loop    lda >$0C000     ; Read the keyboard status from memory address 0xC000
        and #$0080      ; Check if the key is pressed (bit 7)
        beq loop        ; If not pressed, loop until a key is pressed
        rtl
        END
        

; To use with an emulator.
; With Crossrunner, you can set a breakpoint to break when
; registers have specific values. For instance : 0xAAAA in register A 
; and 0xBBBB in register X.
debug   START
        pha 
        phx
        lda #$AAAA
        ldx #$BBBB     ; will break after this instruction if you set a breakpoint
        plx             ; restore X
        pla             ; restore A
        rtl             ; return from subroutine
        END
