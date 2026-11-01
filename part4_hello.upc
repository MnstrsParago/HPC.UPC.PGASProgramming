/* Part 4: First UPC Program
   Every UPC thread prints its own number and the total number of threads. */
#include <stdio.h>
#include <upc.h>

int main()
{
    printf("Hello from thread %d of %d\n", MYTHREAD, THREADS);

    return 0;
}
