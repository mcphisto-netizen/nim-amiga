# examples/mem_check.nim
# Show available memory on Amiga 500 (Chip RAM / Total RAM)
# Works with nim-amiga runtime v0.1.0

{.compile: "../amiga_dos_c.c".}

# --- Type definitions (avoid conflicts with system.nim) ---
type
  uint32* = distinct uint32
  int32* = distinct int32
  APTR* = pointer
  STRPTR* = cstring

# --- Exec.library bindings ---
proc AvailMem(flags: uint32): uint32
  {.importc: "AvailMem", header: "proto/exec.h", cdecl.}

const
  MEMF_ANY* = 0'u32
  MEMF_CHIP* = 1'u32    # Chip RAM (graphics/sound accessible)
  MEMF_FAST* = 2'u32    # Fast RAM (CPU only, if present)

# --- DOS.library bindings ---
proc write(fh: uint32; buf: pointer; len: int32): int32
  {.importc: "nim_write", header: "proto/dos.h", cdecl.}

proc output(): uint32
  {.importc: "nim_output", header: "proto/dos.h", cdecl.}

# --- Helper: Write a C string to stdout ---
proc writeStr(fh: uint32; s: cstring) =
  if fh != 0'u32:
    discard write(fh, s, s.len.int32)

# --- Helper: Write a number (simple decimal, no leading zeros) ---
proc writeNum(fh: uint32; n: uint32) =
  if fh == 0'u32: return
  
  # Handle zero
  if n == 0'u32:
    var zero = '0'
    discard write(fh, addr zero, 1'i32)
    return
  
  # Extract digits into buffer (max 10 digits for uint32)
  var digits: array[10, char]
  var count = 0
  var value = n
  
  while value > 0'u32 and count < 10:
    let digit = char(ord('0') + int(value mod 10'u32))
    digits[count] = digit
    value = value div 10'u32
    inc count
  
  # Write in reverse order
  for i in countdown(count - 1, 0):
    discard write(fh, addr digits[i], 1'i32)

# --- Helper: Write " KB" suffix ---
proc writeKB(fh: uint32) =
  writeStr(fh, " KB")

# --- Main program ---
proc main() =
  let fh = output()
  if fh == 0'u32:
    return  # No output available
  
  # Header
  writeStr(fh, "=== Amiga Memory Check ===\n")
  writeStr(fh, "\n")
  
  # Chip RAM (always present on A500: 512 KB typical)
  writeStr(fh, "Chip RAM: ")
  let chip = AvailMem(MEMF_CHIP)
  let chipKB = chip div 1024'u32
  writeNum(fh, chipKB)
  writeKB(fh)
  writeStr(fh, "\n")
  
  # Total available (Chip + Fast, if any)
  writeStr(fh, "Total Free: ")
  let total = AvailMem(MEMF_ANY)
  let totalKB = total div 1024'u32
  writeNum(fh, totalKB)
  writeKB(fh)
  writeStr(fh, "\n")
  
  # Simple visual indicator
  writeStr(fh, "\n[")
  # Draw a simple bar (max 40 chars = 40 KB units)
  let barUnits = min(chipKB div 10'u32, 40'u32)
  for i in 0'u32..<barUnits:
    writeStr(fh, "#")
  writeStr(fh, "]\n")
  
  writeStr(fh, "\nDone.\n")

when isMainModule:
  main()
