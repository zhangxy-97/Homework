#include<stdio.h>
int* foo()
{
    int a;
    int b;
    int c = 1;
    int* ptr;
    ptr = &a;
    if (c > 0){
        a = 1;
        b = 1;
    }else{
        a = 2;
        b = 2;
    }
    a = a + 2;
    b = b + 2;
    return ptr;
}
