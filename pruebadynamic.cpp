#include <iostream>
#include <fstream> // Include the file stream library

int main() {
    // Open a file named "test_program.txt" for writing
    std::ofstream outputFile("test_program.txt");

    if (outputFile.is_open()) {
        for (int i = 1; i <= 100000; i++) {
            // Write the output to the file instead of std::cout
            outputFile << "int var" << i << ";\n";
        }

        // Close the file when you're done
        outputFile.close();
        std::cout << "Output written to 'test_program.txt'" << std::endl;
    } else {
        std::cerr << "Unable to open the file for writing." << std::endl;
    }

    return 0;
}
