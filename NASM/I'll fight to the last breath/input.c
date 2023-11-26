#include <stdio.h>
#include <string.h>

#define MAX_LENGTH 100
int a=1;

int main() {
    char originalText[MAX_LENGTH];
    char copiedText[MAX_LENGTH];

    // Get input from the user
    printf("Enter a text: ");
    fgets(originalText, sizeof(originalText), stdin);

    // Copy the text to another variable
//    strcpy(copiedText, originalText);
    strcpy(copiedText, originalText);

    // Print the copied text
    printf("Copied Text: %s", originalText);

    return 0;
}
