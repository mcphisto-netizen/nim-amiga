# Wrappers Nim -> dos.library (IO nativo)
{.deadCodeElim: on.}
{.inline: on.}

type
  BPTR* = uint32
  LONG* = int32
  STRPTR* = cstring

proc open*(name: STRPTR; mode: LONG): BPTR {.importc: "nim_open".}
proc read*(fh: BPTR; buf: pointer; len: LONG): LONG {.importc: "nim_read".}
proc write*(fh: BPTR; buf: pointer; len: LONG): LONG {.importc: "nim_write".}
proc close*(fh: BPTR): LONG {.importc: "nim_close".}
proc output*(): BPTR {.importc: "nim_output".}

const
  MODE_OLDFILE* = 1005'i32
  MODE_NEWFILE* = 1006'i32
  MODE_READWRITE* = 1004'i32