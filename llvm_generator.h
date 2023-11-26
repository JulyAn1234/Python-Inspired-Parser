#ifndef LLVM_GENERATOR_H
#define LLVM_GENERATOR_H
#include <iostream>
#include <stack>
#include <queue>

using namespace std;

struct value_interface
{
    string value;
    string type;
    string is_variable;
};

class llvm_generator
{
    private:
        int sym_link_count;
        llvm_block* current_block;
        queue < llvm_block* > block_queue;
        stack < llvm_block* > block_stack;

    public:
        llvm_generator();
        ~llvm_generator();

        void create_new_block();

        void print_block_queue();

        //Function for handling of if/loop blocks
        void if_starts();
        void if_ends();
        void while_starts();
        void while_ends();

        void add_line_to_current_block(string line);

        //Functions for allocating variables, return the symbolic link to the variable
        int allocaInt();
        int allocaDouble();
        int allocaBool();
        int allocaStr();

        //Functions for storing values in variables
        void storeInt(string value, int sym_link);
        void storeDouble(string value, int sym_link);
        void storeBool(string value, int sym_link);
        void storeStr(string value, int sym_link);

        //Functions for loading values from variables
        //returns the symbolic link to the result
        int loadInt(int sym_link);
        int loadDouble(int sym_link);
        int loadBool(int sym_link);
        int loadStr(int sym_link);

        //Functions for transforming values from one type to another
        //returns the symbolic link to the result
        int intToDouble(int sym_link);
        int doubleToInt(int sym_link);

        //Functions for operations with integers
        //returns the symbolic link to the result
        int addInt(string value1,string value2);
        int subInt(string value1,string value2);
        int mulInt(string value1,string value2);
        int divInt(string value1,string value2);

        //Functions for operations with doubles
        //returns the symbolic link to the result
        int addDouble(string value1,string value2);
        int subDouble(string value1,string value2);
        int mulDouble(string value1,string value2);
        int divDouble(string value1,string value2);

        //Functions for operations between integers and doubles
        //returns the symbolic link to the result
        int addIntDouble(string value1,string value2);
        int subIntDouble(string value1,string value2);
        int mulIntDouble(string value1,string value2);
        int divIntDouble(string value1,string value2);

};

class llvm_block{
    private:
        int sym_link;
        int condition_sym_link;
        int following_block_sym_link;
        int block_to_jump_to_sym_link;
        string block_type;
        queue <string> line_queue;

    public:
        llvm_block();
        llvm_block(int sym_link_param);
        ~llvm_block();
        void print_block();
        void add_line_to_queue(string line);
        void print_line(string line);
        void set_following_block_sym_link(int sym_link);
        void set_block_to_jump_to_sym_link(int sym_link);
        void set_block_type(string block_type_param);
        void set_condition(int condition_sym_link);                
        void define_last_line();
};

#endif