#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define MAX_BUFFER_SIZE 100

int main() {
    // Get input for an integer
    int intValue;
    printf("Enter an integer: ");
    while (scanf("%d", &intValue) == 0){
        printf("Invalid input for integer, try again: ");
        while (getchar() != '\n');
    }
    while (getchar() != '\n');

    // Get input for a double
    double doubleValue;
    printf("Enter a double: ");
    while (scanf("%lf", &doubleValue) == 0) {
        printf("Invalid input for double, try again: ");
        while (getchar() != '\n');
    } 
    while (getchar() != '\n');
    
    // Get input for a string
    char stringBuffer[MAX_BUFFER_SIZE] = "a";
    // Clear stringBuffer variable
    memset(stringBuffer, 0, 100);
    printf("Enter a string: ");
    if (fgets(stringBuffer, 100, stdin) != NULL) {
        // Remove the newline character at the end
        if (stringBuffer[0] != '\0' && stringBuffer[strlen(stringBuffer) - 1] == '\n') {
            stringBuffer[strlen(stringBuffer) - 1] = '\0';
        }
        printf("You entered a string: %s\n", stringBuffer);
    }

    printf("Enter a double: ");
    while (scanf("%lf", &doubleValue) == 0) {
        printf("Invalid input for double, try again: ");
        while (getchar() != '\n');
    } 
    while (getchar() != '\n');

    return 0;
}
