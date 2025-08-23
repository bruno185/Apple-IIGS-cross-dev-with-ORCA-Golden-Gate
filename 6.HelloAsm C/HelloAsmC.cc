#include <stdio.h>
#include <stdlib.h> // for rand()

extern void clear(void);
extern void keypress(void);
extern void debug(void);
extern int dbint(int);
extern long dblong(long);
extern long debug4(long);
extern void pokeValue(void);

long a_C_var;

int main() {
        
        int i;
        long li;

        printf("Hello, C World!\n");
        printf("\n");

        i = 1234; // get random integer
        printf("Integer value in C program : %d\n", i);
        printf("Value x 2 by assembly routine : %d\n", dbint(i)); // call dbint with variable

        printf("\n");
        a_C_var = 0;
         printf("Value of a C variable : %08lx\n", a_C_var);
        pokeValue(); // asm routine : pokes $12345678 in a_C_var C var
        printf("New value of C var modified by assembly routine : %08lx\n", a_C_var);

        printf("\n");
        char my_string[50] = "test string";
        printf("My string value = %s\n", my_string);
        printf("My string address in C : %p\n", (void*)my_string);
        printf("My string address returned by assembly routine : %lx\n", debug4((long)my_string));
        printf("My string address poked by assembly routine in a C var : %lx\n", a_C_var);

        printf("\n");
        li = 12345;
        printf("Value of a long variable : %ld\n", li);
        li = dblong(li);
        printf("Value x 2 by assembly routine : %ld\n", li);

        printf("Press any key to quit...\n");
        clear();
        keypress();             // asm function to check for keypress
        printf("\f");           //clears the screen via a ‘formfeed’
        printf("Goodbye!\n");

        return 0;
}

#append "H.asm"

