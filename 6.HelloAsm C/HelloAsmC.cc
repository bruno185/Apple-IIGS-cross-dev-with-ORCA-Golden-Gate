#include <stdio.h>
#include <stdlib.h> // for rand()
#include <ctype.h>
#include <time.h>
#include <string.h>

extern void clear(void);
extern void keypress(void);
extern void debug(void);
extern int dbint(int);
extern long dblong(long);
extern long debug4(long);
extern void pokeValue(void);
extern long uppers(long);

long a_C_var;

void to_uppercase(char *str) {
    while (*str) {
        *str = toupper((unsigned char)*str);
        str++;
    }
}

int main() {
        
        int i;
        long li;
        char my_string[100];

        strcpy(my_string, "Hello, C World!");

        printf("%s\n", my_string);
        printf("\n");

        i = 1234; // get random integer
        printf("Integer value in C program : %d\n", i);
        printf("Value x 2 by assembly routine : %d\n", dbint(i)); // call dbint with variable

        printf("\n");
        a_C_var = 0;
        printf("Value of a C variable : $%lx\n", a_C_var);
        pokeValue(); // asm routine : pokes $12345678 in a_C_var C var
        printf("New value of C var modified by assembly routine : $%08lx\n", a_C_var);

        printf("\n");
        printf("My string value = %s\n", my_string);
        printf("My string address in C : %p\n", (void*)my_string);
        printf("My string address returned by assembly routine : %lx\n", debug4((long)my_string));
        printf("My string address poked by assembly routine in a C var : %lx\n", a_C_var);

        printf("\n");
        li = 12345;
        printf("Value of a long variable : %ld\n", li);
        li = dblong(li);
        printf("Value x 2 by assembly routine : %ld\n", li);

        printf("\n");
        printf("My string value = %s\n", my_string);
        debug();
        li = uppers((long)my_string);              // convert string to uppercase via assembly routine
        printf("My string address caught by assembly routine: $%lx\n", li);
        printf("My string value uppercased by assembly routine = %s\n", my_string);

        printf("\n");
        
        printf("--------- C vs. Assembly ---------\n");
        printf("Press any when ready\n");
        keypress(); 

        printf("Running...\n");
        long loopcnt = 30000;
        clock_t debut = clock();
        for (i=0; i<loopcnt; i++) {
            ;
            to_uppercase(my_string);
        }
        clock_t fin = clock();
        double temps = (double)(fin - debut) / CLOCKS_PER_SEC;
        printf("Time taken by C : %f seconds\n", temps);

        debut = clock(); 
        for (i=0; i<loopcnt; i++) {
            uppers((long)my_string);
        }
        fin = clock();
        double temps2 = (double)(fin - debut) / CLOCKS_PER_SEC;
        printf("Time taken by Assembly : %f seconds\n", temps2);

        printf("\n");
        printf("Press any key to quit...\n");
        clear();
        keypress();             // asm function to check for keypress
        printf("\f");           //clears the screen via a ‘formfeed’
        printf("Goodbye!\n");

        return 0;
}
#append "HelloAsmC.asm"

