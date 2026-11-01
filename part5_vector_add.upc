/* Part 5: Parallel Vector Addition
   C[i] = A[i] + B[i], where A[i] = i and B[i] = 2*i, so C[i] should be 3*i.
   upc_forall gives iteration i to the thread that has affinity to the element. */
#include <stdio.h>
#include <upc.h>

#define N 1000

shared int A[N];
shared int B[N];
shared int C[N];
shared int count[THREADS];   /* how many C elements each thread calculated */

int main()
{
    int i;

    upc_forall (i = 0; i < N; i++; &A[i])
    {
        A[i] = i;
        B[i] = 2 * i;
    }

    upc_barrier;

    upc_forall (i = 0; i < N; i++; &C[i])
    {
        C[i] = A[i] + B[i];
        count[MYTHREAD]++;
    }

    upc_barrier;

    if (MYTHREAD == 0)
    {
        printf("C[0]   = %d\n", C[0]);
        printf("C[10]  = %d\n", C[10]);
        printf("C[999] = %d\n", C[999]);

        /* check every element against 3*i */
        int errors = 0;
        for (i = 0; i < N; i++)
            if (C[i] != 3 * i)
                errors++;
        printf("Elements where C[i] is not 3*i: %d\n", errors);

        for (i = 0; i < THREADS; i++)
            printf("Thread %d calculated %d elements\n", i, count[i]);
    }

    return 0;
}
