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
whenever {strcat(lineBuffer, yytext); return WhenEver;}
end {strcat(lineBuffer, yytext); return Ender;}
fclose|fflush|fopen|freopen|setbuf|setvbuf|remove|rename|tmpfile|tmpnam {strcat(lineBuffer, yytext); return FileFuncs;}
erf|erfc {strcat(lineBuffer, yytext); return ErrorWord;}
throw|throws {strcat(lineBuffer, yytext); return Exception;}
abs|round|max|min|sum|reduce|pow|sqrt|exp|log|log10|sin|cos|tan|asin|acos|atan|ceil|floor|fabs|factorial|fmod|gcd|hypot|isnan|idexp|modf|trunc|atan2|cosh|sinh|tanh|acosh|asinh|atanh|cosh|frexp|exp2|expm1|ilogb|log1p|log2|scalbn|scalbln|copysign|nextafter|nexttoward|log2|scalbn|scalbln|fdim|fmax|fmin {strcat(lineBuffer, yytext); return MathFunc;}
capitalize|casefold|isalnum|isalpha|isascii|isdecimal|isdigit|isidentifier|islower|isnumeric|isprintable|isspace|istitle|isupper|lower {strcat(lineBuffer, yytext); return StringFunc;}
CHAR_MIN|CHAR_MAX|SCHAR_MIN|SCHAR_MAX|UCHAR_MAX|CHAR_BIT|MB_LEN_MAX|SHRT_MIN|SHRT_MAX|USHRT_MAX|INT_MIN|INT_MAX|UINT_MAX|LONG_MIN|LONG_MAX|ULONG_MAX|LLONG_MIN|LLONG_MAX|ULLONG_MAX {strcat(lineBuffer, yytext); return MacroConstant;}
friend {strcat(lineBuffer, yytext); return Access;}
assert {strcat(lineBuffer, yytext); return Assertion;}
asm|goto {strcat(lineBuffer, yytext); return Control;}
virtual {strcat(lineBuffer, yytext); return Classes;}
synchronized {strcat(lineBuffer, yytext); return Concurrency;}
interface {strcat(lineBuffer, yytext); return Interface;}
delete {strcat(lineBuffer, yytext); return Memory;}
strictfp {strcat(lineBuffer, yytext); return Modifier;}
package {strcat(lineBuffer, yytext); return Package;}
transient {strcat(lineBuffer, yytext); return Serialization;}
remainder|remquo {strcat(lineBuffer, yytext); return RemainderFunction;}
extends|implements|super {strcat(lineBuffer, yytext); return Inheritance;}
tgamma|lgamma|tgamma|lgamma {strcat(lineBuffer, yytext); return GammaFunction;}
template {strcat(lineBuffer, yytext); return Template;}
List {strcat(lineBuffer, yytext); return List;}
Set {strcat(lineBuffer, yytext); return Set;}
Map {strcat(lineBuffer, yytext); return Map;}
Queue {strcat(lineBuffer, yytext); return Queue;}
Stack {strcat(lineBuffer, yytext); return Stack;}
puts|echo|print|printf|println {strcat(lineBuffer, yytext); return ConsoleOutputFunc;}
input|prompt {strcat(lineBuffer, yytext); return ConsoleInputFunc;}
try|begin {strcat(lineBuffer, yytext); return Try;}
catch|rescue|except {strcat(lineBuffer, yytext); return Catch;}
finally|ensure {strcat(lineBuffer, yytext); return Finally;}
switch {strcat(lineBuffer, yytext); return Switch;}
case {strcat(lineBuffer, yytext); return Case;}
default|otherwise {strcat(lineBuffer, yytext); return SDefault;}
typedef {strcat(lineBuffer, yytext); return TypeDef;}
break {strcat(lineBuffer, yytext); return Break;}
final|static|const|global|persistent|abstract {strcat(lineBuffer, yytext); return TypeMod;}
unsigned|signed {strcat(lineBuffer, yytext); return SignMod;}

new {strcat(lineBuffer, yytext); return New;}
public|private|protected|default|open|internal {strcat(lineBuffer, yytext); return AccessMod;}
class|classdef {strcat(lineBuffer, yytext); return ClassDef;}
fx {strcat(lineBuffer, yytext); return FxWord;}
self {strcat(lineBuffer, yytext); return SelfWord;}
recursive {strcat(lineBuffer, yytext); return RecursiveWord;}
methods {strcat(lineBuffer, yytext); return ClassMethod;}
properties {strcat(lineBuffer, yytext); return ClassProp;}
elseif|elif {strcat(lineBuffer, yytext); return ElseCond;}
if {strcat(lineBuffer, yytext); return Condicional;}
else {strcat(lineBuffer, yytext); return Else;}
while {strcat(lineBuffer, yytext); return While;}
for {strcat(lineBuffer, yytext); return For;}
do {strcat(lineBuffer, yytext); return Do;}
parameters {strcat(lineBuffer, yytext); return FuncParameter;}
";" {strcat(lineBuffer, yytext); return LineEnder;}
"~" {strcat(lineBuffer, yytext); return UniRelOp;}
return {strcat(lineBuffer, yytext); return Retorno;}
\<|\>|(\<=)|(\>=)|(==)|(~=)|(!=)|(!==)|(===)|eq|ne|<=>|cmp|in|!in|is|!is|instanceof {strcat(lineBuffer, yytext); return RelOp;}
(\|\|)|(&&)|or|and|nand|nor {strcat(lineBuffer, yytext); return LogOp;}
":" {strcat(lineBuffer, yytext); return Init;}
def|function {strcat(lineBuffer, yytext); return FuncDef;}
int|float|double|bool|char|string|var|long|byte|str|Date|datetime|Integer|Float|String|Number|Int|Double|Character|float32|float64|INTEGER|REAL|COMPLEX|CHARACTER|LOGICAL|int8|int16|int32|int64|uint8|uint16|uint32|uint64|single|complex|__int8|short|__int64|wchar8_t|wchar_t|wchar32_t|void|volatile|struct|boolean {strcat(lineBuffer, yytext); return DataType;}
import|use|require|#include {strcat(lineBuffer, yytext); return LibImport;}
true|false {strcat(lineBuffer, yytext); return BoolValue;}
[a-zA-Z_][a-zA-Z0-9_]* {strcat(lineBuffer, yytext); return ID;}
[0-9]+(\.[0-9]+) {strcat(lineBuffer, yytext); return Flotante;}
[0-9]+ {strcat(lineBuffer, yytext); return Entero;}
["]([^"\\\n]|\\(.|\n))*["] {strcat(lineBuffer, yytext); return Texto;}
"+" {strcat(lineBuffer, yytext); return PLUS;}
"-" {strcat(lineBuffer, yytext); return MINUS;}
"*" {strcat(lineBuffer, yytext); return STAR;}
"/" {strcat(lineBuffer, yytext); return SLASH;}
"." {strcat(lineBuffer, yytext); return DOT;}
= {strcat(lineBuffer, yytext); return Asignar;}
, {strcat(lineBuffer, yytext); return Comma;}
\( {strcat(lineBuffer, yytext); return InGroup;}
\) {strcat(lineBuffer, yytext); return EndGroup;}
\[ {strcat(lineBuffer, yytext); return InBracket;}
\] {strcat(lineBuffer, yytext); return EndBracket;}
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
