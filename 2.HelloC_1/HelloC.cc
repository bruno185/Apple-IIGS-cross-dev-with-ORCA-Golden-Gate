#include <stdio.h>
#include <asm.h>



int main() {
        
        // printf() displays the string inside quotation
        printf("Hello, C!\n");
        printf("Press any key to quit...\n");

        debug();                // asm function to debug registers
        // Wait for a key press
        keypress();             // asm function to check for keypress
        printf("\f");           //clears the screen via a ‘formfeed’
        printf("Goodbye!\n");

        return 0;
}
