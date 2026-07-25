#!/usr/bin/env bash
set -euo pipefail

NDSTOOL=ndstool/source
BLZ_SRC=blz_linux.c
OUT=wasm
DEBUG=${DEBUG:-0}

mkdir -p "$OUT"

COMMON=(
  -s MODULARIZE=1
  -s INVOKE_RUN=0
  -s EXIT_RUNTIME=0
  -s ALLOW_MEMORY_GROWTH=1
  -s FORCE_FILESYSTEM=1
  -s STACK_SIZE=8388608                     # 8 MB: recursive MAXPATHLEN frames
  -s EXPORTED_RUNTIME_METHODS='["callMain","ccall","FS"]'
)

if [ "$DEBUG" = "1" ]; then
  COMMON+=( -g -O0 -s ASSERTIONS=2 -s STACK_OVERFLOW_CHECK=2 -s SAFE_HEAP=1 )
  echo ">>> DEBUG build: slow, but reports the real cause of any trap"
else
  COMMON+=( -O2 )
fi

echo "=== blz ==="
emcc "$BLZ_SRC" -o "$OUT/blz.mjs" \
  "${COMMON[@]}" \
  -s EXPORT_NAME=createBLZ \
  -s INITIAL_MEMORY=33554432 \
  -s MAXIMUM_MEMORY=134217728 \
  -s EXPORTED_FUNCTIONS='["_main"]'

echo "=== ndstool ==="
emcc \
  "$NDSTOOL"/ndstool.cpp   "$NDSTOOL"/ndscreate.cpp  "$NDSTOOL"/ndsextract.cpp \
  "$NDSTOOL"/header.cpp    "$NDSTOOL"/banner.cpp     "$NDSTOOL"/bigint.cpp \
  "$NDSTOOL"/crc.cpp       "$NDSTOOL"/elf.cpp        "$NDSTOOL"/encryption.cpp \
  "$NDSTOOL"/hook.cpp      "$NDSTOOL"/logo.cpp       "$NDSTOOL"/ndscodes.cpp \
  "$NDSTOOL"/ndstree.cpp   "$NDSTOOL"/raster.cpp     "$NDSTOOL"/sha1.cpp \
  "$NDSTOOL"/loadme.c      "$NDSTOOL"/compile_date.c "$NDSTOOL"/default_icon.c \
  "$NDSTOOL"/wasm_shim.cpp \
  -I "$NDSTOOL" \
  -DPACKAGE_VERSION='"2.1.2"' \
  -o "$OUT/ndstool.mjs" \
  "${COMMON[@]}" \
  -s EXPORT_NAME=createNDSTool \
  -s INITIAL_MEMORY=33554432 \
  -s MAXIMUM_MEMORY=134217728 \
  -s EXPORTED_FUNCTIONS='["_main","_ndstool_reset"]'

echo "=== done -> $OUT/{blz,ndstool}.{mjs,wasm} ==="
