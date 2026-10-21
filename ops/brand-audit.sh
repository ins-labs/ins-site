#!/usr/bin/env bash
# brand-audit.sh - brand audit for the public site and profile surfaces.
# Prints PASS/FAIL lines with numbers. No secrets, no writes. Requires: curl, md5sum.
set -u
SITE=https://ins.sherbeeny.com
LOGO_MD5=866652fa1316e0b6dc8d96fd2a2ee4c7   # assets/brand/masters/logo.svg, verified 2026-10-21
GH_USER_MD5=3ba1396ab420ff4ccb4e7198ddaea223   # unified-mark GitHub user avatar (460px), verified 2026-10-21
GH_ORG_MD5=3ba1396ab420ff4ccb4e7198ddaea223   # unified-mark GitHub org avatar (460px), verified 2026-10-21
F32_MD5=89f78f841aa905520688010084edff16   # favicon-32.png, verified 2026-10-21
ATI_MD5=a16d24ff377d46976c266c97226396c8   # apple-touch-icon.png, verified 2026-10-21

check() { # name expected actual
  if [ "$2" = "$3" ]; then echo "PASS $1 ($3)"; else echo "FAIL $1 (want $2, got $3)"; fi
}

# Site pages
for p in / /favicon.svg /favicon-32.png /apple-touch-icon.png /logo.svg; do
  code=$(curl -s -o /dev/null -w '%{http_code}' "$SITE$p")
  check "GET $p" 200 "$code"
done
code=$(curl -s -o /dev/null -w '%{http_code}' "$SITE/nonexistent-page")
check "GET /404-page" 404 "$code"

# Logo byte-identity with repo master
m=$(curl -s "$SITE/logo.svg" | md5sum | awk '{print $1}')
check "logo.svg md5" "$LOGO_MD5" "$m"
m=$(curl -s "$SITE/favicon-32.png" | md5sum | awk '{print $1}')
check "favicon-32.png md5" "$F32_MD5" "$m"
m=$(curl -s "$SITE/apple-touch-icon.png" | md5sum | awk '{print $1}')
check "apple-touch-icon.png md5" "$ATI_MD5" "$m"

# Arabic feminine forms on the AR page
html=$(curl -s "$SITE/")
wrong=$(printf '%s' "$html" | grep -o 'أنس' | wc -l)
right=$(printf '%s' "$html" | grep -o 'إنس' | wc -l)
check "AR wrong-form count" 0 "$wrong"
echo "INFO AR correct-form count: $right"

# Favicon companion sanity (crescent+star, green/cream/gold)
fs=$(curl -s "$SITE/favicon.svg")
printf '%s' "$fs" | grep -q '#0f4c3a' && echo "PASS favicon palette (green companion present)" || echo "FAIL favicon palette changed"

# GitHub avatars (unified mark)
gm=$(curl -s "https://avatars.githubusercontent.com/u/337566235?v=4&s=460" | md5sum | awk '{print $1}')
check "GH user avatar md5" "$GH_USER_MD5" "$gm"
gm=$(curl -s "https://avatars.githubusercontent.com/u/338397455?v=4&s=460" | md5sum | awk '{print $1}')
check "GH org avatar md5" "$GH_ORG_MD5" "$gm"

# Telegram public photos (og:image presence)
for t in InsSherbeeny InsSherboBot; do
  u=$(curl -s "https://t.me/$t" | grep -o 'property="og:image" content="[^"]*"' | head -1 | sed 's/.*content="//;s/"//')
  if [ -n "$u" ]; then
    echo "PASS t.me/$t og:image present (md5 $(curl -s "$u" | md5sum | awk '{print $1}'), baseline 2026-10-21: InsSherbeeny 8f5187f8bb545a9b52d64e8a2ed859da, InsSherboBot c2a0772cc3a9103ff3eb67805fb14a08)"
  else
    echo "FAIL t.me/$t og:image missing"
  fi
done
