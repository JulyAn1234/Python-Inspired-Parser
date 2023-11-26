#include <iostream>
#include <vector>
#include <string>
#include <variant>

using namespace std;

int main() {

    std::vector<variant<int, std::string>> lista = {"%", 4, "=", "load i32 %", 3};

    std::string line;

    for (const auto& elem : lista) {
        if (std::holds_alternative<int>(elem)) {
            int temp = std::get<int>(elem) + 2; // Reemplaza 'constante' con el valor que desees
            line += std::to_string(temp);
        } else if (std::holds_alternative<std::string>(elem)) {
            line += std::get<std::string>(elem);
        }
    }

    std::cout << line << std::endl;

    return 0;
}
