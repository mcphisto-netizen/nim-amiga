#define ALIGN2 __attribute__((aligned(2)))
#include <exec/types.h>

typedef unsigned long jmp_buf[20];

unsigned long nim_setjmp(jmp_buf* env) {
    if (!env) return 0;
    
    asm volatile (
        "movem.l d2-d7/a2-a6,(%0)\n\t"
        "move.l %sp,28(%0)\n\t"
        "move.l (%sp),32(%0)\n\t"
        :
        : "a"(env)
        : "memory"
    );
    
    return 0;
}

void nim_longjmp(jmp_buf* env, unsigned long val) {
    if (!env) return;
    
    asm volatile (
        "movem.l (%0),d2-d7/a2-a6\n\t"
        "move.l 28(%0),%sp\n\t"
        "move.l 32(%0),-(%sp)\n\t"
        "move.l %1,d0\n\t"
        "rts\n\t"
        :
        : "a"(env), "d"(val)
        : "memory", "a7"
    );
}