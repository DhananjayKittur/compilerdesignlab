/*
  Test 4, uninitialized variables in a loop.
*/
  //Questions to ask? Do we have to check the loop invariant too ??
#include <stdio.h>

int main()
{
    int k, i;
    float f;
    double d;
    
    for (i = 0; i < 10; i++)
    {
        k = k + 10;
        f = f + 0.1;
        d = d + 0.2;
    }
    
    printf("%d %d %f %f\n", k, i, f, d);
    
    return 0;
} 
