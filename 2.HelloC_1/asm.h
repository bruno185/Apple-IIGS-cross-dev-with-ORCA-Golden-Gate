// get a keypress from the user
// This function will wait until a key is pressed and then return.
asm int keypress ()
        {
loop:
        lda >0xC000     // Read the keyboard status from memory address 0xC000
        and #0x0080     // Check if the key is pressed (bit 7)
        beq loop        // If not pressed, loop until a key is pressed
        rtl
        }

// To use with an emulator
// With Crossrunner, you can set a breakpoint to break when 
// register A has the value 0xAAAA and register X has the value 0xBBBB.
asm  debug ()
        {
        pha 
        phx
        lda #0xAAAA
        ldx #0xBBBB     // will break after this instruction if you set a breakpoint
        plx             // restore X
        pla             // restore A
        rtl             // return from subroutine
        }