#ifndef LLVM_GENERATOR_H
#define LLVM_GENERATOR_H
#include <iostream>
#include <stack>
#include <queue>
#include <vector>
#include <variant>
#include <unordered_set>

using namespace std;

typedef vector<variant<int, string>> llvm_line;

class llvm_instruction{
    private:
        llvm_line line;
    
    public: 
        llvm_instruction(llvm_line line_param);
        ~llvm_instruction();
        void print_line(int sym_link_offset);
};

class llvm_block{
    private:
        int sym_link;
        int condition_sym_link;
        int following_block_sym_link;
        int block_to_jump_to_sym_link;
        string block_type = "";
        queue <llvm_line> line_queue;
    public:
        llvm_block();
        llvm_block(int sym_link_param);
        ~llvm_block();
        void print_block(int sym_link_offset, queue < llvm_line > static_declarations_queue);
        void add_line_to_queue(llvm_line line);
        void print_line(llvm_line line);
        void print_line(llvm_line line, int sym_link_offset);
        int get_block_sym_link();
        void set_following_block_sym_link(int sym_link);
        void set_block_to_jump_to_sym_link(int sym_link);
        void set_block_type(string block_type_param);
        void set_condition(int condition_sym_link_param);                
        void define_last_line();
};

class llvm_generator
{
    private:
        //function constants
        const string memcpy = "declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg)";
        
        int sym_link_offset = 0;
        int sym_link_count;
        llvm_block* current_block;

        queue < llvm_block* > block_queue;
        queue < llvm_line > static_declarations_queue;
        queue < llvm_line > global_declarations_queue;
        unordered_set < string > function_declarations_set;
        stack < llvm_block* > block_stack;

    public:
        llvm_generator();
        ~llvm_generator();

        void create_new_block();

        void print_llvm_code();

        void print_block_queue();

        void print_global_declarations_queue();

        void print_function_declarations_set();

        //Function for handling of if/loop blocks
        void if_starts();
        void if_ends();
        void while_starts();
        void while_ends();

        //Functions for handling lines addition to the current block

        void add_line_to_current_block(llvm_line line);

        //Pushes declaration into the static declarations queue and adds 1 to the sym_link_offset
            //returns the symbolic link to the variable
        int add_static_declaration(string type);

        //Functions for storing values
        //overload for constant values
        void store_value_in_variable(int sym_link_to_variable, string variable_type, string variable_name,string value);
        //overload for symbolic links to values
        void store_value_in_variable(int sym_link_to_variable, string variable_type, int sym_link_to_value);

        //Functions for loading values 
            //returns the symbolic link to the result 
        int load_value_from_variable(int sym_link_to_variable, string variable_type);

        //Function for adding a global declaration
        void add_global_declaration(llvm_line global_declaration);

        //Function for adding a function declaration
        void add_function_declaration(llvm_line function_declaration);

        // //Functions for allocating variables, return the symbolic link to the variable
        // int allocaInt();
        // int allocaDouble();
        // int allocaBool();
        // int allocaStr();

        // //Functions for storing values in variables
        // void storeInt(string value, int sym_link);
        // void storeDouble(string value, int sym_link);
        // void storeBool(string value, int sym_link);
        // void storeStr(string value, int sym_link);

        // //Functions for loading values from variables
        // //returns the symbolic link to the result
        // int loadInt(int sym_link);
        // int loadDouble(int sym_link);
        // int loadBool(int sym_link);
        // int loadStr(int sym_link);

        // //Functions for transforming values from one type to another
        // //returns the symbolic link to the result
        // int intToDouble(int sym_link);
        // int doubleToInt(int sym_link);

        // //Functions for operations with integers
        // //returns the symbolic link to the result
        // int addInt(string value1,string value2);
        // int subInt(string value1,string value2);
        // int mulInt(string value1,string value2);
        // int divInt(string value1,string value2);

        // //Functions for operations with doubles
        // //returns the symbolic link to the result
        // int addDouble(string value1,string value2);
        // int subDouble(string value1,string value2);
        // int mulDouble(string value1,string value2);
        // int divDouble(string value1,string value2);

        // //Functions for operations between integers and doubles
        // //returns the symbolic link to the result
        // int addIntDouble(string value1,string value2);
        // int subIntDouble(string value1,string value2);
        // int mulIntDouble(string value1,string value2);
        // int divIntDouble(string value1,string value2);

};

#endif