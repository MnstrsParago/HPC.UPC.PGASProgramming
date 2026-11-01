/* Part 6: Observing Data Affinity
   Thread 0 prints which thread has affinity to each element of A.
   A uses the default block size. */
#include <stdio.h>
#include <upc.h>

shared int A[16];

int main()
{
    if (MYTHREAD == 0)
    {
        for (int i = 0; i < 16; ++i)
        {
            printf("A[%d] has affinity to thread %d\n",
                   i,
                   (int) upc_threadof(&A[i]));
        }
    }

    return 0;
}
