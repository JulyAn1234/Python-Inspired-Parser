
%{
#include <stdio.h>
#include "Parser.tab.h"
#include <stdio.h>
#include <string.h>

extern char lineBuffer[1000];
%}

%token WhenEver
%token FileFuncs
%token ErrorWord
%token Exception
%token MathFunc
%token StringFunc
%token MacroConstant
%token Access
%token Assertion
%token Control
%token Classes
%token Concurrency
%token Interface
%token Memory
%token Modifier
%token Package
%token Serialization
%token RemainderFunction
%token Inheritance
%token GammaFunction
%token Template
%token List
%token Set
%token Map
%token Queue
%token Stack
%token ConsoleOutputFunc
%token ConsoleInputFunc
%token Try
%token Catch
%token Finally
%token Switch
%token Case
%token SDefault
%token TypeDef
%token Break
%token TypeMod
%token SignMod

%token New
%token FxWord
%token SelfWord
%token RecursiveWord
%token AccessMod
%token ClassDef
%token ClassMethod
%token ClassProp
%token While
%token For
%token Do
%token ElseCond
%token Condicional
%token Else
%token Retorno
%token UniRelOp
%token LogOp
%token RelOp
%token BoolValue
%token DOT
%token MINUS
%token STAR
%token SLASH
%token Texto
%token PLUS
%token UNDEFINED
%token ID
%token Entero
%token Flotante
%token FuncDef
%token Init
%token DataType
%token FuncParameter
%token LibImport
%token Ender
%token LineEnder
%token Comma
%token Asignar
%token EndBracket
%token InBracket
%token InGroup
%token EndGroup


%%

PROGRAM:
    IMPORT_STATEMENT PROGRAM_BODY
;

//ZERO O MÁS
IMPORT_STATEMENT
://VACIO
|   LibImport ID LineEnder IMPORT_STATEMENT
;


PROGRAM_BODY:
//vacio
|    PROGRAM_BODY_ALPHA PROGRAM_BODY
;

PROGRAM_BODY_ALPHA:
    FUNCTION_STATEMENT
|   CLASS_STATEMENT
;

////////////////////// CLASES //////////////////////

CLASS_STATEMENT:
    ClassDef ID Init CLASS_BODY Ender
;

CLASS_BODY:
    CLASS_PROPERTIES CLASS_METHODS
;

CLASS_PROPERTIES:
//VACIO
|    ClassProp Init PROPERTY_LINES Ender
;

PROPERTY_LINES:
//VACIO
|    ACCESS_MOD VAR_INIT LineEnder PROPERTY_LINES
;

ACCESS_MOD:
//VACIO
|   AccessMod    
;

CLASS_METHODS:
//VACIO
|    ClassMethod Init METHODS_BODY Ender
;

METHODS_BODY:
//VACIO
|    ACCESS_MOD FUNCTION_STATEMENT METHODS_BODY
;

////////////////  FUNCIONES  ////////////////////////

FUNCTION_STATEMENT:
   FuncDef DataType ID Init FUNCTION_BODY RETURN_LINE Ender
;

RETURN_LINE:
//vacio
|    Retorno EXPRESSION LineEnder
;

FUNCTION_BODY:
    PARAMETER_STATEMENT FUNCTION_BEHAVIOR
;

PARAMETER_STATEMENT:
//vacio
|    FuncParameter Init PARAMETER_BODY Ender
;

//ZERO O MAS
PARAMETER_BODY:
    //vacio
|   VAR_INIT LineEnder PARAMETER_BODY
;

//////////////////// INSTRUCCIONES DENTRO DE LA FUNCIÓN //////////////

FUNCTION_BEHAVIOR:
    //Vacio
|    FUNCTION_BEHAVIOR_ALPHA FUNCTION_BEHAVIOR
;

FUNCTION_BEHAVIOR_ALPHA:
    FUNCTION_LINE
|   IF_STATEMENT
|   LOOP
;

///////////////////// BUCLES //////////////////

DO:
//Vacio
| Do
;

LOOP:
    DO While BOOL_EXPRESSION Init FUNCTION_BEHAVIOR WHENEVER Ender
;

WHENEVER:
//VACIO
|   WhenEver BOOL_EXPRESSION Init FUNCTION_BEHAVIOR WHENEVER
;

///////////////// IF ///////////////

IF_STATEMENT:
    Condicional BOOL_EXPRESSION Init FUNCTION_BEHAVIOR ELSES Ender
;

ELSES:
//Vacio
|   ElseCond BOOL_EXPRESSION Init FUNCTION_BEHAVIOR ELSES
|   Else Init FUNCTION_BEHAVIOR
;

/////////////////LINEAS DE CÓDIGO VÁLIDAS EN UNA FUNCIÓN///////////////

FUNCTION_LINE:
    FUNCTION_LINE_ALPHA LineEnder
;

FUNCTION_LINE_ALPHA:
//vacio
|   VAR_ASSIGN
|   VAR_INIT
|   FUNCTION_CALL
|   INLINE_FUNCTION
|   OBJECT_INIT
;


OBJECT_INIT:
    ID ID Asignar New FUNCTION_CALL
;

INLINE_FUNCTION:
    FX
|   SELF
|   RECURSIVE
;

FX:
    FxWord ID InGroup MULTI_ID EndGroup Asignar NUMERICAL_EXPRESSION
;

RECURSIVE:
    RecursiveWord ID Asignar DataType OPERATORS
;

OPERATORS:
    STAR
|   PLUS
|   MINUS
|   SLASH
|   RelOp
|   LogOp
;

SELF:
    SelfWord ID InGroup OPERATORS Comma Entero EndGroup
;

VAR_INIT:
    DataType MULTI_ID
;

    MULTI_ID: 
        ID COMMA_ID
    ;   
        //Estructura zero o más
        COMMA_ID:
        //Vacio
        |   Comma ID COMMA_ID
        ;

VAR_ASSIGN: 
    MULTI_ID Asignar EXPRESSION
;

FUNCTION_CALL:
    BUILDIN_FUNC InGroup MULTI_EXPRESSION EndGroup
;
    MULTI_EXPRESSION:
    //VACIO
    |    EXPRESSION COMMA_EXPRESSION
    ;
        COMMA_EXPRESSION:
        //VACIO
        |  Comma EXPRESSION COMMA_EXPRESSION
        ;

BUILDIN_FUNC:
    ID
|   FileFuncs
|   MathFunc
|   StringFunc
|   GammaFunction
|   ConsoleOutputFunc
|   ConsoleInputFunc
;

/////////////////////////////////////////////EXPRESIONES////////////////////////////////////////

//PARA USAR EN ASIGNACIÓN
EXPRESSION:
    Texto
|   NUMERICAL_EXPRESSION
|   BoolValue
;

                            //NUMERICAS
NUMERICAL_EXPRESSION:
    TERMINO NUMERICAL_EXPRESSION_PRIME
;


NUMERICAL_EXPRESSION_PRIME:
//VACIO
|   PLUS TERMINO NUMERICAL_EXPRESSION_PRIME
|   MINUS TERMINO NUMERICAL_EXPRESSION_PRIME
;

TERMINO:
    FACTOR TERMINO_PRIME
;

TERMINO_PRIME:
//VACIO
|    STAR FACTOR TERMINO_PRIME
|    SLASH FACTOR TERMINO_PRIME
;

FACTOR:
    ID
|   FUNCTION_CALL
|   Entero
|   Flotante 
|   InGroup NUMERICAL_EXPRESSION EndGroup
;

                             //BOOLEANAS
                             
BOOL_EXPRESSION:
    BOOL_TERM BOOL_EXPRESSION_PRIME
;

BOOL_EXPRESSION_PRIME:
//VACIO
|    LogOp BOOL_TERM BOOL_EXPRESSION_PRIME
;

//AÑADIR FUNCIÓN
BOOL_TERM:
    ID
|   FUNCTION_CALL
|   BoolValue
|   REL_EXPRESSION
|   UNI_EXPRESSION
|   InBracket BOOL_EXPRESSION EndBracket
;

REL_EXPRESSION:
    NUMERICAL_EXPRESSION RelOp NUMERICAL_EXPRESSION
|   Texto RelOp Texto
;

UNI_EXPRESSION:
    UniRelOp BOOL_TERM
;

%%