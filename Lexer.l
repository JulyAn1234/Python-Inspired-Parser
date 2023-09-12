%option noyywrap
%option yylineno

%{
#include <stdio.h>
#include "Parser.tab.h"
#include <stdio.h>
#include <string.h>
#include <time.h>

char lineBuffer[1000];
int B;
%}

%%
read {strcat(lineBuffer, yytext); return READ;}
write {strcat(lineBuffer, yytext); return WRITE;}
while {strcat(lineBuffer, yytext); return WHILE;}
if  {strcat(lineBuffer, yytext); return IF;}
int|float|double|char|string {strcat(lineBuffer, yytext); return TYPE;}
true|false {strcat(lineBuffer, yytext); return BOOL;}
end {strcat(lineBuffer, yytext); return END;}
\+ {strcat(lineBuffer, yytext); return SUM;}
- {strcat(lineBuffer, yytext); return MINUS;}
\/ {strcat(lineBuffer, yytext); return DIV;}
\* {strcat(lineBuffer, yytext); return MULT;}
==|\>=|\<=|\>|\< {strcat(lineBuffer, yytext); return REL_OP;}
= {strcat(lineBuffer, yytext); return ASSIGN;}
; {strcat(lineBuffer, yytext); return SEMI_COLON;}
, {strcat(lineBuffer, yytext); return COMMA;}
\: {strcat(lineBuffer, yytext); return COLON;}
\( {strcat(lineBuffer, yytext); return LEFT_GROUP;}
\) {strcat(lineBuffer, yytext); return RIGHT_GROUP;}
\".*\" {strcat(lineBuffer, yytext); return STRING;}
[a-zA-Z_][a-zA-Z0-9_]* {strcat(lineBuffer, yytext); return ID;}
[0-9]+(\.[0-9]+) {strcat(lineBuffer, yytext); return FLOATING;}
[0-9]+ {strcat(lineBuffer, yytext); return INTEGER;}
[ \t\r]+ {strcat(lineBuffer, yytext);}
"//"(.*) {}
\n {memset(lineBuffer, '\0', sizeof(lineBuffer));}
. {strcat(lineBuffer, yytext); printf("\n---lexical error in line %d : << %s >>---", yylineno, lineBuffer); return UNDEFINED;}
%%

int main(int argc, char** argv) {
    clock_t start_time, end_time;
    double execution_time;
    B= 0;

    start_time = clock();  // Get the initial clock time

    FILE* file = fopen(argv[1], "r");
    if (!file) {
        perror("fopen");
        return 1;
    }

    yyin = file;

    yyparse();

    fclose(file);

    end_time = clock();  // Get the final clock time

    // Calculate the execution time in seconds
    execution_time = (double)(end_time - start_time) / CLOCKS_PER_SEC;

    if (B == 1)
        printf("\n\nParseo no finalizado debido a errores, tiempo de ejecucion: %.20f segundos\n", execution_time);
    else
        printf("\n\nParseo completado sin errores, tiempo de ejecucion: %.20f segundos\n", execution_time);

    return 0;
}

yyerror (char* s){
    B=1;
    printf("\n---%s in line %d : << %s >>---", s, yylineno, lineBuffer);
    return 0;
}
