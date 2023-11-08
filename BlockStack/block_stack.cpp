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

string block_stack::new_if_block()
{
    string name = "L"+ to_string(count) + ":";
    count++;
    string* ptr = &name;
    block_stack_property.push(ptr);
    return name;
}

string block_stack::write_file(string file_name)
{
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