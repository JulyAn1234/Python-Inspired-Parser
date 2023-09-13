%{
#include <stdio.h>
#include "Parser.tab.h"
#include <stdio.h>
#include <string.h>

extern char lineBuffer[1000];
%}

%token READ
%token WRITE
%token WHILE
%token IF
%token TYPE
%token BOOL
%token END
%token SUM
%token MINUS
%token DIV
%token MULT
%token REL_OP
%token ASSIGN
%token SEMI_COLON
%token COLON
%token COMMA
%token LEFT_GROUP
%token RIGHT_GROUP
%token STRING
%token ID
%token FLOATING
%token INTEGER
%token UNDEFINED

%%
//////////////////// INSTRUCCIONES DENTRO DE LA FUNCIÓN //////////////


function_behavior:
    //Vacio
|    function_behavior_alpha function_behavior
;

function_behavior_alpha:
    function_line
|   if_statement
|   loop
;

///////////////////// BUCLES //////////////////

loop:
    WHILE bool_expression COLON function_behavior END
;

///////////////// IF ///////////////

if_statement:
    IF bool_expression COLON function_behavior END
;

/////////////////LINEAS DE CÓDIGO VÁLIDAS EN UNA FUNCIÓN///////////////

function_line:
    function_line_alpha SEMI_COLON
;

function_line_alpha:
//vacio
|   var_assign
|   var_init
|   method_call
;


var_init:
    TYPE multi_id
;

    multi_id: 
        ID comma_id
    ;   
        //Estructura zero o más
        comma_id:
        //Vacio
        |   COMMA ID comma_id
        ;

var_assign: 
    multi_id ASSIGN expression
;

method_call:
    READ LEFT_GROUP ID RIGHT_GROUP
|   WRITE LEFT_GROUP write_parameter RIGHT_GROUP
;

write_parameter:
    STRING
|   ID
;

/////////////////////////////////////////////EXPRESIONES////////////////////////////////////////

//PARA USAR EN ASIGNACIÓN
expression:
    STRING
|   numerical_expression
|   BOOL
;

                            //NUMERICAS
numerical_expression:
    term numerical_expression_prime
;


numerical_expression_prime:
//VACIO
|   SUM term numerical_expression_prime
|   MINUS term numerical_expression_prime
;

term:
    factor term_prime
;

term_prime:
//VACIO
|    MULT factor term_prime
|    DIV factor term_prime
;

factor:
    ID
|   INTEGER
|   FLOATING 
|   LEFT_GROUP numerical_expression RIGHT_GROUP
;

bool_expression:
    rel_expression
|   BOOL
;
rel_expression:
    numerical_expression REL_OP numerical_expression
;

                             //BOOLEANAS
                             
// BOOL_EXPRESSION:
//     BOOL_TERM BOOL_EXPRESSION_PRIME
// ;

// BOOL_EXPRESSION_PRIME:
// //VACIO
// |    LogOp BOOL_TERM BOOL_EXPRESSION_PRIME
// ;

// //AÑADIR FUNCIÓN
// BOOL_TERM:
//     ID
// |   FUNCTION_CALL
// |   BoolValue
// |   REL_EXPRESSION
// |   UNI_EXPRESSION
// |   InBracket BOOL_EXPRESSION EndBracket
// ;

%%