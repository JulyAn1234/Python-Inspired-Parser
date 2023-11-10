%{
#include "Parser.tab.h"
#include <stdio.h>
#include <string.h>
#include <iostream>
#include "sym_table.h"
#include <time.h>
#include <string>
#include <unistd.h>
#include "block_stack.h"
//#include <>

//Prototipos y externos, se rompe todo si no estan...
int yylex();
extern FILE* yyin;
void yyerror(char* s);
char* to_char_ptr (const string& str);
void semantic_error(semantic_result res);
semantic_result type_system_numeric(char* type1, char* type2, char* op);
semantic_result get_type_relation(string type1, string type2);
extern char lineBuffer[1000];
extern int yylineno;

sym_table Table;
semantic_result res;
block_stack block_stack;
int error_count =0;
%}

%union
{
    char *text;
    void* expression_node;
}

%type <expression_node> term_prime
%type <expression_node> factor
%type <expression_node> term
%type <expression_node> numerical_expression
%type <expression_node> numerical_expression_prime
%type <expression_node> expression
%type <expression_node> bool_expression
%type <expression_node> rel_expression

%token READ
%token WRITE
%token WHILE
%token IF
%token <text> TYPE
%token <text> BOOL
%token END
%token <text> SUM
%token <text> MINUS
%token <text> DIV
%token <text> MULT
%token <text> REL_OP
%token ASSIGN
%token SEMI_COLON
%token COLON
%token COMMA
%token LEFT_GROUP
%token RIGHT_GROUP
%token <text> STRING
%token <text> ID
%token <text> FLOATING
%token <text> INTEGER
%token UNDEFINED

%%
//////////////////// INSTRUCCIONES DENTRO DE LA FUNCIÓN //////////////

function_behavior:
    //Vacio
|    function_behavior_alpha function_behavior
;

function_behavior_alpha:
    function_line
    {
        printf("Line: ");printf(lineBuffer); printf("\n");
        usleep(10000);
    }
|   if_statement
    {
        printf("If: ");printf(lineBuffer); printf("\n");

        res = Table.delete_scope();
        if(res.error)
        {
            semantic_error(res);
        }
        block_stack.delete_if_block();
        usleep(10000);
    }
|   loop
    {
        printf("loop: ");printf(lineBuffer); printf("\n");
        res = Table.delete_scope();
        if(res.error)
        {
            semantic_error(res);
        }
        block_stack.delete_loop_block();
        usleep(10000);
    }
;

///////////////////// BUCLES //////////////////

loop_init:
    WHILE bool_expression COLON 
    {
        printf("loop_init\n");
        res = Table.new_scope();
        if(res.error)
            semantic_error(res);
        else{
            semantic_result* casted_ptr = static_cast<semantic_result *> ($2);
            res = *casted_ptr;
            if(res.error)
                semantic_error(res);
            else{
                string quadruple = res.IR_node_quadruple;
                string condition = res.IR_node_identifier;
                block_stack.new_loop_block(quadruple, condition);
                usleep(10000);                
            }
        }
    }
;

loop:
    loop_init function_behavior END
;

///////////////// IF ///////////////

if_init:
    IF bool_expression COLON 
    {
        printf("if_init\n");
        res = Table.new_scope();
        if(res.error)
            semantic_error(res);
        else{
            semantic_result* casted_ptr = static_cast<semantic_result *> ($2);
            res = *casted_ptr;
            if(res.error)
                semantic_error(res);
            else{
                string quadruple = res.IR_node_quadruple;
                string condition = res.IR_node_identifier;
                block_stack.new_if_block(quadruple, condition);
                usleep(10000);                
            }
        }            
    }
;
if_statement:
    if_init function_behavior END
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
    TYPE ID
    {
        res = Table.insert($2, $1);
        if(res.error)
            semantic_error(res);
        string type($1);
        string id($2);
        string new_line = type+" "+id;
        block_stack.add_line(new_line);
    }
;

//UNCOMMENT IF: you want to handle multiple declarations at a time: int id, id2, id3, id4;
    // multi_id: 
    //     ID comma_id
    // ;   
    //     //Estructura zero o más
    //     comma_id:
    //     //Vacio
    //     |   COMMA ID comma_id
    //     ;

var_assign: 
    ID ASSIGN expression
    {
        string type1 = "";
        string type2 = "";
        string expression_quadruple="";
        string expression_identifier="";
        string assign_quadruple="";

        res = Table.get_type($1);
        if(res.error)
        {
            semantic_error(res);
            type1 = "undefined";
        }
        else
        {
            type1 = res.attribute;
            semantic_result* casted_ptr = static_cast<semantic_result *> ($3);
            res = *casted_ptr;
            if(res.error)
            {
                semantic_error(res);
                type2 = "undefined";
            }
            else
            {
                type2 = res.attribute;
                expression_quadruple = res.IR_node_quadruple;
                expression_identifier = res.IR_node_identifier;
                res = get_type_relation(type1, type2);
                if(res.error)
                {
                    semantic_error(res);
                }
                else
                {
                    //ESCRIBIR Codigo intermedio?
                    cout<<"expression id:"<<expression_identifier<<endl;
                    string assign_identifier($1);
                    assign_quadruple = assign_identifier+" = "+expression_identifier;
                    assign_quadruple = expression_quadruple +"\n" + assign_quadruple;
                    block_stack.add_line(assign_quadruple);

                    // string new_line("t1 = 1+2\na = t1");
                    // block_stack.add_line(new_line);
                }
            }
        }
    }
;

method_call:
    //read gets input from user and assign to a variable
    READ LEFT_GROUP ID RIGHT_GROUP
    {
        res = Table.get_type($3);
        if(res.error)
            semantic_error(res);
        else{
            string id($3);
            string new_line("@t1 = read()\n"+id+" = @t1");
            block_stack.add_line(new_line);
        }
    }
    //write prints the value of a variable
|   WRITE LEFT_GROUP write_parameter RIGHT_GROUP 
;

write_parameter:
    STRING
    {
        string id($1);
        string new_line("@t1 = "+id+"\nwrite(@t1)");
        block_stack.add_line(new_line);
    }
|   ID
    {
        res = Table.get_type($1);
        if(res.error)
            semantic_error(res);
        else{
            string id($1);
            string new_line("@t1 = "+id+"\nwrite(@t1)");
            block_stack.add_line(new_line);
        }
    }
;

/////////////////////////////////////////////EXPRESIONES////////////////////////////////////////

//PARA USAR EN ASIGNACIÓN
expression:
    STRING
    {
        semantic_result* res = new semantic_result;
        res->error = false;
        res->attribute = "string";
        $$ = res; 
    }
|   numerical_expression
    {
        semantic_result Node_res;        
        node* casted_ptr = static_cast<node *> ($1);
        Node_res = casted_ptr -> define_type(0); 
        semantic_result* res = new semantic_result(Node_res);
        $$ = res;
    }
|   BOOL
{
    semantic_result* res = new semantic_result;
    res->error = false;
    res->attribute = "bool";
    $$ = res;
}
;

                            //NUMERICAS
//The final product of numerical_expression is either a nth level tree with its leftmost node empty, or a null pointer
//So, here both cases must be handled to generate a functional expression tree
numerical_expression:
    term numerical_expression_prime
    {
        if($2 == nullptr)
        {
            $$ = $1;
        }
        else
        {
            //assigning $1 (factor) as the leftmost leave of the $2 (term_prime) tree
            //first, two auxiliar pointer casted as node*
            node* casted_ptr = static_cast<node *> ($2);
            node* casted_ptr2 = static_cast<node *> ($1);

            //Then,from casted_ptr we call insert_left_most
            casted_ptr -> insert_left_most(casted_ptr2);
            $$ = casted_ptr;            
        }
    }
;


numerical_expression_prime:
{$$ = nullptr}//VACIO
|   SUM term numerical_expression_prime
    {
        if($3 == nullptr)
        {
            // The operator becomes the root node of a new three
            node* ptr = new node($1);
            //$2 is currently a void pointer, here it's beeing casted as a node pointer
            node* casted_ptr = static_cast<node *> ($2);

            //casted_ptr points to $2 node, here it's being assign as the right son of the new tree
            ptr -> assign_right_node(casted_ptr);
            $$ = ptr;
        }
        else
        {
            //Realizar una operacion entre $3 y $2 --> Comprobacion de tipos
            // res = type_system_numeric($3,$2,operator_aux);
            
            // The operator becomes the root node of a new tree
            node* ptr = new node($1);

            //$2 is currently a void pointer, here it's beeing casted as a node pointer
            node* casted_ptr = static_cast<node *> ($2);

            //casted_ptr points to $2 node, here it's being assign as the right son of the new tree
            ptr -> assign_right_node(casted_ptr);

            //assigning the new tree as the leftmost leave of the $3 tree
            //first, an auxiliar pointer casted as node*
            node* casted_ptr2 = static_cast<node *> ($3);

            //Then,from casted_ptr2 we call insert_left_most
            casted_ptr2 -> insert_left_most(ptr);
            $$ = casted_ptr2;
        }
    }
|   MINUS term numerical_expression_prime
    {
        if($3 == nullptr)
        {
            // The operator becomes the root node of a new three
            node* ptr = new node($1);

            //$2 is currently a void pointer, here it's beeing casted as a node pointer
            node* casted_ptr = static_cast<node *> ($2);

            //casted_ptr points to $2 node, here it's being assign as the right son of the new tree
            ptr -> assign_right_node(casted_ptr);
            $$ = ptr;
        }
        else
        {
            //Realizar una operacion entre $3 y $2 --> Comprobacion de tipos
            // res = type_system_numeric($3,$2,operator_aux);
            
            // The operator becomes the root node of a new tree
            node* ptr = new node($1);

            //$2 is currently a void pointer, here it's beeing casted as a node pointer
            node* casted_ptr = static_cast<node *> ($2);

            //casted_ptr points to $2 node, here it's being assign as the right son of the new tree
            ptr -> assign_right_node(casted_ptr);

            //assigning the new tree as the leftmost leave of the $3 tree
            //first, an auxiliar pointer casted as node*
            node* casted_ptr2 = static_cast<node *> ($3);

            //Then,from casted_ptr2 we call insert_left_most
            casted_ptr2 -> insert_left_most(ptr);
            $$ = casted_ptr2;
        }
    }
;

//The final product of term_prime is either a nth level tree with its leftmost node empty, or a null pointer
//So, here both cases must be handled to generate a functional expression tree
term:
    factor term_prime 
    {
        if($2 == nullptr)
        {
            $$ = $1;
        }
        else
        {
            //assigning $1 (factor) as the leftmost leave of the $2 (term_prime) tree
            //first, two auxiliar pointer casted as node*
            node* casted_ptr = static_cast<node *> ($2);
            node* casted_ptr2 = static_cast<node *> ($1);

            //Then,from casted_ptr we call insert_left_most
            casted_ptr -> insert_left_most(casted_ptr2);
            $$ = casted_ptr;            
        }
    }
;

term_prime:
{$$ = nullptr}//VACIO 
|    MULT factor term_prime
    {
        if($3 == nullptr)
        {
            // The operator becomes the root node of a new three
            node* ptr = new node($1);

            //$2 is currently a void pointer, here it's beeing casted as a node pointer
            node* casted_ptr = static_cast<node *> ($2);

            //casted_ptr points to $2 node, here it's being assign as the right son of the new tree
            ptr -> assign_right_node(casted_ptr);
            $$ = ptr;
        }
        else
        {
            //Realizar una operacion entre $3 y $2 --> Comprobacion de tipos
            // res = type_system_numeric($3,$2,operator_aux);
            
            // The operator becomes the root node of a new tree
            node* ptr = new node($1);

            //$2 is currently a void pointer, here it's beeing casted as a node pointer
            node* casted_ptr = static_cast<node *> ($2);

            //casted_ptr points to $2 node, here it's being assign as the right son of the new tree
            ptr -> assign_right_node(casted_ptr);

            //assigning the new tree as the leftmost leave of the $3 tree
            //first, an auxiliar pointer casted as node*
            node* casted_ptr2 = static_cast<node *> ($3);

            //Then,from casted_ptr2 we call insert_left_most
            casted_ptr2 -> insert_left_most(ptr);
            $$ = casted_ptr2;
        }
    }
|    DIV factor term_prime
    {
        if($3 == nullptr)
        {
            // The operator becomes the root node of a new three
            node* ptr = new node($1);

            //$2 is currently a void pointer, here it's beeing casted as a node pointer
            node* casted_ptr = static_cast<node *> ($2);

            //casted_ptr points to $2 node, here it's being assign as the right son of the new tree
            ptr -> assign_right_node(casted_ptr);
            $$ = ptr;
        }
        else
        {
            //Realizar una operacion entre $3 y $2 --> Comprobacion de tipos
            // res = type_system_numeric($3,$2,operator_aux);
            
            // The operator becomes the root node of a new tree
            node* ptr = new node($1);

            //$2 is currently a void pointer, here it's beeing casted as a node pointer
            node* casted_ptr = static_cast<node *> ($2);

            //casted_ptr points to $2 (factor) node, here it's being assigned as the right son of the new tree
            ptr -> assign_right_node(casted_ptr);

            //assigning the new tree as the leftmost leave of the $3 tree
            //first, an auxiliar pointer casted as node*
            node* casted_ptr2 = static_cast<node *> ($3);

            //Then,from casted_ptr2 we call insert_left_most
            casted_ptr2 -> insert_left_most(ptr);
            $$ = casted_ptr2;
        }
    }
;

factor:
    ID  
    {            
        res = Table.get_type($1);
        if(!res.error)
        {
            $$ = new node($1,to_char_ptr(res.attribute));
        }
        else
        {
            $$ = new node($1);
        }
    }
|   INTEGER 
    {
        $$ = new node($1,"int");
    }
|   FLOATING
    {
        $$ = new node($1,"float");
    }
|   LEFT_GROUP numerical_expression RIGHT_GROUP
    {
        $$ = $2;
    }
;

bool_expression:
    rel_expression
    {
        // semantic_result* casted_ptr = static_cast<semantic_result *> ($1);
        // res = *casted_ptr;
        // if(res.error){
        //     $$ = $1;
        // }
        // else{
        //     $$ = $1;
        // }
        $$ = $1;
    }
|   BOOL
    {
        string bool_value($1);
        string new_line("@t1 = " +bool_value);
        semantic_result* res_bool = new semantic_result;
        res_bool->error = false;
        res_bool->attribute = "bool";
        res_bool->IR_node_quadruple = new_line;
        res_bool->IR_node_identifier = "@t1";        
        $$ = res_bool;
    }
|   ID
    {
        semantic_result* res_bool = new semantic_result;
        res = Table.get_type($1);
        if(res.error){
            semantic_error(res);
            res_bool->error = true;
            $$ = res_bool;
        }    
        else{
            string id($1);
            string new_line("@t1 = "+id);
            res_bool->error = false;
            res_bool->attribute = "bool";
            res_bool->IR_node_quadruple = new_line;
            res_bool->IR_node_identifier = "@t1";
            $$ = res_bool;
        }
    }
;
rel_expression:
    numerical_expression REL_OP numerical_expression
    {
        semantic_result* res_bool = new semantic_result;
        node* casted_ptr = static_cast<node *> ($1);
        node* casted_ptr2 = static_cast<node *> ($3);
        res = casted_ptr -> define_type(0);
        if(res.error){
            semantic_error(res);
            res_bool->error = true;
            $$ = res_bool;
        }
        else
        {
            string quadruple1 = res.IR_node_quadruple;
            string identifier1 = res.IR_node_identifier;
            res = casted_ptr2 -> define_type(1);
            if(res.error){
                semantic_error(res);
                res_bool->error = true;
                $$ = res_bool;    
            }else{
                string quadruple2 = res.IR_node_quadruple;
                string identifier2 = res.IR_node_identifier;
                string rel_op($2);
                string new_line("@t1 = "+identifier1+rel_op+identifier2);
                new_line = quadruple1+"\n"+quadruple2+"\n"+new_line;
                res_bool->error = false;
                res_bool->attribute = "bool";
                res_bool->IR_node_quadruple = new_line;
                res_bool->IR_node_identifier = "@t1";
                $$ = res_bool;
            } 
        }        
    }
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

void semantic_error(semantic_result res)
{
//     if(!semantic_error_counter)
//     {
        error_count++;
        cout<<"\n---semantic error in line "<<yylineno<<" : << "<<lineBuffer<< " >> "<<res.message<<" ---";
    //     semantic_error_counter = true;
    // }

}

void yyerror (char* s)
{
    error_count++;
    printf("\n---%s in line %d : << %s >>---", s, yylineno, lineBuffer);
}

char* to_char_ptr (const string& str)
{
    char* char_ptr = new char[str.length() +1];
    strcpy(char_ptr, str.c_str());
    return char_ptr;
}

semantic_result get_type_relation(string type1, string type2)
{
    semantic_result res;
    if(type1 == "string" && type2 == "string")
    {
        res.error = false;
    }
    else if(type1 == "int" && type2 == "int")
    {
        res.error = false;
    }
    else if(type1 == "float" && type2 == "float")
    {
        res.error = false;
    }
    else if(type1 == "bool" && type2 == "bool")
    {
        res.error = false;
    }
    else if(type1 == "float" && type2 == "int")
    {
        res.error = false;
    }
    else if(type1 == "int" && type2 == "float")
    {
        res.error = false;
    }
    else
    {
        res.error = true;
        res.message = "Incompatible types in assigning operation.";
    }
    return res;
}

int main(int argc, char** argv) {
    clock_t start_time, end_time;
    double execution_time;

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

    printf("Finalizado...\n");
    if(error_count==0)
        block_stack.write_file("IR.txt");
    // if (B == 1)
    //     printf("\n\nParseo no finalizado debido a errores, tiempo de ejecucion: %.20f segundos\n", execution_time);
    // else
    //     printf("\n\nParseo completado sin errores, tiempo de ejecucion: %.20f segundos\n", execution_time);

    return 0;
}
