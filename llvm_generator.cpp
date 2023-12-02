#include "llvm_generator.h"
#include <iostream>
#include <stack>
#include <queue>
#include <vector>
#include <variant>
#include <unordered_set>
#include <fstream>
#include <cstdio>

using namespace std;

llvm_generator::llvm_generator(){
    sym_link_count = 0;
    create_new_block();
}

llvm_generator::~llvm_generator(){}

void llvm_generator::add_line_to_current_block(llvm_line line){
    current_block->add_line_to_queue(line);
}

void llvm_generator::create_new_block(){
    current_block = new llvm_block(sym_link_count);
    sym_link_count++;    
}

void llvm_generator::if_starts(){
    //Set condition
    current_block->set_condition(sym_link_count);
    sym_link_count++;

    //set block final settings
    current_block->set_block_type("ends_in_condition");
    current_block -> set_following_block_sym_link (sym_link_count);    
    //push block into stack and queue
    block_stack.push(current_block);
    block_queue.push(current_block);
    
    create_new_block();
}

void llvm_generator::if_ends(){
    //setting block final settings
    current_block-> set_block_type("ends_in_jump");
    current_block-> set_following_block_sym_link(sym_link_count);
    block_queue.push(current_block);

    //getting the original block and defining the block to jump to if the condition
        //is not true
    block_stack.top() -> set_block_to_jump_to_sym_link(sym_link_count);
    block_stack.pop();

    create_new_block();

}

void llvm_generator::while_starts(){
    //Setting block final settings
    current_block->set_block_type("ends_in_jump");
    current_block->set_following_block_sym_link(sym_link_count);
    block_queue.push(current_block);

    create_new_block();

    if_starts();
}

void llvm_generator::while_ends(){

    //Recovering the sym_link to the while condition
    int sym_link_to_while_condition =
        block_stack.top() -> get_block_sym_link();

    //setting the block to jump to if the condition is not true in the original while condition block.
    block_stack.top() -> set_block_to_jump_to_sym_link(sym_link_count);

    block_stack.pop();

    //setting block final settings
    current_block-> set_block_type("ends_in_jump");
    current_block-> set_following_block_sym_link(sym_link_to_while_condition);
    block_queue.push(current_block);

    create_new_block();
}

int llvm_generator::add_static_declaration(string type){
    sym_link_offset++;
    if(type=="int"){
        static_declarations_queue.push({"%",sym_link_offset," = alloca i32, align 4"});
    }else if(type=="float"){
        static_declarations_queue.push({"%",sym_link_offset," = alloca double, align 8"});
    }else if(type == "string"){
        static_declarations_queue.push({"%",sym_link_offset," = alloca [100 x i8], align 16"});
    }else if(type=="bool"){
        static_declarations_queue.push({"%",sym_link_offset," = alloca i8, align 1"});
    }
    return sym_link_offset;
}

void llvm_generator::print_new_line(){
    function_declarations_set.insert(printf);
    format_specifiers_set.insert(new_line_specifier_string);
    add_line_to_current_block({"%",sym_link_count," = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.nl, i64 0, i64 0))"});
    sym_link_count++;
}

void llvm_generator::print_constant_string(string text){
    //deleting quotes from the string
    text = text.substr(1,text.length()-2);
    //getting the length of the string
    int text_length = text.length() + 1;
    //adding null character "\00" at the end of the string
    text += "\\00";
    //adding the string to the global declarations queue
    global_declarations_queue.push({"@.str."+to_string(sym_link_count)+" = private unnamed_addr constant ["+to_string(text_length)+" x i8] c\""+text+"\", align 1"});
    //adding printf function to function declarations set
    function_declarations_set.insert(printf);
    //adding the call to the printf function to the current block
    add_line_to_current_block({"%",sym_link_count," = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds (["+to_string(text_length)+" x i8], ["+to_string(text_length)+" x i8]* @.str."+to_string(sym_link_count)+", i64 0, i64 0))"});
    sym_link_count++;
}

void llvm_generator::print_variable(int sym_link_to_variable, string variable_type){
    if(variable_type == "int"){
        format_specifiers_set.insert(int_specifier_string);
        function_declarations_set.insert(printf);
        sym_link_to_variable = load_value_from_variable(sym_link_to_variable,"int");
        add_line_to_current_block({"%",sym_link_count," = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([3 x i8], [3 x i8]* @.str.int, i64 0, i64 0), i32 noundef %",sym_link_to_variable," )"});
    }else if(variable_type == "float"){
        format_specifiers_set.insert(double_specifier_string);
        function_declarations_set.insert(printf);
        sym_link_to_variable = load_value_from_variable(sym_link_to_variable,"float");
        add_line_to_current_block({"%",sym_link_count," = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str.double, i64 0, i64 0), double noundef %",sym_link_to_variable," )"});
    }else if(variable_type == "string"){
        format_specifiers_set.insert(string_specifier_string);
        function_declarations_set.insert(printf);
        sym_link_to_variable = load_value_from_variable(sym_link_to_variable,"string");
        add_line_to_current_block({"%",sym_link_count," = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([3 x i8], [3 x i8]* @.str.str, i64 0, i64 0), i8* noundef %",sym_link_to_variable," )"});
    }else{
        format_specifiers_set.insert(int_specifier_string);
        function_declarations_set.insert(printf);

        //not using load function because it would cast the result to a i8 instead of a i32
        add_line_to_current_block({"%",sym_link_count," = load i8, i8* %"+to_string(sym_link_to_variable)+", align 1"});
        sym_link_count++;
        add_line_to_current_block({"%",sym_link_count," = trunc i8 %",(sym_link_count-1)," to i1"});
        sym_link_count++;
        add_line_to_current_block({"%",sym_link_count," = zext i1 %",(sym_link_count-1)," to i32"});
        sym_link_count++;

        add_line_to_current_block({"%",sym_link_count," = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([3 x i8], [3 x i8]* @.str.int, i64 0, i64 0), i32 noundef %",sym_link_count-1," )"});
    }
    sym_link_count++;
}

void llvm_generator::store_value_in_variable(int sym_link_to_variable, string variable_type, string variable_name, string value){
    if(variable_type=="int"){
        add_line_to_current_block({"store i32 "+value+", i32* %"+to_string(sym_link_to_variable)+", align 4"});
    }else if(variable_type=="float"){
        add_line_to_current_block({"store double "+value+", double* %"+to_string(sym_link_to_variable)+", align 8"});
    }else if(variable_type=="string"){
        //add memcpy function to function declarations set
        function_declarations_set.insert(memcpy);
        string global_declaration;
        llvm_line assignation_line;
        int string_length = value.length();
        //check if the string is longer than 99 characters
        if(string_length>=99){
            //if it is, cut it to 99 characters
            value = value.substr(0,99);
            global_declaration = "@__const.main."+variable_name+to_string(sym_link_to_variable)+" = private unnamed_addr constant [100 x i8] c\""+value+"\\00\", align 16";
            assignation_line = {"call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %",sym_link_count,", i8* align 16 getelementptr inbounds ([100 x i8], [100 x i8]* @__const.main."+variable_name+to_string(sym_link_to_variable)+", i32 0, i32 0), i64 100, i1 false)"};
        }else{
            //construct the global declaration of the string
            global_declaration = "@__const.main."+variable_name+to_string(sym_link_to_variable)+" = private unnamed_addr constant <{["+to_string(string_length)+" x i8], ["+to_string(100-string_length)+" x i8]}> <{["+to_string(string_length)+" x i8] c\""+value+"\", ["+to_string(100-string_length)+" x i8] zeroinitializer }>, align 16";
            assignation_line = {
                "call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %",
                sym_link_count,
                ", i8* align 16 getelementptr inbounds (<{["+to_string(string_length)+" x i8], ["+to_string(100-string_length)+" x i8]}>, <{["+to_string(string_length)+" x i8], ["+to_string(100-string_length)+" x i8]}>* @__const.main."+variable_name+to_string(sym_link_to_variable)+", i32 0, i32 0, i32 0), i64 100, i1 false)"
                };
        }
        global_declarations_queue.push({global_declaration});    

        //store the string in the variable
        add_line_to_current_block({"%",sym_link_count," = bitcast [100 x i8]* %"+to_string(sym_link_to_variable)+" to i8*"});
        add_line_to_current_block(assignation_line);
        sym_link_count++;
    }else if(variable_type=="bool"){
        add_line_to_current_block({"store i8 "+value+", i8* %"+to_string(sym_link_to_variable)+", align 1"});
    }
}

void llvm_generator::store_link_in_variable(int sym_link_to_variable, string variable_type, int sym_link_to_value){
    if(variable_type=="int"){
        //store i32 0, i32* %3, align 4
        add_line_to_current_block({"store i32 %",sym_link_to_value,", i32* %"+to_string(sym_link_to_variable)+", align 4"});
    }else if(variable_type == "float"){
        //store double 0.000000e+00, double* %4, align 8
        add_line_to_current_block({"store double %",sym_link_to_value,", double* %"+to_string(sym_link_to_variable)+", align 8"});
    }else if(variable_type == "bool"){
        //store i8 %18, i8* %6, align 1
        add_line_to_current_block({"store i8 %",sym_link_to_value,", i8* %"+to_string(sym_link_to_variable)+", align 1"});
    }
    //string logic for storing links is implemented in another function called store_link_to_string_variable
}

void llvm_generator::store_link_to_string_variable(int sym_link_to_variable_to_change, int sym_link_to_string_to_be_stored){
    //Asume that the string to be stored is already in the correct format
    //Asume parameter sym_link_to_string_to_be_stored is the sym_link to the loaded value of the variable
    //load the value of the variable to change
    sym_link_to_variable_to_change = load_value_from_variable(sym_link_to_variable_to_change,"string");
    //add strcpy function to function declarations set
    function_declarations_set.insert(strcpy);
    //call strcpy function
    //  %60 = call i8* @strcpy(i8* noundef %58, i8* noundef %59) first parameter is the destination, second parameter is the source
    add_line_to_current_block({"%",sym_link_count," = call i8* @strcpy(i8* noundef %",sym_link_to_variable_to_change,", i8* noundef %",sym_link_to_string_to_be_stored,")"});
    sym_link_count++; 
}

int llvm_generator::load_value_from_variable(int sym_link_to_variable, string variable_type){
    int sym_link_to_result = sym_link_count;
    if(variable_type=="int"){ 
        add_line_to_current_block({"%",sym_link_to_result," = load i32, i32* %"+to_string(sym_link_to_variable)+", align 4"});
    }else if(variable_type=="float"){
        add_line_to_current_block({"%",sym_link_to_result," = load double, double* %"+to_string(sym_link_to_variable)+", align 8"});
    }else if(variable_type=="string"){
        //   %16 = getelementptr inbounds [100 x i8], [100 x i8]* %9, i64 0, i64 0
        add_line_to_current_block({"%",sym_link_to_result," = getelementptr inbounds [100 x i8], [100 x i8]* %"+to_string(sym_link_to_variable)+", i64 0, i64 0"});
    }else if(variable_type=="bool"){
        //%11 = load i8, i8* %2, align 1
        //%12 = trunc i8 %11 to i1
        //%13 = zext i1 %12 to i8
        add_line_to_current_block({"%",sym_link_to_result," = load i8, i8* %"+to_string(sym_link_to_variable)+", align 1"});
        sym_link_count++;
        sym_link_to_result = sym_link_count;
        add_line_to_current_block({"%",sym_link_to_result," = trunc i8 %",(sym_link_to_result-1)," to i1"});
        sym_link_count++;
        sym_link_to_result = sym_link_count;
        add_line_to_current_block({"%",sym_link_to_result," = zext i1 %",(sym_link_to_result-1)," to i8"});
    }
    sym_link_count++;
    return sym_link_to_result;
}

int llvm_generator::int_to_double(int sym_link_to_variable){
    int sym_link_to_result = sym_link_count;
    add_line_to_current_block({"%",sym_link_to_result," = sitofp i32 %",sym_link_to_variable," to double"});    
    sym_link_count++;
    return sym_link_to_result;
}

int llvm_generator::double_to_int(int sym_link_to_variable){
    int sym_link_to_result = sym_link_count;
    add_line_to_current_block({"%",sym_link_to_result," = fptosi double %",sym_link_to_variable," to i32"});    
    sym_link_count++;
    return sym_link_to_result;
}

int llvm_generator::link_to_link_operation(int sym_link1, int sym_link2, string op, string type){
    int sym_link_to_result = sym_link_count;
    if(op == "+"){
        (type=="int")?
            add_line_to_current_block({
                "%", sym_link_to_result, " = ",
                "add nsw i32 %", sym_link1, ", %", sym_link2
                }):
            add_line_to_current_block({
                "%", sym_link_to_result, " = ",
                "fadd double %", sym_link1, ", %", sym_link2
            });
    }else if(op == "-"){
        (type=="int")?
            add_line_to_current_block({
                "%", sym_link_to_result, " = ",
                "sub nsw i32 %", sym_link1, ", %", sym_link2
                }):
            add_line_to_current_block({
                "%", sym_link_to_result, " = ",
                "fsub double %", sym_link1, ", %", sym_link2
            });        
    }else if(op == "*"){
        (type=="int")?
            add_line_to_current_block({
                "%", sym_link_to_result, " = ",
                "mul nsw i32 %", sym_link1, ", %", sym_link2
                }):
            add_line_to_current_block({
                "%", sym_link_to_result, " = ",
                "fmul double %", sym_link1, ", %", sym_link2
            });        
    }else if(op == "/"){
        (type=="int")?
            add_line_to_current_block({
                "%", sym_link_to_result, " = ",
                "sdiv i32 %", sym_link1, ", %", sym_link2
                }):
            add_line_to_current_block({
                "%", sym_link_to_result, " = ",
                "fdiv double %", sym_link1, ", %", sym_link2
            });
    }
    sym_link_count++;
    return sym_link_to_result;
}
int llvm_generator::link_to_constant_operation(int sym_link,string constant, string op, string type){
    int sym_link_to_result = sym_link_count;

    if(op == "+"){
        (type=="int")?
            add_line_to_current_block({
                "%", sym_link_to_result, " = ",
                "add nsw i32 %", sym_link, ", ", constant
                }):
            add_line_to_current_block({
                "%", sym_link_to_result, " = ",
                "fadd double %", sym_link, ", ", constant
            });
    }else if(op == "-"){
        (type=="int")?
            add_line_to_current_block({
                "%", sym_link_to_result, " = ",
                "sub nsw i32 %", sym_link, ", ", constant
                }):
            add_line_to_current_block({
                "%", sym_link_to_result, " = ",
                "fsub double %", sym_link, ", ", constant
            });        
    }else if(op == "*"){
        (type=="int")?
            add_line_to_current_block({
                "%", sym_link_to_result, " = ",
                "mul nsw i32 %", sym_link, ", ", constant
                }):
            add_line_to_current_block({
                "%", sym_link_to_result, " = ",
                "fmul double %", sym_link, ", ", constant
            });        
    }else if(op == "/"){
        (type=="int")?
            add_line_to_current_block({
                "%", sym_link_to_result, " = ",
                "sdiv i32 %", sym_link, ", ", constant
                }):
            add_line_to_current_block({
                "%", sym_link_to_result, " = ",
                "fdiv double %", sym_link, ", ", constant
            });
    }
    sym_link_count++;
    return sym_link_to_result;
}
int llvm_generator::constant_to_link_operation(string constant, int sym_link, string op, string type){
    int sym_link_to_result = sym_link_count;

    if(op == "+"){
        (type=="int")?
            add_line_to_current_block({
                "%", sym_link_to_result, " = ",
                "add nsw i32 ", constant, ", %", sym_link
                }):
            add_line_to_current_block({
                "%", sym_link_to_result, " = ",
                "fadd double ", constant, ", %", sym_link
            });
    }else if(op == "-"){
        (type=="int")?
            add_line_to_current_block({
                "%", sym_link_to_result, " = ",
                "sub nsw i32 ", constant, ", %", sym_link
                }):
            add_line_to_current_block({
                "%", sym_link_to_result, " = ",
                "fsub double ", constant, ", %", sym_link
            });        
    }else if(op == "*"){
        (type=="int")?
            add_line_to_current_block({
                "%", sym_link_to_result, " = ",
                "mul nsw i32 ", constant, ", %", sym_link
                }):
            add_line_to_current_block({
                "%", sym_link_to_result, " = ",
                "fmul double ", constant, ", %", sym_link
            });        
    }else if(op == "/"){
        (type=="int")?
            add_line_to_current_block({
                "%", sym_link_to_result, " = ",
                "sdiv i32 ", constant, ", %", sym_link
                }):
            add_line_to_current_block({
                "%", sym_link_to_result, " = ",
                "fdiv double ", constant, ", %", sym_link
            });
    }
    sym_link_count++;
    return sym_link_to_result;
}
int llvm_generator::constant_to_constant_operation(string constant1, string constant2, string op, string type){
    int sym_link_to_result = sym_link_count;

    if(op == "+"){
        (type=="int")?
            add_line_to_current_block({
                "%", sym_link_to_result, " = ",
                "add nsw i32 ", constant1, ", ", constant2
                }):
            add_line_to_current_block({
                "%", sym_link_to_result, " = ",
                "fadd double ", constant1, ", ", constant2
            });
    }else if(op == "-"){
        (type=="int")?
            add_line_to_current_block({
                "%", sym_link_to_result, " = ",
                "sub nsw i32 ", constant1, ", ", constant2
                }):
            add_line_to_current_block({
                "%", sym_link_to_result, " = ",
                "fsub double ", constant1, ", ", constant2
            });        
    }else if(op == "*"){
        (type=="int")?
            add_line_to_current_block({
                "%", sym_link_to_result, " = ",
                "mul nsw i32 ", constant1, ", ", constant2
                }):
            add_line_to_current_block({
                "%", sym_link_to_result, " = ",
                "fmul double ", constant1, ", ", constant2
            });        
    }else if(op == "/"){
        (type=="int")?
            add_line_to_current_block({
                "%", sym_link_to_result, " = ",
                "sdiv i32 ", constant1, ", ", constant2
                }):
            add_line_to_current_block({
                "%", sym_link_to_result, " = ",
                "fdiv double ", constant1, ", ", constant2
            });
    }
    sym_link_count++;
    return sym_link_to_result;
}

void llvm_generator::generate_llvm_IR_file(string file_name){
    initialize_file(file_name);
    llvm_IR_file<<"target triple = \"x86_64-pc-linux-gnu\""<<"\n\n";
    print_format_specifiers_set();
    print_global_declarations_queue();
    llvm_IR_file<<"define dso_local noundef i32 @main() #0 {"<<"\n";
    print_block_queue();
    llvm_IR_file<<"}"<<"\n";
    print_function_declarations_set();    
    llvm_IR_file.close();
}

void llvm_generator::initialize_file(string file_name){
    // remove(file_name.c_str());
    llvm_IR_file.open(file_name);
}

void llvm_generator::print_block_queue(){
    block_queue.push(current_block);
    while(!block_queue.empty()){
        block_queue.front()->print_block(sym_link_offset, static_declarations_queue, llvm_IR_file);
        delete block_queue.front();
        block_queue.pop();
    }
}

void llvm_generator::print_format_specifiers_set(){
    for (const auto& element : format_specifiers_set) {
        llvm_IR_file << element << "\n";
    }    
}

void llvm_generator::print_global_declarations_queue(){
    while(!global_declarations_queue.empty()){
        llvm_block temp_block(0);
        temp_block.print_line(global_declarations_queue.front(), llvm_IR_file);
        global_declarations_queue.pop();
    }
}

void llvm_generator::print_function_declarations_set(){
    for (const auto& element : function_declarations_set) {
        llvm_IR_file << element << "\n";
    }
}


llvm_block::llvm_block(int sym_link_param){
    sym_link = sym_link_param;
}
llvm_block::~llvm_block(){}

void llvm_block::set_following_block_sym_link(int sym_link){
    following_block_sym_link = sym_link;
}

int llvm_block::get_block_sym_link(){
    return sym_link;
}

void llvm_block::set_block_to_jump_to_sym_link(int sym_link){
    block_to_jump_to_sym_link = sym_link;
}

void llvm_block::set_block_type(string block_type_param){
    block_type = block_type_param;
}

void llvm_block::add_line_to_queue(llvm_line line){
    line_queue.push(line);
}

void llvm_block::set_condition(int condition_sym_link_param){
    llvm_line line = {"%",condition_sym_link_param," = condition"};
    condition_sym_link = condition_sym_link_param;
    add_line_to_queue(line);    
}

void llvm_block::define_last_line(){
    llvm_line line;
    if(block_type=="ends_in_condition"){
        line = {
            "br i1 %",
            condition_sym_link,
            ", label %",
            following_block_sym_link,
            ", label %",
            block_to_jump_to_sym_link
            };
    }else if(block_type=="ends_in_jump"){
        line = {
            "br label %",
            following_block_sym_link
            };
        }
    else/*ends in return 0*/{
        line = {"ret i32 0"};
    }
    add_line_to_queue(line);
}

void llvm_block::print_block(int sym_link_offset, queue < llvm_line > static_declarations_queue, ofstream& llvm_IR_file){
    define_last_line();
    if(sym_link==0){
        llvm_IR_file<<sym_link<<":"<<"\n";
        while(!static_declarations_queue.empty()){
            print_line(static_declarations_queue.front(), llvm_IR_file);
            static_declarations_queue.pop();
        }
    }else{
        llvm_IR_file<<sym_link+sym_link_offset<<":"<<"\n";
    }
    
    while(!line_queue.empty()){      
        print_line(line_queue.front(), sym_link_offset, llvm_IR_file);
        line_queue.pop();
    }
}

void llvm_block::print_line(llvm_line line, int sym_link_offset, ofstream& llvm_IR_file){
    string line_to_print = "";
    for (const auto& elem : line) {
        if (holds_alternative<int>(elem)) {
            int temp = get<int>(elem) + sym_link_offset;
            line_to_print += to_string(temp);
        } else if (holds_alternative<string>(elem)) {
            line_to_print += get<string>(elem);
        }
    }
    llvm_IR_file<<"\t"<<line_to_print<<"\n";
}

void llvm_block::print_line(llvm_line line, ofstream& llvm_IR_file){
    string line_to_print = "";
    for (const auto& elem : line) {
        if (holds_alternative<int>(elem)) {
            int temp = get<int>(elem);
            line_to_print += to_string(temp);
        } else if (holds_alternative<string>(elem)) {
            line_to_print += get<string>(elem);
        }
    }
    llvm_IR_file<<"\t"<<line_to_print<<"\n";
}