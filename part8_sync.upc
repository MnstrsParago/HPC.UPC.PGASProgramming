/* Part 8: Synchronization
   Every thread writes its own result, then thread 0 prints all results.
   upc_barrier makes thread 0 wait until all threads have written. */
#include <stdio.h>
#include <upc.h>

shared int result[THREADS];

int main()
{
    result[MYTHREAD] = MYTHREAD * 10;

    upc_barrier;   /* wait until every thread has written its result */

    if (MYTHREAD == 0)
    {
        for (int i = 0; i < THREADS; ++i)
        {
            printf("result[%d] = %d\n",
                   i, result[i]);
        }
    }

    return 0;
}
