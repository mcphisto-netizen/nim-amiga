# examples/dir_list.nim
# List files in current directory (Amiga DOS)

{.compile: "../amiga_dos_c.c".}

type
  uint32 = distinct uint32
  int32 = distinct int32
  BPTR = uint32

proc Open(name: cstring; mode: int32): BPTR
  {.importc: "nim_open", header: "proto/dos.h".}
proc Read(fh: BPTR; buf: pointer; len: int32): int32
  {.importc: "nim_read", header: "proto/dos.h".}
proc Close(fh: BPTR): int32
  {.importc: "nim_close", header: "proto/dos.h".}
proc Output(): BPTR
  {.importc: "nim_output", header: "proto/dos.h".}

const
  MODE_OLDFILE = 1005'i32

proc main() =
  let out = Output()
  if out == 0: return

  # For demo: just print a message
  let msg = "Directory listing demo\n"
  discard write(out, unsafeAddr(msg[0]), msg.len.int32)
  # Full implementation would use Examine()/NextDosEntry()

when isMainModule:
  main()