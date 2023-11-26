#include "llvm_generator.h"

using namespace std;

llvm_generator::llvm_generator(){
    sym_link_count = 0;
    llvm_block first_block(0);
    current_block = &first_block;
}

void llvm_generator::add_line_to_current_block(string line){
    current_block->add_line_to_queue(line);
}

void llvm_generator::create_new_block(){
    llvm_block new_block(sym_link_count);
    current_block = &new_block;
    sym_link_count++;    
}

void llvm_generator::if_starts(){
    //Set condition
    current_block->set_condition(sym_link_count);
    sym_link_count++;

    //set block final settings
    current_block->set_block_type("ends_in_conditional");
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
    if_ends();
}

void llvm_generator::print_block_queue(){
    while(!block_queue.empty()){
        block_queue.front()->print_block();
        delete block_queue.front();
        block_queue.pop();
    }
}


llvm_block::llvm_block(int sym_link_param){
    sym_link = sym_link_param;
}

void llvm_block::set_following_block_sym_link(int sym_link){
    following_block_sym_link = sym_link;
}

void llvm_block::set_block_to_jump_to_sym_link(int sym_link){
    block_to_jump_to_sym_link = sym_link;
}

void llvm_block::set_block_type(string block_type_param){
    block_type = block_type_param;
}

void llvm_block::add_line_to_queue(string line){
    line_queue.push(line);
}

void llvm_block::set_condition(int condition_sym_link){
    string line = "%"+to_string(condition_sym_link)+" = condition";
    add_line_to_queue(line);    
}

void llvm_block::define_last_line(){
    string line;
    if(block_type=="ends_in_condition"){
        line =
            "br i1 %"+to_string(condition_sym_link)+
            ", label %"+to_string(following_block_sym_link)+
            ", label %"+to_string(block_to_jump_to_sym_link);
    }else if(block_type=="ends_in_jump"){
        line =
            "br label %"+to_string(following_block_sym_link);
    }
    else/*ends in return 0*/{
        line =
            "ret i32 0";
    }
    add_line_to_queue(line);
}

void llvm_block::print_block(){
    define_last_line();
    queue <string> temp_line_queue = line_queue;
    while(!temp_line_queue.empty()){      
        print_line(temp_line_queue.front());
        temp_line_queue.pop();
    }
}

void llvm_block::print_line(string line){
    cout<<line<<"\n";
}