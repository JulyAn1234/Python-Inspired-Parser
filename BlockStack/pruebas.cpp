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
    result = block_stack_property.new_loop_block("t1=x>y","t1");
    cout<<result<<endl;
    result = block_stack_property.new_loop_block("t1=x>y","t1");
    cout<<result<<endl;
    result = block_stack_property.add_line("if_action_1");
    cout<<result<<endl;
    result = block_stack_property.new_loop_block("t1=x>y","t1");
    cout<<result<<endl;
    result = block_stack_property.add_line("if_action_2");
    cout<<result<<endl;
    result = block_stack_property.delete_loop_block();
    cout<<result<<endl;
    result = block_stack_property.add_line("After_action_1");
    cout<<result<<endl;
    result = block_stack_property.delete_loop_block();
    cout<<result<<endl;
    result = block_stack_property.delete_loop_block();
    cout<<result<<endl;
    result = block_stack_property.add_line("After_action_2");
    cout<<result<<endl;
}