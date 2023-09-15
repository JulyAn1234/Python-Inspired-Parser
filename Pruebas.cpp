#include <iostream>
#include <unordered_map>

// Tabla de simbolos
struct function_scope {
    std::unordered_map<std::string, std::string> symbols;
    struct function_scope *next; // Pointer to the same type
};

// Typedef for the struct
typedef struct function_scope function_scope;
function_scope *symbol_table = (function_scope *)0;




int main() {
    // Create instances of MyStruct
    function_scope sym_table;
    function_scope if_scope_syms;
    // Link the two structs together
    sym_table.next = &if_scope_syms;
    // Modify the data in struct1
    sym_table.symbols["a"] = "Julian";

    // Access data in struct2 through the pointer
    // if (sym_table.next != nullptr) {
    //     int value = sym_table.next->symbols["a"];
    //     std::cout << "Value in struct2: " << value << std::endl;
    // }

    return 0;
}
