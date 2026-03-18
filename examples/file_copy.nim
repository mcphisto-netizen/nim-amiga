# examples/file_copy.nim
# Copy a file to another location on AmigaDOS
# Works with nim-amiga runtime v0.1.0
# Usage: file_copy source.txt dest.txt

{.compile: "../amiga_dos_c.c".}

# --- Type definitions ---
type
  uint32* = distinct uint32
  int32* = distinct int32
  BPTR* = uint32
  STRPTR* = cstring

# --- DOS.library constants ---
const
  MODE_OLDFILE* = 1005'i32      # Open existing file (read)
  MODE_NEWFILE* = 1006'i32      # Create new file (write)
  BUFFER_SIZE* = 1024'i32       # Copy buffer size (1 KB)

# --- DOS.library bindings ---
proc Open(name: STRPTR; mode: int32): BPTR
  {.importc: "nim_open", header: "proto/dos.h", cdecl.}

proc Close(fh: BPTR): int32
  {.importc: "nim_close", header: "proto/dos.h", cdecl.}

proc Read(fh: BPTR; buf: pointer; len: int32): int32
  {.importc: "nim_read", header: "proto/dos.h", cdecl.}

proc Write(fh: BPTR; buf: pointer; len: int32): int32
  {.importc: "nim_write", header: "proto/dos.h", cdecl.}

proc Output(): BPTR
  {.importc: "nim_output", header: "proto/dos.h", cdecl.}

# --- Memory management ---
proc alloc*(size: int): pointer {.importc: "nim_alloc".}
proc dealloc*(p: pointer; size: int) {.importc: "nim_dealloc".}

# --- Helper: Write C string to output ---
proc writeStr(fh: BPTR; s: cstring) =
  if fh != 0'u32:
    discard write(fh, s, s.len.int32)

# --- Helper: Write error message ---
proc writeError(fh: BPTR; msg: cstring) =
  writeStr(fh, "Error: ")
  writeStr(fh, msg)
  writeStr(fh, "\n")

# --- Helper: Write number (decimal) ---
proc writeNum(fh: BPTR; n: uint32) =
  if fh == 0'u32: return
  if n == 0'u32:
    var zero = '0'
    discard write(fh, addr zero, 1'i32)
    return
  var digits: array[10, char]
  var count = 0
  var value = n
  while value > 0'u32 and count < 10:
    digits[count] = char(ord('0') + int(value mod 10'u32))
    value = value div 10'u32
    inc count
  for i in countdown(count - 1, 0):
    discard write(fh, addr digits[i], 1'i32)

# --- Main copy function ---
proc copyFile(srcName: cstring; dstName: cstring): bool =
  let fhOut = Output()
  
  # Open source file (read-only)
  let srcFH = Open(srcName, MODE_OLDFILE)
  if srcFH == 0'u32:
    writeError(fhOut, "Cannot open source file")
    return false
  
  # Create destination file (write-only)
  let dstFH = Open(dstName, MODE_NEWFILE)
  if dstFH == 0'u32:
    writeError(fhOut, "Cannot create destination file")
    Close(srcFH)
    return false
  
  # Allocate buffer (1 KB)
  let buffer = alloc(BUFFER_SIZE)
  if buffer == nil:
    writeError(fhOut, "Cannot allocate memory")
    Close(srcFH)
    Close(dstFH)
    return false
  
  # Copy loop
  var totalBytes: uint32 = 0'u32
  var copyError = false
  
  while true:
    # Read from source
    let bytesRead = Read(srcFH, buffer, BUFFER_SIZE)
    
    if bytesRead < 0'i32:
      writeError(fhOut, "Read error")
      copyError = true
      break
    
    if bytesRead == 0'i32:
      break  # EOF reached
    
    # Write to destination
    let bytesWritten = Write(dstFH, buffer, bytesRead)
    
    if bytesWritten != bytesRead:
      writeError(fhOut, "Write error")
      copyError = true
      break
    
    totalBytes = totalBytes + uint32(bytesWritten)
  
  # Free buffer
  dealloc(buffer, BUFFER_SIZE)
  
  # Close files
  Close(srcFH)
  Close(dstFH)
  
  # Report result
  if not copyError:
    writeStr(fhOut, "Copied ")
    writeNum(fhOut, totalBytes)
    writeStr(fhOut, " bytes\n")
  
  return not copyError

# --- Main program ---
proc main() =
  let fhOut = Output()
  if fhOut == 0'u32:
    return
  
  writeStr(fhOut, "=== File Copy Utility ===\n")
  writeStr(fhOut, "\n")
  
  # For v0.1.0: hardcoded filenames (no argv parsing yet)
  # Users can edit these lines or we add arg parsing in v0.2.0
  let srcFile = "hola"      # Source file name
  let dstFile = "hola.bak"  # Destination file name
  
  writeStr(fhOut, "Source: ")
  writeStr(fhOut, srcFile)
  writeStr(fhOut, "\n")
  
  writeStr(fhOut, "Dest:   ")
  writeStr(fhOut, dstFile)
  writeStr(fhOut, "\n")
  writeStr(fhOut, "\n")
  
  # Perform copy
  if copyFile(srcFile, dstFile):
    writeStr(fhOut, "\nSuccess!\n")
  else:
    writeStr(fhOut, "\nFailed.\n")
  
  writeStr(fhOut, "\nDone.\n")

when isMainModule:
  main()
