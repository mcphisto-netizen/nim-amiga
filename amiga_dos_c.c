#define ALIGN2 __attribute__((aligned(2)))
#include <exec/types.h>
#include <exec/execbase.h>
#include <dos/dos.h>
#include <proto/dos.h>

extern struct DosLibrary* DOSBase;

BPTR nim_open(char* name, LONG mode) {
    if (!DOSBase) return 0;
    return Open((CONST_STRPTR)name, mode);
}

LONG nim_read(BPTR fh, void* buf, LONG len) {
    if (!DOSBase || !fh) return -1;
    return Read(fh, buf, len);
}

LONG nim_write(BPTR fh, const void* buf, LONG len) {
    if (!DOSBase || !fh) return -1;
    return Write(fh, (APTR)buf, len);
}

LONG nim_close(BPTR fh) {
    if (!DOSBase || !fh) return 0;
    return Close(fh);
}

BPTR nim_output(void) {
    if (!DOSBase) return 0;
    return Output();
}