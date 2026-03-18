# Quick Start: Run Your First Nim Program on Amiga 500

## What you need

- A computer with Nim 2.x installed ([nim-lang.org/install](https://nim-lang.org/install.html))
- `vbcc` compiler for m68k-amigaos ([download](http://sun.hasenbraten.de/vbcc/))
- `vlink` linker (comes with vbcc)
- `FS-UAE` emulator (optional, for testing) ([fs-uae.net](https://fs-uae.net))
Installing vbcc (detailed)

Download vbcc from http://sun.hasenbraten.de/vbcc/
Extract to /opt/vbcc (or your preferred location)
Download the Amiga NDK headers (required for exec/types.h, etc.)

NDK 3.9 is freely available and works well


Set environment variables:

bash   export VBCC_PATH=/opt/vbcc
   export PATH=$VBCC_PATH/bin:$PATH

Verify installation:

bash   vc -v          # Should show vbcc version
   vasmm68k_mot   # Should show vasm version
   vlink          # Should show vlink version

Note: Without the Amiga NDK headers, Step 2 of the build script
(injecting #include <exec/types.h> etc.) will fail at compile time.
The NDK must be configured so that vbcc can find the headers.

## Step-by-step

### 1. Clone this repo


git clone https://github.com/mcphisto-netizen/nim-amiga
cd nim-amiga
