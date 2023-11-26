#include <iostream>
#include <bitset>
#include <iomanip>

int main() {
    // Input string
    const char* inputString = "3.14";

    // Convert string to double
    double doubleValue = std::stod(inputString);

    // Extract binary representation
    std::bitset<64> binaryRepresentation(*reinterpret_cast<uint64_t*>(&doubleValue));

    // Convert binary to hex representation
    std::stringstream ss;
    ss << "0x" << std::hex << std::uppercase << std::setfill('0') << std::setw(16) << binaryRepresentation.to_ullong();

    // Print the result
    std::cout << "Original String: " << inputString << std::endl;
    std::cout << "Double Value: " << doubleValue << std::endl;
    std::cout << "Hex Representation: " << ss.str() << std::endl;

    return 0;
}