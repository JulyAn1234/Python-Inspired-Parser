#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(){
    int a;
    int b;
    int c;
    int d;
    int e;

    a = 100;
    b = 200;
    c = 300;
    d = 400;
    e = 500;

    char str2 [100] = "hello world";
    bool bool1 = true;
    bool bool2 = bool1;
    double doubl = 1.1;

    e = (a + b * c) /( d - e +(12321.2/123*(123+12*123/12*(1+2))-(3+2*2)))/(2*121/(523+12));
    printf("%d", e);
    printf("%lf", doubl);
    printf("%s", str2);
    printf("%d", bool1);
    printf("\n");

}