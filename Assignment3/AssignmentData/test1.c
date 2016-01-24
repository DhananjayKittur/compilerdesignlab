/*
  Test 1, uninitialized variables.
*/
#include <stdio.h>


void fun_a(int *x, int *y){
    *x = 0;
}

int main()
{
    int k;
    int t; 
    //float f;  

    fun_a(&k, &t);
    //printf("%d %f\n", k, f);
    
    return 0;
}
