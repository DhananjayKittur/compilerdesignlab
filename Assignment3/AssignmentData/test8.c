/*
  Test 8, a more complex control flow.
  Q? : What if a is negative ?? 
  Q? : Do we have to consider the constant propagation like a value is going to be greater than 10 for sure should we consider that as well ?
  Or do we have to consider the value of control graph before execution. like for( i=0; i<10; i++ ) {}
*/

#include <stdio.h>

int main()
{
    int a, b, c, d, e;
    float f;
    double g;
    
    if(a > 100){
        a = 10;
    }
    else {
        a = 20;
        b = 20;
    }

    e = e*100;    
    d = c*2;

    for (int i = 0; i < a; i++)
    {
        if(i<a){
            g += 1.0;
        }
        else {
            g = 500.0;
        }
    }
    
    printf("%d %d %d %d %d %f %f\n", a, b, c, d, e, f, g);
    
    return 0;
} 
