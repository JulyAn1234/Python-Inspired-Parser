#include <iostream>
#include "llvm_generator.h"

using namespace std;

int main(){
    llvm_generator IR;
    IR.if_starts();
    IR.while_starts();    
    IR.while_ends();
    IR.if_ends();
    IR.print_block_queue();
}