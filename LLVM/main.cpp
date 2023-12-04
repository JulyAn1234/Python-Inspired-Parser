#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define MAX_BUFFER_SIZE 100

int main() {
    // Get input for an integer
    int intValue;
    printf("Enter an integer: ");
    if (scanf("%d", &intValue) == 1) {
        printf("You entered an integer: %d\n", intValue);
    } else {
        printf("Invalid input for integer.\n");
        // Clear the input buffer in case of invalid input
        while (getchar() != '\n');
    }

    // Get input for a double
    double doubleValue;
    printf("Enter a double: ");
    if (scanf("%lf", &doubleValue) == 1) {
        printf("You entered a double: %lf\n", doubleValue);
    } else {
        printf("Invalid input for double.\n");
        // Clear the input buffer in case of invalid input
        while (getchar() != '\n');
    }

    // Get input for a string
    char stringBuffer[MAX_BUFFER_SIZE];
    printf("Enter a string: ");
    if (fgets(stringBuffer, sizeof(stringBuffer), stdin) != NULL) {
        // Remove the newline character at the end
        if (stringBuffer[0] != '\0' && stringBuffer[strlen(stringBuffer) - 1] == '\n') {
            stringBuffer[strlen(stringBuffer) - 1] = '\0';
        }
        printf("You entered a string: %s\n", stringBuffer);
    }

    return 0;
}
