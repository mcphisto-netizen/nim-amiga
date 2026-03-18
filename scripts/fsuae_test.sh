#!/usr/bin/env bash
set -e

# FS-UAE test script for Nim-Amiga
# Usage: ./scripts/fsuae_test.sh program_name

FSUAE=fs-uae
HD=hd0
OUT=${1:-hola}
ROM=kick13.rom

echo ">> Testing $OUT in FS-UAE"

# Prepare HD
mkdir -p $HD/s
cp $OUT $HD/

# Create startup-sequence
cat > $HD/s/startup-sequence <<EOF
echo "Running $OUT..."
$OUT
echo "Done."
endcli >NIL:
EOF

# Launch FS-UAE (headless)
$FSUAE \
  --kickstart_file=$ROM \
  --hard_drive_0=$HD \
  --chip_memory=1 \
  --fast_memory=0 \
  --cpu=68000 \
  --no_gui \
  --log_level=3 \
  --duration=5

echo ">> Test complete"