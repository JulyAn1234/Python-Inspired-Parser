# Python-Inspired-Parser
A simple parser for a Python like programming language.

Un simple parseador para un lenguaje de programación inspirado en Python.

## How to run / Cómo correrlo
To run, you can simple execute the .exe from console like this / Para correrlo, puedes simplemente ejecutar el .exe desde consola así:

`./ParserExecutable Program.txt`

## Tools used
C language with Flex and Bison. / Lenguaje C con Flex y Bison.

## TO COMPILE

flex Lexer.l
bison -d Parser.y
g++ -o parser_exe lex.yy.c Parser.tab.c sym_table.cpp -lfl
