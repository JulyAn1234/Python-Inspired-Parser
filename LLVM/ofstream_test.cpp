#include <iostream>
#include <fstream>

// Function to open a file using the provided ofstream reference
void openFile(std::ofstream& outFile) {
    // Replace "example.txt" with the desired file name
    outFile.open("example.txt");

}

// Function to append something to the end of the file
void appendToFile(std::ofstream& outFile, const std::string& content) {
    // Move the file pointer to the end of the file for appending
    // outFile.seekp(0, std::ios::end);

    // Append content to the file
    outFile << content << std::endl;
}

int main() {
    // Initialize ofstream with the empty constructor
    std::ofstream outputFile;

    // Call the function to open the file
    openFile(outputFile);

    // Call the function to append something to the end of the file
    appendToFile(outputFile, "This is appended content.");
    appendToFile(outputFile, "This is appended content.");

    // The file will be closed automatically when 'outputFile' goes out of scope

    return 0;
}
