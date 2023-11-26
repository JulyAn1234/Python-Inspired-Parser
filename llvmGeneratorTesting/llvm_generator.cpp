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

void llvm_generator::print_block_queue(){
    block_queue.push(current_block);
    while(!block_queue.empty()){
        block_queue.front()->print_block(sym_link_offset);
        delete block_queue.front();
        block_queue.pop();
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
    // string line = "%"+to_string(condition_sym_link_param)+" = condition";
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
        // line =
        //     "br i1 %"+to_string(condition_sym_link)+
        //     ", label %"+to_string(following_block_sym_link)+
        //     ", label %"+to_string(block_to_jump_to_sym_link);
    }else if(block_type=="ends_in_jump"){
        line = {
            "br label %",
            following_block_sym_link
            };
        // line =
        //     "br label %"+to_string(following_block_sym_link);
    }
    else/*ends in return 0*/{
        line = {"ret i32 0"};
        // line =
        //     "ret i32 0";
    }
    add_line_to_queue(line);
}

void llvm_block::print_block(int sym_link_offset){
    define_last_line();
    if(sym_link==0)
        cout<<sym_link<<":"<<"\n";
    else
        cout<<sym_link+sym_link_offset<<":"<<"\n";
    
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