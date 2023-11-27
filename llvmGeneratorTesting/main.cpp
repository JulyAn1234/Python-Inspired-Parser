#include <iostream>
#include "llvm_generator.h"

using namespace std;

int main(){
    llvm_generator IR;
    int string_sym_link = IR.add_static_declaration("string");
    int bool_sym_link = IR.add_static_declaration("bool");
    IR.store_value_in_variable(bool_sym_link, "bool", "b", "1");
    IR.store_value_in_variable(string_sym_link, "string", "a","Hereisastringofexactly100characterswithoutanyspacesinitHereisastringofexactly100characterswithoutany");
    IR.print_llvm_code();
}