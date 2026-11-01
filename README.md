# HPC.UPC.PGASProgramming

Practiced the PGAS (Partitioned Global Address Space) model with Berkeley UPC (Unified Parallel C) on one laptop, using 4 UPC threads.

## What I Did

* Answered questions on the PGAS model, shared and private data, and affinity
* Calculated the affinity of a blocked shared array, `shared [4] int A[32]`
* Ran a first UPC program where every thread prints its number
* Added two vectors in parallel with `upc_forall`
* Printed the affinity of every element of a shared array with `upc_threadof`
* Used `upc_barrier` so thread 0 reads results only after all threads write them
* Compared OpenMP, MPI and UPC

## Results

### Thread Identification (4 threads)

Every thread printed "Hello from thread N of 4". Print order in one run: 0, 3, 2, 1, so the order is not guaranteed.

### Vector Addition (N = 1000)

    C[0]   = 0
    C[10]  = 30
    C[999] = 2997

All 1000 elements equal 3i. Each thread calculated 250 elements, the ones it has affinity to.

### Data Affinity (shared int A[16])

The default block size is 1, so elements go to threads in a cycle:

| Elements | Thread |
|---|---|
| A[0], A[4], A[8], A[12] | 0 |
| A[1], A[5], A[9], A[13] | 1 |
| A[2], A[6], A[10], A[14] | 2 |
| A[3], A[7], A[11], A[15] | 3 |

### Synchronization

With `upc_barrier`, thread 0 printed 0, 10, 20, 30.

## Files

| File | Description |
|---|---|
| `part4_hello.upc` | Each thread prints MYTHREAD and THREADS |
| `part5_vector_add.upc` | C[i] = A[i] + B[i] with upc_forall, checked against 3i |
| `part6_affinity.upc` | Prints the thread with affinity for each element |
| `part8_sync.upc` | Threads write results, then a barrier, then thread 0 prints them |
| `assignment_upc.pdf` | Assignment |
| `*.docx` | Report with all answers and tables |

## How to Run

    upcc -T 4 -o part5_vector_add.out part5_vector_add.upc
    upcrun -q -n 4 ./part5_vector_add.out

`-T 4` fixes the number of threads at compile time. Without it, shared arrays like A[1000] do not compile, because the compiler does not know how to split them.

## Key Takeaways

* Every thread can read and write all shared data, but data with affinity to another thread is slower to reach
* The block size decides which thread stores which elements
* `upc_forall` with `&C[i]` gives each iteration to the thread that owns C[i], so all accesses are local
* UPC does not synchronize threads by itself, so a barrier is needed before reading data written by other threads

## Tools

* Berkeley UPC 2022.10.0 with the online UPC to C translator
* WSL (Ubuntu) + VS Code
