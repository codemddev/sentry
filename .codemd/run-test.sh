#!/usr/bin/env bash
root="$(pwd)"
target="${1:-all}"
status=0
mkdir -p "$root/codemd-reports" "$root/.codemd/test-results"
if [ "$target" = "finalize" ]; then
  if [ ! -f "$root/.codemd/test-results/0.exit" ]; then echo "CODEMD_TIMEOUT 0"; echo "CODEMD_RESULT 0 124"; status=1; else code="$(cat "$root/.codemd/test-results/0.exit")"; [ "$code" -eq 0 ] || status=1; fi
  if [ ! -f "$root/.codemd/test-results/1.exit" ]; then echo "CODEMD_TIMEOUT 1"; echo "CODEMD_RESULT 1 124"; status=1; else code="$(cat "$root/.codemd/test-results/1.exit")"; [ "$code" -eq 0 ] || status=1; fi
  if [ ! -f "$root/.codemd/test-results/2.exit" ]; then echo "CODEMD_TIMEOUT 2"; echo "CODEMD_RESULT 2 124"; status=1; else code="$(cat "$root/.codemd/test-results/2.exit")"; [ "$code" -eq 0 ] || status=1; fi
  exit "$status"
fi
if [ "$target" = "all" ] || [ "$target" = "0" ]; then
( cd . && eval 'pnpm test-ci static/app/views/navigation/secondary/components.spec.tsx' ); code=$?
echo "$code" > "$root/.codemd/test-results/0.exit"
echo "CODEMD_RESULT 0 $code"; [ "$code" -eq 0 ] || status=1
if [ "$code" -ne 0 ] && [ "$code" -ne 124 ] && [ "$code" -ne 126 ] && [ "$code" -ne 127 ]; then passes=0; for n in 1 2; do ( cd . && timeout 300 bash -c 'pnpm test-ci static/app/views/navigation/secondary/components.spec.tsx' ) >/dev/null 2>&1 && passes=$((passes+1)); done; echo "CODEMD_RERUN 0 $passes 2"; fi
fi
if [ "$target" = "all" ] || [ "$target" = "1" ]; then
( cd . && eval 'pnpm test-ci static/app/views/navigation/secondary/sections/explore/exploreSecondaryNavigation.spec.tsx' ); code=$?
echo "$code" > "$root/.codemd/test-results/1.exit"
echo "CODEMD_RESULT 1 $code"; [ "$code" -eq 0 ] || status=1
if [ "$code" -ne 0 ] && [ "$code" -ne 124 ] && [ "$code" -ne 126 ] && [ "$code" -ne 127 ]; then passes=0; for n in 1 2; do ( cd . && timeout 300 bash -c 'pnpm test-ci static/app/views/navigation/secondary/sections/explore/exploreSecondaryNavigation.spec.tsx' ) >/dev/null 2>&1 && passes=$((passes+1)); done; echo "CODEMD_RERUN 1 $passes 2"; fi
fi
if [ "$target" = "all" ] || [ "$target" = "2" ]; then
( cd . && eval 'pnpm test-ci static/app/views/navigation/secondary/sections/issues/issuesSecondaryNavigation.spec.tsx' ); code=$?
echo "$code" > "$root/.codemd/test-results/2.exit"
echo "CODEMD_RESULT 2 $code"; [ "$code" -eq 0 ] || status=1
if [ "$code" -ne 0 ] && [ "$code" -ne 124 ] && [ "$code" -ne 126 ] && [ "$code" -ne 127 ]; then passes=0; for n in 1 2; do ( cd . && timeout 300 bash -c 'pnpm test-ci static/app/views/navigation/secondary/sections/issues/issuesSecondaryNavigation.spec.tsx' ) >/dev/null 2>&1 && passes=$((passes+1)); done; echo "CODEMD_RERUN 2 $passes 2"; fi
fi
exit "$status"
