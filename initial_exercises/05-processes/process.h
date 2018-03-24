#ifndef PROCESS_H
#define PROCESS_H



#define MAXIMUM_THREADS_PER_PROCESS 16



struct process
{
    thread threads[MAXIMUM_THREADS_PER_PROCESS];
};



#endif /* PROCESS_H */
