{.push inline.}

type
  APTR* = pointer

  RastPort* = pointer
  BitMap* = pointer
  ViewPort* = pointer

var GfxBase*: APTR

proc gfxOpen*(): cint {.importc: "gfx_open".}
proc gfxClose*() {.importc: "gfx_close".}

proc SetAPen*(rp: RastPort; pen: uint16) {.importc: "gfx_SetAPen".}
proc Move*(rp: RastPort; x, y: int16) {.importc: "gfx_Move".}
proc Draw*(rp: RastPort; x, y: int16) {.importc: "gfx_Draw".}
proc DrawEllipse*(rp: RastPort; x, y, rx, ry: int16) {.importc: "gfx_DrawEllipse".}
proc RectFill*(rp: RastPort; x1, y1, x2, y2: int16) {.importc: "gfx_RectFill".}
proc BltClear*(mem: pointer; bytes: uint32; flags: uint32) {.importc: "gfx_BltClear".}

proc LoadRGB4*(vp: ViewPort; colors: ptr uint16; count: int16) {.importc: "gfx_LoadRGB4".}

const
  JAM1* = 0
  JAM2* = 1

{.pop.}
