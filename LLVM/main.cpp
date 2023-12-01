#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(){
    bool a = false;
    int b = 0;
    double c = 0.0;
    char d[100] = "Hereisastringofexactly100characterswithoutanyspacesinitH";
    bool e = a;
    int f = c;
    double aa;
    double bb;
    int operation2 = b*b;
    int operation3 = b/b;
    int operation = b + f + 1 + aa + (b*b) + (3/4) + (b-b) + (aa*bb) + (aa/bb) + (aa-bb);
    double g = c;
    char h[100];
    strcpy(h,d);
    printf("%s", h);
    if(e){
        printf("e is true\n");
    }
    else{
        printf("e is false\n");
    }
}