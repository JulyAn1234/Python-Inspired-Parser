#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(){
    bool a = false;
    int b = 0;
    double c = 0.0;
    char d[100] = "Hereisastringofexactly100characterswithoutanyspacesinitHereisastringofexactly100characterswithoutan";
    bool e = a;
    int f = b;
    double g = c;
    char h[100];
    strcpy(h,d);
}