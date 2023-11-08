#include "sym_table.h"
#include <iostream>
#include <string>
#include <unordered_map>
#include <stack>
#include <string.h>

using namespace std;


sym_table::sym_table()
{
    //Creating the global scope
    semantic_result res = new_scope();
    if(res.error)
        cout<<res.error;
}

sym_table::~sym_table()
{
    while(!scope_stack.empty())
    {
        semantic_result res;
        res = delete_scope();
        cout<<res.message<<"\n";
    }
}

semantic_result sym_table::new_scope()
{
    try
    {
        sym_hash_table* ptr = nullptr;
        ptr = new  sym_hash_table;
        scope_stack.push(ptr);
        semantic_result res;
        res.error = false;
        res.message = "new scope created successfully";
        return res;
    }
    catch(const std::exception& e)
    {
        semantic_result res;
        res.error = true;
        res.message = e.what();       
        return res;
    }
}

sym_hash_table* sym_table::current_scope()
{
    if(!scope_stack.empty())
        return scope_stack.top(); 
    else
        return nullptr;
}

semantic_result sym_table::delete_scope()
{
    if(!scope_stack.empty())
    {
        sym_hash_table* ptr = nullptr;
        ptr = current_scope();
        if(ptr != nullptr)
        {
            delete ptr;
            scope_stack.pop();
            semantic_result res;
            res.error = false;
            res.message = "deleted scope successfully";
            return res;
        }
        else
        {
            semantic_result res;
            res.error = true;
            res.message = "unable to delete scope, stack empty";
            return res;
        }
    }
    else
    {
        semantic_result res;
        res.error = true;
        res.message = "unable to delete scope, stack empty";
        return res;
    }
}

sym_hash_table* sym_table::is_on_table(string name)
{
    //Copy the pointer stack
    stack <sym_hash_table*> temp_stack = scope_stack;

    //Iterate through each scope starting from the current one                                                                                
    while(!temp_stack.empty())
    {
        //Init hash_table pointer
        sym_hash_table* ptr = nullptr;
        //assign pointer to the top of the temp stack (which represents the sym_table of a scope)
        ptr = temp_stack.top();

        //check if the ID is in the scope
        if((*ptr).count(name)>0)
        {
            //If so, return the scope
            return ptr;
        }
        //pop the top pointer if the ID was not found, then look for it in the following scope
        temp_stack.pop();
    }

    //Return nullptr if the ID wasn't found in any of the scopes
    return nullptr;
}

semantic_result sym_table::get_type(string name)
{
    semantic_result res;
    string id_type;
    sym_hash_table* ptr = nullptr;
    ptr = is_on_table(name);
    if(ptr != nullptr)
    {
        id_type = (*ptr)[name];
        res.error = false;
        res.message = "Retrieved type successfully";
        res.attribute = id_type;
        return res;
    }   
    else
    {
        res.error = true;
        res.message = "Variable \""+name+"\" not declared in this scope";        
        return res;
    }
}

semantic_result sym_table::insert(string name, string type)
{
    sym_hash_table* ptr = nullptr;
    ptr = current_scope();
    if(ptr != nullptr)
    {
        //If the variable is not already declared in this or previous scopes.
        if(is_on_table(name)== nullptr)
        {
            (*ptr)[name] = type;
            semantic_result res;
            res.error = false;
            res.message = "ID added successfully";
            return res;
        }
        else
        {
            semantic_result res;
            res.error = true;
            res.message = "ID is already declared in this scope";            
            return res;
        }
    }
    else
    {
        semantic_result res;
        res.error = true;
        res.message = "There's no current scope, stack empty";
        return res;
    }       
}

node::node(char* data_parameter, char* type_parameter)
{
    data = data_parameter;
    type = type_parameter;
    right_node = nullptr;
    left_node = nullptr;
}

node::node(char* data_parameter)
{
    data = data_parameter;
    type = nullptr;
    right_node = nullptr;
    left_node = nullptr;
}   

void node:: assign_left_node(node* node_ptr)
{
    left_node = node_ptr;
}

void node::assign_right_node(node* node_ptr)
{
    right_node = node_ptr;
}

node* node::get_left_node()
{
    return left_node;
}

node* node::get_right_node()
{
    return right_node;
}

void node::insert_left_most(node* node_ptr)
{
    if(left_node == nullptr)
    {
        assign_left_node(node_ptr);
    }
    else
    {
        left_node->insert_left_most(node_ptr);
    }
}

string node::post_order_traversal()
{
    string traversal = "";

    if(left_node!=nullptr)
    {
        traversal += left_node -> post_order_traversal() + ",";
    }

    if(right_node!=nullptr)
    {
        traversal += right_node -> post_order_traversal() + ",";
    }

    traversal += data;

    return traversal;
}

semantic_result node::define_type()
{
    semantic_result res;
    char* type1 = nullptr;
    char* type2 = nullptr;
    char* op = nullptr; 
    //Recorriendo el camino izquierdo...

    if(left_node != nullptr)
    {
        res = left_node -> define_type();
        if(res.error)
        {
            return res;
        }
        else
        {
            type1 = to_char_ptr(res.attribute);
        }
    }        
    //Caso hijo izq nullptr
    else
    {
        //leaf node...
        if(type != nullptr)
        {
            res.error = false;
            res.attribute = type;
            res.message = "Type retrieved succesfully.";
            return res;    
        }
        //Nodo operador sin hijo izq, hubo un error de sintaxis. En teoria esto no deberia pasar...
        else if(strcmp(data, "+") == 0 || strcmp(data, "-") == 0 || strcmp(data, "*") == 0 || strcmp(data, "/") == 0)
        {
            res.error = true;
            res.message= "Bad expression, missing operand.";
            return res;
        }
        //Pasa cuando un ID no estuvo definido en la tabla
        else
        {
            res.error = true;
            res.message= "Variable \""+string(data)+"\" not declared in this scope";
            return res;
        }    
    }
    
    //CLAVE PARA COMPARAR CHAR *
    if(strcmp(data, "+") == 0 || strcmp(data, "-") == 0 || strcmp(data, "*") == 0 || strcmp(data, "/") == 0)
    {
        op = data;
    }
    else
    {
        res.error = true;
        res.message = "Bad tree, missing operator";
        return res;
    }


    //Recorrido derecho
    if(right_node != nullptr)
    {
        res = right_node -> define_type();
        if(res.error)
        {
            return res;
        }
        else
        {
            type2 = to_char_ptr(res.attribute);
        }
    }        
    //Caso hijo der nullptr
    else
    {
        //leaf node...
        if(type != nullptr)
        {
            res.error = false;
            res.attribute = type;
            res.message = "Type retrieved succesfully.";
            return res;    
        }
        //Nodo operador sin hijo izq, hubo un error de sintaxis. En teoria esto no deberia pasar...
        else if(strcmp(data, "+") == 0 || strcmp(data, "-") == 0 || strcmp(data, "*") == 0 || strcmp(data, "/") == 0)
        {
            res.error = true;
            res.message= "Bad expression, missing operand.";
            return res;
        }
        //Pasa cuando un ID no estuvo definido en la tabla
        else
        {
            res.error = true;
            res.message= "Variable \""+string(data)+"\" not declared in this scope";
            return res;
        }        
    }

    return type_system(type1, type2, op);
}

semantic_result node::type_system(char* type1, char* type2, char* op)
{
    semantic_result res;
    if (strcmp(type1, "int") == 0 && strcmp(type2, "int") == 0)
    {
        if(strcmp(op, "+") == 0 || strcmp(op, "-") == 0|| strcmp(op, "*") == 0)
        {
            res.error = false;
            res.message = "";
            res.attribute = "int";
            return res;
        }   
        else if(strcmp(op, "/") == 0)
        {
            res.error = false;
            res.message = "";
            res.attribute = "float";
            return res;
        }
    }
    else if(strcmp(type1, "float") == 0 || strcmp(type2, "float") == 0)
    {
        res.error = false;
        res.message= "";
        res.attribute = "float";
        return res;
    }
    res.error = true;    
    res.message= "Incompatible operation \""+string(op)+"\" with operands of the types "+string(type1)+" and "+string(type2)+".";
    res.attribute = "error";
    return res;
}

char* node::to_char_ptr(const string& str)
{
    char* char_ptr = new char[str.length() +1];
    strcpy(char_ptr, str.c_str());
    return char_ptr;
}