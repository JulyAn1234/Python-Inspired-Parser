#include <iostream>
#include <string>
#include <fstream>
#include "block_stack.h"

using namespace std;
int main(){
    block_stack block_stack_property;
    string result = "";
    result = block_stack_property.add_line("hola");
    cout<<result<<endl;
    result = block_stack_property.add_line("hola2");
    cout<<result<<endl;
    result = block_stack_property.add_line("hola3");
    cout<<result<<endl;
    result = block_stack_property.new_if_block("x>y");
    cout<<result<<endl;
    result = block_stack_property.add_line("if_action_1");
    cout<<result<<endl;
    result = block_stack_property.add_line("if_action_2");
    cout<<result<<endl;
    // result = block_stack_property.new_if_block("x>y");
    // cout<<result<<endl;
    // result = block_stack_property.new_if_block("x>y");
    // cout<<result<<endl;
    // result = block_stack_property.delete_if_block();
    // cout<<result<<endl;
    // result = block_stack_property.delete_if_block();
    // cout<<result<<endl;    
    result = block_stack_property.delete_if_block();
    cout<<result<<endl;
    result = block_stack_property.add_line("After_action_1");
    cout<<result<<endl;
    result = block_stack_property.add_line("After_action_2");
    cout<<result<<endl;
    // int count = 0;
    // std::string name = "L"+ to_string(count) + ":";
    // count++;
    // int age = 2;
    // //concatenation in this way must have at least one string...
    // name = name + "if cond goto L" + to_string(count)+ "\n";
    // count++; 
    // name = name + "goto L" + to_string(count)+ "\n";
    // std::string message = "My name is " + name + " and I am " + std::to_string(age) + " years old.";   
    // cout<<name<<endl;
    // std::ofstream file("yourfile.txt", std::ios::app); // Opens the file in append mode 
    // if (file.is_open()) {
    //     // File opened successfully
    //     file << name << std::endl;
    // } else {
    //     std::cerr << "Error opening the file." << std::endl;
    //     return 1; // Return an error code
    // }
}