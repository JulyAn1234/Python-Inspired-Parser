#include "llvm_generator.h"

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

void llvm_generator::store_value_in_variable(int sym_link_to_variable, string variable_type, int sym_link_to_value){

}

void llvm_generator::print_llvm_code(){
    print_global_declarations_queue();
    cout<<"define dso_local noundef i32 @main() #0 {"<<"\n";
    print_block_queue();
    cout<<"}"<<"\n";
    print_function_declarations_set();    
}

void llvm_generator::print_block_queue(){
    block_queue.push(current_block);
    while(!block_queue.empty()){
        block_queue.front()->print_block(sym_link_offset, static_declarations_queue);
        delete block_queue.front();
        block_queue.pop();
    }
}

void llvm_generator::print_global_declarations_queue(){
    while(!global_declarations_queue.empty()){
        llvm_block temp_block(0);
        temp_block.print_line(global_declarations_queue.front());
        global_declarations_queue.pop();
    }
}

void llvm_generator::print_function_declarations_set(){
    for (const auto& element : function_declarations_set) {
        std::cout << element << "\n";
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

void llvm_block::print_block(int sym_link_offset, queue < llvm_line > static_declarations_queue){
    define_last_line();
    if(sym_link==0){
        cout<<sym_link<<":"<<"\n";
        while(!static_declarations_queue.empty()){
            print_line(static_declarations_queue.front());
            static_declarations_queue.pop();
        }
    }else{
        cout<<sym_link+sym_link_offset<<":"<<"\n";
    }
    
    while(!line_queue.empty()){      
        print_line(line_queue.front(), sym_link_offset);
        line_queue.pop();
    }
}

void llvm_block::print_line(llvm_line line, int sym_link_offset){
    string line_to_print = "";
    for (const auto& elem : line) {
        if (holds_alternative<int>(elem)) {
            int temp = get<int>(elem) + sym_link_offset;
            line_to_print += to_string(temp);
        } else if (holds_alternative<string>(elem)) {
            line_to_print += get<string>(elem);
        }
    }
    cout<<"\t"<<line_to_print<<"\n";
}

void llvm_block::print_line(llvm_line line){
    string line_to_print = "";
    for (const auto& elem : line) {
        if (holds_alternative<int>(elem)) {
            int temp = get<int>(elem);
            line_to_print += to_string(temp);
        } else if (holds_alternative<string>(elem)) {
            line_to_print += get<string>(elem);
        }
    }
    cout<<"\t"<<line_to_print<<"\n";
}