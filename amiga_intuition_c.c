#include <exec/types.h>
#include <exec/libraries.h>
#include <intuition/intuition.h>
#include <proto/intuition.h>
#include <proto/exec.h>

struct Library *IntuitionBase = 0;

int intu_open() {
    IntuitionBase = OpenLibrary("intuition.library", 0);
    return IntuitionBase != 0;
}

void intu_close() {
    if (IntuitionBase) CloseLibrary(IntuitionBase);
}

struct Window *intu_OpenWindow(WORD w, WORD h) {
    struct NewWindow nw = {
        50, 50, w, h,
        0, 1,
        IDCMP_CLOSEWINDOW,
        WFLG_CLOSEGADGET | WFLG_ACTIVATE | WFLG_SMART_REFRESH,
        NULL, NULL,
        (UBYTE*)"Nim Window",
        NULL, NULL,
        100, 50, 640, 256,
        NULL
    };
    return OpenWindow(&nw);
}

void intu_CloseWindow(struct Window *win) {
    if (win) CloseWindow(win);
}

struct RastPort *intu_GetRastPort(struct Window *win) {
    return win ? win->RPort : 0;
}

void intu_WaitClose(struct Window *win) {
    struct IntuiMessage *msg;
    while (1) {
        Wait(1 << win->UserPort->mp_SigBit);
        while ((msg = (struct IntuiMessage*)GetMsg(win->UserPort))) {
            if (msg->Class == IDCMP_CLOSEWINDOW) {
                ReplyMsg((struct Message*)msg);
                return;
            }
            ReplyMsg((struct Message*)msg);
        }
    }
}
