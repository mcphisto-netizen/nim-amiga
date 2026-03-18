# examples/hola.nim
# A minimal "Hello World" for Amiga 500

{.compile: "../amiga_dos_c.c".}

type
  uint32 = distinct uint32  # Avoid conflicts
  int32 = distinct int32

proc write(fh: uint32; buf: pointer; len: int32): int32
  {.importc: "nim_write", header: "proto/dos.h".}

proc output(): uint32
  {.importc: "nim_output", header: "proto/dos.h".}

proc main() =
  let msg = "Hello from Nim on Amiga 500!\n"
  let fh = output()
  if fh != 0'u32:
    discard write(fh, unsafeAddr(msg[0]), msg.len.int32)

when isMainModule:
  main()