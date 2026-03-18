# Runtime de memoria Nim -> Exec.library (GC manual)
{.deadCodeElim: on.}
{.inline: on.}

type
  ULONG* = uint32
  APTR* = pointer

# --- Exec bindings ---
proc AllocMem*(size: ULONG; flags: ULONG): APTR
  {.importc: "AllocMem", cdecl.}

proc FreeMem*(mem: APTR; size: ULONG)
  {.importc: "FreeMem", cdecl.}

const
  MEMF_ANY* = 0'u32

# --- Nim hooks (system replacement) ---
proc alloc*(size: int): pointer {.exportc: "nim_alloc".} =
  result = AllocMem(ULONG(size), MEMF_ANY)

proc dealloc*(p: pointer; size: int) {.exportc: "nim_dealloc".} =
  if p != nil:
    FreeMem(p, ULONG(size))

proc alloc0*(size: int): pointer {.exportc: "nim_alloc0".} =
  let p = AllocMem(ULONG(size), MEMF_ANY)
  if p != nil:
    var b = cast[ptr uint8](p)
    for i in 0..<size:
      b[i] = 0
  result = p