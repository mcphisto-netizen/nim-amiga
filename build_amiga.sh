#!/usr/bin/env bash
set -e

# Nim → Amiga 500 build script
# Usage: ./build_amiga.sh my_program.nim

NIM=nim
VBCC=${VBCC_PATH:-/opt/vbcc}
VC=$VBCC/bin/vc
VASM=$VBCC/bin/vasmm68k_mot
VLINK=$VBCC/bin/vlink

SRC=${1:-examples/hola.nim}
OUT=$(basename "$SRC" .nim)
CACHE=nimcache

echo ">> Step 1: Nim → C"
$NIM c --compileOnly --singleModule:on --nimcache:$CACHE -o:$CACHE/$OUT.c $SRC

C_FILE=$(find $CACHE -name "*.c" | head -n 1)
if [ -z "$C_FILE" ]; then 
    echo "Error: No C file generated"
    exit 1
fi

echo ">> Step 2: Inject Amiga headers"
sed -i '1i #define ALIGN2 __attribute__((aligned(2)))' "$C_FILE"
sed -i '1i #include <exec/types.h>' "$C_FILE"
sed -i '1i #include <proto/exec.h>' "$C_FILE"
sed -i '1i #include <proto/dos.h>' "$C_FILE"

echo ">> Step 3: Compile C → m68k object"
$VC -c -cpu=68000 -O "$C_FILE" -o $OUT.o

echo ">> Step 4: Compile amiga_bases.c"
$VC -c -cpu=68000 -O amiga_bases.c -o amiga_bases.o

echo ">> Step 5: Assemble crt0_amiga.s"
$VASM -Fhunk -m68000 crt0_amiga.s -o crt0.o

echo ">> Step 6: Link → Amiga Hunk executable"
$VLINK -b amigahunk -c -o $OUT crt0.o amiga_bases.o $OUT.o -lc 2>/dev/null || \
$VLINK -b amigahunk -o $OUT crt0.o amiga_bases.o $OUT.o

SIZE=$(wc -c < "$OUT" | tr -d ' ')
echo ">> Result: $OUT ($SIZE bytes)"

if [ "$SIZE" -gt 409600 ]; then
    echo "Warning: Binary exceeds 400 KB (may not fit in Chip RAM)"
fi

echo "✅ Done. Transfer '$OUT' to your Amiga to run."
