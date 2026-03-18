#include <exec/types.h>
#include <exec/libraries.h>
#include <graphics/gfx.h>
#include <graphics/rastport.h>
#include <graphics/view.h>
#include <proto/exec.h>
#include <proto/graphics.h>

struct Library *GfxBase = 0;

int gfx_open() {
    GfxBase = OpenLibrary("graphics.library", 0);
    return GfxBase != 0;
}

void gfx_close() {
    if (GfxBase) CloseLibrary(GfxBase);
}

void gfx_SetAPen(struct RastPort *rp, UWORD pen) {
    SetAPen(rp, pen);
}

void gfx_Move(struct RastPort *rp, WORD x, WORD y) {
    Move(rp, x, y);
}

void gfx_Draw(struct RastPort *rp, WORD x, WORD y) {
    Draw(rp, x, y);
}

void gfx_DrawEllipse(struct RastPort *rp, WORD x, WORD y, WORD rx, WORD ry) {
    DrawEllipse(rp, x, y, rx, ry);
}

void gfx_RectFill(struct RastPort *rp, WORD x1, WORD y1, WORD x2, WORD y2) {
    RectFill(rp, x1, y1, x2, y2);
}

void gfx_BltClear(APTR mem, ULONG bytes, ULONG flags) {
    BltClear(mem, bytes, flags);
}

void gfx_LoadRGB4(struct ViewPort *vp, UWORD *colors, WORD count) {
    LoadRGB4(vp, colors, count);
}
