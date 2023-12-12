#ifndef LLVM_GENERATOR_H
#define LLVM_GENERATOR_H
#include <iostream>
#include <stack>
#include <queue>
#include <vector>
#include <variant>
#include <unordered_set>
#include <fstream>
#include <cstdio>

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
        void print_block(int sym_link_offset, queue < llvm_line > static_declarations_queue, ofstream& llvm_IR_file);
        void add_line_to_queue(llvm_line line);
        void print_line(llvm_line line, ofstream& llvm_IR_file);
        void print_line(llvm_line line, int sym_link_offset, ofstream& llvm_IR_file);
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
        const string strcpy = "declare i8* @strcpy(i8* noundef, i8* noundef)";
        const string printf = "declare i32 @printf(i8* noundef, ...)";
        const string fgets = "declare i8* @fgets(i8* noundef, i32 noundef, %struct._IO_FILE* noundef)";
        const string getchar = "declare i32 @getchar()";
        const string scanf = "declare i32 @__isoc99_scanf(i8* noundef, ...)";        

        const string int_specifier_string = "@.str.int = private unnamed_addr constant [3 x i8] c\"%d\\00\", align 1";
        const string double_specifier_string = "@.str.double = private unnamed_addr constant [4 x i8] c\"%lf\\00\", align 1";
        const string string_specifier_string = "@.str.str = private unnamed_addr constant [3 x i8] c\"%s\\00\", align 1";;
        const string new_line_specifier_string = "@.str.nl = private unnamed_addr constant [2 x i8] c\"\\0A\\00\", align 1";

        int sym_link_offset = 0;
        int sym_link_count;
        llvm_block* current_block;

        queue < llvm_block* > block_queue;
        unordered_set < string > format_specifiers_set;
        queue < llvm_line > static_declarations_queue;
        queue < llvm_line > global_declarations_queue;
        unordered_set < string > function_declarations_set;
        stack < llvm_block* > block_stack;

        ofstream llvm_IR_file;

    public:
        llvm_generator();
        ~llvm_generator();

        int get_sym_link_count();

        void create_new_block();

        void generate_llvm_IR_file(string file_name);

        void initialize_file(string file_name);

        void print_block_queue();

        void print_format_specifiers_set();

        void print_global_declarations_queue();

        void print_function_declarations_set();

        //Function for handling of if/loop blocks
        void if_starts(int sym_link_to_condition);
        void if_ends();
        void while_starts(int sym_link_to_condition);
        void while_starts();
        void while_ends();

        //Functions for handling lines addition to the current block

        void add_line_to_current_block(llvm_line line);

        //Pushes declaration into the static declarations queue and adds 1 to the sym_link_offset
            //returns the symbolic link to the variable
        int add_static_declaration(string type);

        //Functions for I/O
            //Functions for output
        void print_constant_string(string text);
        void print_variable(int sym_link_to_variable, string variable_type);
        void print_new_line();

            //Functions for input
        void read_variable(int sym_link, string type);

        //Functions for storing values
        //for constant values
        void store_value_in_variable(int sym_link_to_variable, string variable_type, string variable_name,string value);
        //for symbolic links to values
        void store_link_in_variable(int sym_link_to_variable, string variable_type, int sym_link_to_value);

        //for storing the value of a string variable in another string variable
        void store_link_to_string_variable(int sym_link_to_variable_to_change, int sym_link_to_string_to_be_stored);

        //Functions for loading values 
            //returns the symbolic link to the result 
        int load_value_from_variable(int sym_link_to_variable, string variable_type);
        int load_constant_bool(string constant);
        int load_bool_variable_for_condition(int sym_link_to_variable);

        //Function for adding a global declaration
        void add_global_declaration(llvm_line global_declaration);

        //Functions for converting values
        int int_to_double(int sym_link_to_variable);
        int double_to_int(int sym_link_to_variable);

        //Functions for performing binary operations
        int link_to_link_operation(int sym_link1, int sym_link2, string op, string type);
        int link_to_constant_operation(int sym_link,string constant, string op, string type);
        int constant_to_link_operation(string constant, int sym_link, string op, string type);                
        int constant_to_constant_operation(string constant1, string constant2, string op, string type);

};

#endif