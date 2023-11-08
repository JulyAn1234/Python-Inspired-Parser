#ifndef BLOCK_STACK_H
#define BLOCK_STACK_H

#include <iostream>
#include <stack>

using namespace std;


class block_stack
{
    private:
        //Stack for saving different blocks of quadruples that cannot be inserted directly
        //The firts block in the stack is supposed to content all the quadruples
        //thus, it is the main block, and it is the one that will be used to generate the intermediate code
        stack <string*> block_stack_property;
        int count = 0;
    public:
        block_stack();
        ~block_stack();
        //Same Idea as top from the stack data structure
        string* current_block ();
        
        //Same Idea as push from the stack data structure, specific for if blocks
        string new_if_block();
        //Same Idea as pop from the stack data structure, specific for if blocks
        string delete_if_block();

        //Same Idea as push from the stack data structure, specific for while blocks
        string new_loop_block();
        //Same Idea as pop from the stack data structure, specific for while blocks
        string delete_loop_block();

        //adding a new line to the current block
        string add_line(string line);
        //Printing the current block...
        string print_block();
        //write file with the current block
        string write_file(string file_name);
};

#endif 