{.push inline.}

type
  APTR* = pointer

var AudioBase*: APTR

proc audioOpen*(): cint {.importc: "audio_open".}
proc audioClose*() {.importc: "audio_close".}

proc AllocChannel*(ch: uint16): cint {.importc: "audio_alloc".}
proc FreeChannel*(ch: uint16) {.importc: "audio_free".}

proc PlaySample*(ch: uint16; data: pointer; len: uint32; period: uint16) {.importc: "audio_play".}

const
  LEFT0* = 1'u16
  RIGHT0* = 2'u16
  LEFT1* = 4'u16
  RIGHT1* = 8'u16

{.pop.}
