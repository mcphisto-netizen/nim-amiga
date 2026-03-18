# Wrappers Nim -> dos.library (IO nativo)
{.deadCodeElim: on.}
{.push inline.}

type
  BPTR* = uint32
  LONG* = int32
  STRPTR* = cstring

proc open*(name: STRPTR; mode: LONG): BPTR {.importc: "nim_open".}
proc read*(fh: BPTR; buf: pointer; len: LONG): LONG {.importc: "nim_read".}
proc write*(fh: BPTR; buf: pointer; len: LONG): LONG {.importc: "nim_write".}
proc close*(fh: BPTR): LONG {.importc: "nim_close".}
proc output*(): BPTR {.importc: "nim_output".}
proc lock*(name: STRPTR; access: LONG): BPTR {.importc: "nim_lock".}
proc unlock*(lock: BPTR) {.importc: "nim_unlock".}
proc examine*(lock: BPTR; fib: pointer): LONG {.importc: "nim_examine".}
proc nextDosEntry*(lock: BPTR; fib: pointer; mode: LONG): LONG
  {.importc: "nim_nextdosentry".}

const
  MODE_OLDFILE* = 1005'i32
  MODE_NEWFILE* = 1006'i32
  MODE_READWRITE* = 1004'i32

{.pop.}
