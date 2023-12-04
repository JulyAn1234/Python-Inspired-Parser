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
#include "llvm_generator.h"
//Prototipos y externos, se rompe todo si no estan...
int yylex();
extern FILE* yyin;
void yyerror(char* s);
char* to_char_ptr (const string& str);
void semantic_error(semantic_result res);
semantic_result type_system_numeric(char* type1, char* type2, char* op);
semantic_result get_type_relation(string type1, string type2);
semantic_result get_type_relation_for_rel_ops(string type1, string type2);
extern char lineBuffer[1000];
extern int yylineno;

sym_table Table;
semantic_result res;
semantic_result res_MYWAY;
block_stack block_stack;
llvm_generator* excalibur_builder = new llvm_generator();
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

%token NEW_LINE
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
|   if_statement
    {
        res = Table.delete_scope();
        if(res.error)
        {
            semantic_error(res);
        }
        excalibur_builder->if_ends();
        
    }
|   loop
    {
        res = Table.delete_scope();
        if(res.error)
        {
            semantic_error(res);
        }
        excalibur_builder->while_ends();
        
    }
;

///////////////////// BUCLES //////////////////

loop_init:
    WHILE bool_expression COLON 
    {
        res = Table.new_scope();
        if(res.error)
            semantic_error(res);
        else{
            semantic_result* casted_ptr = static_cast<semantic_result *> ($2);
            res = *casted_ptr;
            if(!res.error){
                //Write IR code
                int sym_link_to_condition = res.sym_link;
                excalibur_builder->while_starts(sym_link_to_condition);
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
        cout<<"\nif init ";
        res = Table.new_scope();
        if(res.error)
            semantic_error(res);
        else{
            cout<<"llega0...";
            semantic_result* casted_ptr = static_cast<semantic_result *> ($2);
                                        
            res = *casted_ptr;
            if(!res.error){
                cout<<"llega...";
                //Write IR code
                int sym_link_to_condition = res.sym_link;
                excalibur_builder->if_starts(sym_link_to_condition);
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
        int sym_link = excalibur_builder->add_static_declaration($1);
        res = Table.insert($2, $1, sym_link);
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
        int variable_link=0;
        string tree_result_data;
        int tree_result_link;
        bool tree_result_is_constant;

        res = Table.get_type($1);
        if(res.error)
        {
            semantic_error(res);
            type1 = "undefined";
        }
        else
        {
            type1 = res.attribute;
            variable_link = res.sym_link;
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
                tree_result_is_constant = res.is_constant;
                if(tree_result_is_constant)
                    tree_result_data = res.data;
                else
                    tree_result_link = res.sym_link;
                
                res = get_type_relation(type1, type2);
                if(res.error)
                {
                    semantic_error(res);
                }
                else//Write IR code
                {
                    //Type conversions
                    if(type1 == "float"){
                        if(type2 == "int"){
                            if(tree_result_is_constant){
                                tree_result_data = strcat(to_char_ptr(tree_result_data), ".0");
                            }else{
                                tree_result_link = excalibur_builder->int_to_double(tree_result_link);
                            }
                            type2 = "float";
                        }
                        //bools and strings do not get here
                        if(tree_result_is_constant){
                            excalibur_builder->store_value_in_variable(variable_link,"float", $1, tree_result_data);
                        }else{
                            excalibur_builder->store_link_in_variable(variable_link,"float", tree_result_link);
                        }
                    }else if(type1 == "int"){
                        if(type2 == "float"){
                            if(tree_result_is_constant){
                                double casted_tree_data = stod(tree_result_data);
                                int casted_tree_data_int = static_cast<int> (casted_tree_data);
                                tree_result_data = to_string(casted_tree_data_int);
                            }else{
                                tree_result_link = excalibur_builder->double_to_int(tree_result_link);
                            }
                        type2 = "int";
                        }
                    }

                    //storing values
                    if(tree_result_is_constant){
                        excalibur_builder->store_value_in_variable(variable_link,type1, $1, tree_result_data);
                    }else{
                        if(type1 == "string"){
                            excalibur_builder->store_link_to_string_variable(variable_link, tree_result_link);
                        }else{
                            excalibur_builder->store_link_in_variable(variable_link, type1, tree_result_link);
                        }
                    }
                }
            }
        }
    }
;

method_call:
    //read gets input from user and assign to a variable
    READ ID 
    {
        res = Table.get_type($2);
        if(res.error)
            semantic_error(res);
        else{
            int sym_link = res.sym_link;
            string type = res.attribute;
            if(type == "bool"){
                semantic_result res;
                res.error = true;
                res.message = "Cannot read a bool value";
                semantic_error(res);
            }else{
                //Call a excalibur_builder that calls the scanf/fgets function
                // excalibur_builder->read_variable(sym_link, type);
            }
        } 
    }
    //write prints the value of a variable
|   WRITE write_parameter

|   WRITE write_parameter NEW_LINE
    {
        excalibur_builder->print_new_line();
    }
;

write_parameter:
    STRING
    {
        string text($1);
        //Calls a excalibur_builder that calls the printf function for constant strings
        excalibur_builder->print_constant_string(text);
    }
|   ID
    {
        res = Table.get_type($1);
        if(res.error)
            semantic_error(res);
        else{
            int sym_link = res.sym_link;
            string type = res.attribute;
            //Call a excalibur_builder that calls the printf function
            excalibur_builder->print_variable(sym_link, type);
        }
    }
;

/////////////////////////////////////////////EXPRESIONES////////////////////////////////////////

//PARA USAR EN ASIGNACIÓN
expression:
    STRING
    {
        string text($1);
        //eliminate the quotes
        text.erase(0,1);
        text.erase(text.length()-1,1);
        cout<<"text:"<<text<<endl;
        semantic_result* res = new semantic_result;
        res->error = false;
        res->attribute = "string";
        res->data = to_char_ptr(text);
        res->is_constant = true;
        res->sym_link = -1;
        $$ = res; 
    }
|   numerical_expression
    {
        semantic_result Node_res;        
        node* casted_ptr = static_cast<node *> ($1);
        Node_res = casted_ptr -> define_type(0, excalibur_builder); 
        semantic_result* res = new semantic_result(Node_res);
        $$ = res;
    }
|   BOOL
{
    string bool_value($1);
    semantic_result* res = new semantic_result;
    res->error = false;
    res->attribute = "bool";
    if(bool_value == "true")
        res->data = "1";
    else
        res->data = "0";
    res->is_constant = true;
    res->sym_link = -1;
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
            $$ = new node($1,to_char_ptr(res.attribute), res.sym_link);
        }
        else
        {
            $$ = new node($1);
        }
    }
|   INTEGER 
    {
        $$ = new node($1,"int", true);
    }
|   FLOATING
    {
        $$ = new node($1,"float", true);
    }
|   LEFT_GROUP numerical_expression RIGHT_GROUP
    {
        $$ = $2;
    }
;

bool_expression:
    rel_expression
    {
        $$ = $1;
    }
|   BOOL
    {
        semantic_result* res_bool = new semantic_result;
        string bool_value($1);
        int sym_link_to_result = excalibur_builder->load_constant_bool(bool_value);
        res_bool->error = false;
        res_bool->attribute = "bool";
        res_bool->sym_link = sym_link_to_result;
        res_bool->is_constant = false;        
        $$ = res_bool;
    }
|   ID
    {
        semantic_result res_bool_local;
        res = Table.get_type($1);
        if(res.error){
            semantic_error(res);
            $$ = &res;
        }    
        else{
            int sym_link_to_result = res.sym_link;
            string type = res.attribute;
            if(type != "bool"){
                res_bool_local.error = true;
                res_bool_local.message = "Cannot use a non-bool variable as a condition";
                semantic_error(res_bool_local);
                $$ = &res;
            }else{
                sym_link_to_result = excalibur_builder->load_bool_variable_for_condition(sym_link_to_result);

                res_bool_local.error = false;
                res_bool_local.attribute = "bool";
                res_bool_local.sym_link = sym_link_to_result;
                res_bool_local.is_constant = false;

                semantic_result* res_bool = new semantic_result(res_bool_local);
                $$ = res_bool;
            }
        }
    }
;
rel_expression:
    numerical_expression REL_OP numerical_expression
    {
        string op($2);
        node* casted_ptr = static_cast<node *> ($1);
        node* casted_ptr2 = static_cast<node *> ($3);
        res = casted_ptr -> define_type(0, excalibur_builder);
        if(res.error){
            semantic_error(res);
            $$ = &res;
        }
        else{
            //getting the first expression data
            bool is_constant_1 = res.is_constant;
            string type_1 = res.attribute;
            string data_1;
            int sym_link_1;

            if(is_constant_1)
                data_1 = res.data;
            else
                sym_link_1 = res.sym_link;

            res = casted_ptr2 -> define_type(1, excalibur_builder);
            if(res.error){
                semantic_error(res);
                $$ = &res;    
            }else{
                bool is_constant_2 = res.is_constant;
                string type_2 = res.attribute;
                string data_2;
                int sym_link_2;
                if(is_constant_2)
                    data_2 = res.data;
                else
                    sym_link_2 = res.sym_link;

                //Checking if the types are compatible (defining the expression's type)
                res = get_type_relation_for_rel_ops(type_1, type_2);
                if(res.error){
                    semantic_error(res);
                    $$ = &res;
                }else{
                    string rel_expression_type = res.attribute;
                    //making type conversions
                    if(rel_expression_type == "float"){
                        if(type_1 == "int"){
                            if(is_constant_1){
                                data_1 = strcat(to_char_ptr(data_1), ".0");
                            }else{
                                sym_link_1 = excalibur_builder->int_to_double(sym_link_1);
                            }
                            type_1 = "float";
                        }
                        if(type_2 == "int"){
                            if(is_constant_2){
                                data_2 = strcat(to_char_ptr(data_2), ".0");
                            }else{
                                sym_link_2 = excalibur_builder->int_to_double(sym_link_2);
                            }
                            type_2 = "float";
                        }
                    }
                    
                    //writing IR according to the type of the expression and operands properties
                    int sym_link_to_condition;
                    if(is_constant_1){
                        if(is_constant_2){
                            sym_link_to_condition = excalibur_builder->constant_to_constant_operation(data_1, data_2, op, type_1);
                        }else{
                            sym_link_to_condition = excalibur_builder->constant_to_link_operation(data_1, sym_link_2, op, type_1);   
                        }
                    }else{
                        if(is_constant_2){
                            sym_link_to_condition = excalibur_builder->link_to_constant_operation(sym_link_1, data_2, op, type_1);
                        }else{
                            sym_link_to_condition = excalibur_builder->link_to_link_operation(sym_link_1, sym_link_2, op, type_1);
                        }
                    }
                    semantic_result res_bool_local;
                    res_bool_local.error = false;
                    res_bool_local.attribute = "bool";
                    res_bool_local.sym_link = sym_link_to_condition;
                    res_bool_local.is_constant = false;

                    semantic_result* res_bool = new semantic_result(res_bool_local);
                    $$ = res_bool;
                }
            } 
        }        
    }
;

%%

void semantic_error(semantic_result res)
{
    try{
        error_count++;
        cout<<"\n---semantic error in line "<<yylineno<<" : << "<<lineBuffer<< " >> "<<res.message<<" ---";
        // cout<<"???"<<endl;
    }catch (exception& e){
        cout<<"Exception: "<<e.what()<<endl;
    }
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

semantic_result get_type_relation_for_rel_ops(string type1, string type2){
    semantic_result res;
    //only ints and floats can be compared
    if(type1 == "int" && type2 == "int"){
        res.error = false;
        res.attribute = "int";
    }
    else if(type1 == "float" && type2 == "float"){
        res.error = false;
        res.attribute = "float";
    }
    else if(type1 == "float" && type2 == "int"){
        res.error = false;
        res.attribute = "float";
    }
    else if(type1 == "int" && type2 == "float"){
        res.error = false;
        res.attribute = "float";
    }
    else{
        res.error = true;
        res.message = "Incompatible types in relational operation.";
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

    end_time = clock();  // Get the final clock time*

    // Calculate the execution time in seconds
    execution_time = (double)(end_time - start_time) / CLOCKS_PER_SEC;

    if(error_count==0){
        block_stack.write_file("IR.txt");
        string file_name(argv[1]);
        string file_name_no_extension = file_name.substr(0, file_name.find("."));
        string file_name_ll = file_name_no_extension + ".ll";
        excalibur_builder->generate_llvm_IR_file(file_name_ll);
        
        string command = "clang -o "+file_name_no_extension+" -x ir "+file_name_ll;

        system(command.c_str());        
        
        cout<<"Compiling time: "<<execution_time<<" seconds"<<endl;
        cout<<"Files "<<file_name_no_extension<<" and "<<file_name_ll<<" generated successfuly."<<endl;
    }

    return 0;
}
