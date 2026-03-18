#define ALIGN2 __attribute__((aligned(2)))
#include <exec/types.h>
#include <exec/execbase.h>
#include <dos/dos.h>

/* Exported symbols for crt0 */
struct ExecBase* SysBase = 0;
struct DosLibrary* DOSBase = 0;