# seq[T] genérico mínimo (sin GC)
{.deadCodeElim: on.}
{.inline: on.}

type
  NI32* = uint32

  NimSeq*[T] = object
    refCount*: NI32
    len*: NI32
    cap*: NI32
    data*: ptr T

# --- memory hooks ---
proc alloc*(size: int): pointer {.importc: "nim_alloc".}
proc dealloc*(p: pointer; size: int) {.importc: "nim_dealloc".}

# --- helpers ---
proc newSeq*[T](capacity: NI32 = 4): ptr NimSeq[T] =
  let headerSize = 12'u32
  let es = sizeof(T)
  let actualCap = if capacity == 0: 4'u32 else: capacity
  let total = headerSize + (actualCap * NI32(es))

  let s = cast[ptr NimSeq[T]](alloc(int(total)))
  if s == nil: return nil

  s.refCount = 0
  s.len = 0
  s.cap = actualCap
  s.data = cast[ptr T](cast[uint32](s) + headerSize)

  for i in 0..<actualCap:
    s.data[i] = default(T)

  result = s

proc push*[T](s: var ptr NimSeq[T]; v: T) =
  if s == nil:
    s = newSeq[T](4)
    if s == nil: return

  if s.len < s.cap:
    s.data[s.len] = v
    inc s.len
    return

  let newCap = 
    if s.cap > 0x7FFFFFFFu32 div 2: s.cap + 1024'u32
    else: s.cap * 2

  let newS = newSeq[T](newCap)
  if newS == nil: return

  for i in 0..<s.len:
    newS.data[i] = s.data[i]

  newS.data[s.len] = v
  newS.len = s.len + 1

  let oldTotal = 12'u32 + (s.cap * NI32(sizeof(T)))
  dealloc(s, int(oldTotal))

  s = newS

proc get*[T](s: ptr NimSeq[T]; i: NI32): T =
  if s == nil or i >= s.len:
    return default(T)
  result = s.data[i]

proc set*[T](s: ptr NimSeq[T]; i: NI32; v: T) =
  if s == nil or i >= s.len: return
  s.data[i] = v

proc len*[T](s: ptr NimSeq[T]): NI32 =
  if s == nil: return 0
  result = s.len

proc freeSeq*[T](s: ptr NimSeq[T]) =
  if s != nil:
    let es = sizeof(T)
    let total = 12'u32 + (s.cap * NI32(es))
    dealloc(cast[pointer](s), int(total))