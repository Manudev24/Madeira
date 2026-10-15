#!/bin/bash
# Build the base libwineserver.a that build.sh patches: every wine/server/*.c
# that build.sh does not compile itself, with build.sh's flags. (The original
# base archive was a hand-kept prebuilt and is not in the repository.)
set -euo pipefail
BUILD_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$BUILD_DIR/../.." && pwd)"
WINE_SRC="$REPO_ROOT/wine"
SDK=$(xcrun --sdk iphoneos --show-sdk-path)
SHIMS_DIR="$REPO_ROOT/build/ntdll-unix/shims"
OBJ="$BUILD_DIR/obj/base"; rm -rf "$OBJ"; mkdir -p "$OBJ"
REPLACED="request main mach unicode fd process window user mapping class region queue winstation thread sock object async event semaphore handle inproc_sync"
fail=0
for src in "$WINE_SRC"/server/*.c; do
  n=$(basename "$src" .c)
  [[ " $REPLACED " == *" $n "* ]] && continue
  if ! xcrun -sdk iphoneos clang -arch arm64 -isysroot "$SDK" -miphoneos-version-min=17.0 -O2 \
      -I"$WINE_SRC/include" -I"$WINE_SRC/include/wine" -I"$WINE_SRC/build-macos/include" \
      -I"$BUILD_DIR" -I"$WINE_SRC/server" -I"$SHIMS_DIR" -I"$BUILD_DIR/../madsync" -DHAVE_LINUX_NTSYNC_H=1 \
      -include "$BUILD_DIR/config_ios.h" -include stdarg.h -include "$BUILD_DIR/unicode_fix.h" \
      -include "$BUILD_DIR/wineserver_ios_kill.h" \
      -DBINDIR=\"/usr/local/bin\" -DDATADIR=\"/usr/local/share\" -D__WINESRC__ -DWINE_IOS=1 \
      -Dmain=wineserver_main -Wno-implicit-function-declaration \
      -c "$src" -o "$OBJ/$n.o" 2>"$OBJ/$n.err"; then
    echo "FAILED $n"; head -3 "$OBJ/$n.err"; fail=1
  fi
done
rm -f "$BUILD_DIR/obj/libwineserver.a"
ar rcs "$BUILD_DIR/obj/libwineserver.a" "$OBJ"/*.o
echo "base: $(ls "$OBJ"/*.o | wc -l) objects"
exit $fail
