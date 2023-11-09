#include "block_stack.h"
#include <iostream>
#include <stack>
#include <string>
#include <fstream>
#include <stdexcept>

using namespace std;

block_stack::block_stack()
{
    try
    {
        string init = "L0: ";
        block_stack_property.push(new string(init));
        cout<<*block_stack_property.top()<<" \n";
        count++;
    }
    catch(const std::exception& e)
    {
        cout << e.what() << '\n';
    }

}

block_stack::~block_stack()
{

    while (!block_stack_property.empty()) {
        if(block_stack_property.size() ==1){
            write_file("intermediateCode.txt");            
        }
        delete block_stack_property.top();
        block_stack_property.pop();
    }
}

string* block_stack::current_block()
{
    return block_stack_property.top();
}

string block_stack::add_line(string line)
{
    try{
        cout<<"\nadd_line called"<<endl;
        cout<<"line looks like this...:"<<line<<endl;
        if (!block_stack_property.empty()) {
            string* current_block = block_stack_property.top();
            if (current_block != nullptr) {
                // Edit the content of the string pointed to by the top pointer
                cout << "current_block looks like this...:" << *current_block << endl;
                *current_block = *current_block + line + "\n";
                return "Added Line successfully, now the block looks like this:"+*current_block+"\n";
            } else {
                return "Top pointer is null:\n";
            }
        } else {
            return "Stack is empty:\n";
        }
    }
    catch(const std::exception& e){
        return "a";
        // return "Error: " + string(e.what())+ "\n";
    }
}

string block_stack::new_if_block(string condition_quadruples,string condition){
    try
    {
        add_line(condition_quadruples);
        add_line("if "+condition+" goto L"+to_string(count));
        string label = "L"+ to_string(count) + ":";
        count++;
        block_stack_property.push(new string(label));
        return "Added if block " + label + " successfully\n";
    }
    catch(const std::exception& e)
    {
        return "Error: " + string(e.what())+ "\n";
    }
}

string block_stack::delete_if_block(){
    try
    {
        string* current_block = block_stack_property.top();
        if (current_block != nullptr) {
            // Edit the content of the string pointed to by the top pointer
            string if_content = *current_block;
            if_content = "goto L"+to_string(count)+"\n"+if_content;
            cout << "if_content looks like this:" << if_content << endl;
            delete current_block;
            // cout<<"current_block deleted:"<<*current_block<<endl;
            block_stack_property.pop();
            add_line(if_content);
            add_line("L"+to_string(count)+":");
            count++;
            return "Deleted if block successfully\n";
        } else {
            return "Top pointer is null:\n";
        }
    }
    catch(const std::exception& e)
    {
        return "Error: " + string(e.what())+ "\n";
    }
}

string block_stack::new_loop_block(string condition_quadruples, string condition){
    try
    {
        // sym_link_to_condition is supposed to be the Link the last goto of the loop should have
        //how can I implement it in the delete_loop_block function?
        //maybe I can add a new stack for the sym_link_to_condition
        int sym_link_to_condition = count;
        //The sym_link_to_condition is added to the stack so 
            //it can be used in the delete_loop_block function
        sym_link_to_condition_in_loop.push(sym_link_to_condition);
        add_line("L"+to_string(count)+": "+condition_quadruples);
        count++;
        add_line("if "+condition+" goto L"+to_string(count));
        string label = "L"+ to_string(count) + ":";
        count++;
        block_stack_property.push(new string(label));
        return "Added loop block " + label + " successfully\n";
    }
    catch(const std::exception& e)
    {
        return "Error: " + string(e.what())+ "\n";
    }
}

string block_stack::delete_loop_block(){
    try
    {
        string* current_block = block_stack_property.top();
        if (current_block != nullptr) {
            // Edit the content of the string pointed to by the top pointer
            string loop_content = *current_block;
            // sym_link_to_condition is supposed to be the Link the last goto of the loop should have
            int sym_link_to_condition = get_sym_link_to_condition_in_loop();
            loop_content = "goto L"+to_string(count)+"\n"+loop_content+"\ngoto L"+to_string(sym_link_to_condition);
            cout << "loop_content looks like this:" << loop_content << endl;
            delete current_block;
            // cout<<"current_block deleted:"<<*current_block<<endl;
            block_stack_property.pop();
            add_line(loop_content);
            add_line("L"+to_string(count)+":");
            count++;
            return "Deleted loop block successfully\n";
        } else {
            return "Top pointer is null:\n";
        }
    }
    catch(const std::exception& e)
    {
        return "Error: " + string(e.what())+ "\n";
    }
}

int block_stack::get_sym_link_to_condition_in_loop(){
    int sym_link_to_condition = sym_link_to_condition_in_loop.top();
    sym_link_to_condition_in_loop.pop();
    return sym_link_to_condition;
}

string block_stack::write_file(string file_name){
    try{
        ofstream file(file_name, ios::app);
        if (file.is_open()) {
            // File opened successfully
            file << *block_stack_property.top() << std::endl;
            file.close();
            return "File written successfully";
        } else {
            return "Error opening the file.";
        }
    }
    catch(const std::exception& e){
        return "Error: " + string(e.what())+"\n";
    }
}