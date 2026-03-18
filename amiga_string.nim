# NimString runtime minimo (sin GC)
{.deadCodeElim: on.}
{.push inline.}

type
  NI8* = uint8
  NI32* = uint32

  NimString* = object
    refCount*: NI32
    len*: NI32
    data*: ptr NI8

proc alloc*(size: int): pointer {.importc: "nim_alloc".}
proc dealloc*(p: pointer; size: int) {.importc: "nim_dealloc".}

proc strlen*(s: ptr NimString): NI32 =
  if s == nil: return 0
  result = s.len

proc charAt*(s: ptr NimString; i: NI32): NI8 =
  if s == nil or i >= s.len: return 0
  result = s.data[i]

proc streq*(a, b: ptr NimString): bool =
  if a == b: return true
  if a == nil or b == nil: return false
  if a.len != b.len: return false
  for i in 0..<a.len:
    if a.data[i] != b.data[i]:
      return false
  result = true

proc strcat*(a, b: ptr NimString): ptr NimString =
  if a == nil: return b
  if b == nil: return a

  let newLen = a.len + b.len
  let headerSize = 12'u32
  let totalSize = headerSize + newLen

  let mem = cast[ptr NimString](alloc(int(totalSize)))
  if mem == nil: return nil

  mem.refCount = 0
  mem.len = newLen
  mem.data = cast[ptr NI8](cast[uint32](mem) + headerSize)

  for i in 0..<a.len:
    mem.data[i] = a.data[i]

  for i in 0..<b.len:
    mem.data[a.len + i] = b.data[i]

  result = mem

{.pop.}
