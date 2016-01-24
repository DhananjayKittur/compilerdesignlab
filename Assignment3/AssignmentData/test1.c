/*
  Test 1, uninitialized variables.
*/
#include <stdio.h>


int main()
{
    int k;
    float f; 
    int i;
    int j;
    int m;

    m = 0;
    if( k<f ) {
    	i=0;
    	j=0;
    } else {
    	i=0;
    }
	printf("%d %f %d %d %d\n", k, f, i, j, m);
    
    return 0;
}
