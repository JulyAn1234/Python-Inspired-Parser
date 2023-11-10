%option noyywrap
%option yylineno

%{
#include <stdio.h>
#include "Parser.tab.h"
#include <stdio.h>
#include <string.h>


char lineBuffer[1000];
%}

%%
read {strcat(lineBuffer, yytext); return READ;}
write {strcat(lineBuffer, yytext); return WRITE;}
while {strcat(lineBuffer, yytext); return WHILE;}
if  {strcat(lineBuffer, yytext); return IF;}
int|float|string|bool {strcat(lineBuffer, yytext); yylval.text = (char *) strdup(yytext);return TYPE;}
true|false {strcat(lineBuffer, yytext); yylval.text = (char *) strdup(yytext); return BOOL;}
end {strcat(lineBuffer, yytext); return END;}
\+ {strcat(lineBuffer, yytext); yylval.text = (char *) strdup(yytext); return SUM;}
- {strcat(lineBuffer, yytext); yylval.text = (char *) strdup(yytext); return MINUS;}
\/ {strcat(lineBuffer, yytext); yylval.text = (char *) strdup(yytext); return DIV;}
\* {strcat(lineBuffer, yytext); yylval.text = (char *) strdup(yytext); return MULT;}
==|\>=|\<=|\>|\< {strcat(lineBuffer, yytext); yylval.text = (char *) strdup(yytext); return REL_OP;}
= {strcat(lineBuffer, yytext); return ASSIGN;}
; {strcat(lineBuffer, yytext); return SEMI_COLON;}
, {strcat(lineBuffer, yytext); return COMMA;}
\: {strcat(lineBuffer, yytext); return COLON;}
\( {strcat(lineBuffer, yytext); return LEFT_GROUP;}
\) {strcat(lineBuffer, yytext); return RIGHT_GROUP;}
\".*\" {strcat(lineBuffer, yytext);yylval.text = (char *) strdup(yytext); return STRING;}
[a-zA-Z_][a-zA-Z0-9_]* {strcat(lineBuffer, yytext);yylval.text = (char *) strdup(yytext);return ID;}
[0-9]+(\.[0-9]+) {strcat(lineBuffer, yytext);yylval.text = (char *) strdup(yytext); return FLOATING;}
[0-9]+ {strcat(lineBuffer, yytext);yylval.text = (char *) strdup(yytext); return INTEGER;}
[ \t\r]+ {strcat(lineBuffer, yytext);}
"//"(.*) {}
\n {memset(lineBuffer, '\0', sizeof(lineBuffer));}
. {strcat(lineBuffer, yytext); printf("\n---lexical error in line %d : << %s >>---", yylineno, lineBuffer); return UNDEFINED;}
%%
