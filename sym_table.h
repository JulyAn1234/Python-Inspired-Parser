#ifndef SYM_TABLE_H
#define SYM_TABLE_H

#include <iostream>
#include <string>
#include <unordered_map>
#include <stack>

using namespace std;

struct semantic_result
{
    bool error;
    string message;
    string attribute;
    string IR_node_quadruple;
    string IR_node_identifier;
    int IR_temp_variable_counter;
};

struct temp_node
{
    char* type;
    char* op;
};

typedef struct semantic_result semantic_result;
typedef unordered_map <string, string> sym_hash_table;

class node
{
    public:
        char* data;
        char* type;
        node* left_node = nullptr;
        node* right_node = nullptr;
        node(char* data, char* type);
        node(char* data);
        void assign_left_node(node* node_ptr);
        void assign_right_node(node* node_ptr);
        node* get_left_node();
        node* get_right_node();
        void insert_left_most(node* node_ptr);
        string post_order_traversal();
        semantic_result define_type(int temp_variable_counter);
        semantic_result type_system(char* type1, char* type2, char* op);
        char* to_char_ptr (const string& str);
};

class sym_table
{
    private:
        stack <sym_hash_table*> scope_stack;
    public:
        sym_table();
        ~sym_table();
        //Same Idea as top from the stack data structure
        sym_hash_table* current_scope ();
        //Same Idea as push from the stack data structure
        semantic_result new_scope();
        //Same Idea as pop from the stack data structure
        semantic_result delete_scope();
        //Insert value in the hash table of the current scope
        semantic_result insert(string name, string type);
        //Search in stack
        sym_hash_table* is_on_table(string name);
        //Search and return the value
        semantic_result get_type(string name);

};

#endif 