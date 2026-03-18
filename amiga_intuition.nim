{.push inline.}

type
  APTR* = pointer

  Window* = pointer
  RastPort* = pointer

var IntuitionBase*: APTR

proc intuOpen*(): cint {.importc: "intu_open".}
proc intuClose*() {.importc: "intu_close".}

proc OpenSimpleWindow*(w, h: int16): Window {.importc: "intu_OpenWindow".}
proc CloseWindow*(win: Window) {.importc: "intu_CloseWindow".}

proc GetRastPort*(win: Window): RastPort {.importc: "intu_GetRastPort".}

proc WaitClose*(win: Window) {.importc: "intu_WaitClose".}

{.pop.}
