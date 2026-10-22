#!/usr/bin/env bash
# brand-audit.sh - brand audit for the public site and profile surfaces.
# Prints PASS/FAIL lines with numbers. No secrets, no writes. Requires: curl, md5sum.
# Check targets (profile handles, account IDs) live in ops/brand-audit.targets -
# a local, uncommitted file. Copy ops/brand-audit.targets.example and fill it in.
set -u
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
if [ -f "$SCRIPT_DIR/brand-audit.targets" ]; then
  . "$SCRIPT_DIR/brand-audit.targets"
else
  echo "FAIL ops/brand-audit.targets missing (copy ops/brand-audit.targets.example and fill in real targets)"
  exit 1
fi
SITE=https://ins.sherbeeny.com
LOGO_MD5=866652fa1316e0b6dc8d96fd2a2ee4c7   # assets/brand/masters/logo.svg, verified 2026-10-21
GH_USER_MD5=${GH_USER_MD5:-e231b9bd70d2d82a6c820162a50737af}   # default: personal photo, intentional (2026-10-22); targets file may pin another
GH_ORG_MD5=${GH_ORG_MD5:-3ba1396ab420ff4ccb4e7198ddaea223}   # unified-mark GitHub org avatar (460px), verified 2026-10-21; targets file may pin another
F32_MD5=89f78f841aa905520688010084edff16   # favicon-32.png, verified 2026-10-21
ATI_MD5=a16d24ff377d46976c266c97226396c8   # apple-touch-icon.png, verified 2026-10-21
ICO_MD5=af297e1fa778b7ea50f8abd438218b02   # favicon.ico (16/32/48), merged #22 2026-10-22
F16_MD5=73f185663ddc7c3e9b4b176aed1c736b   # favicon-16.png, merged #22 2026-10-22
MANIFEST_MD5=d3ae265711096f6c451234ac19c6f6b8   # manifest.json, merged #24 2026-10-22

check() { # name expected actual
  if [ "$2" = "$3" ]; then echo "PASS $1 ($3)"; else echo "FAIL $1 (want $2, got $3)"; fi
}

# Site pages
for p in / /favicon.svg /favicon-32.png /favicon-16.png /favicon.ico /apple-touch-icon.png /logo.svg /manifest.json; do
  code=$(curl -s -o /dev/null -w '%{http_code}' "$SITE$p")
  check "GET $p" 200 "$code"
done
code=$(curl -s -o /dev/null -w '%{http_code}' "$SITE/nonexistent-page")
check "GET /404-page" 404 "$code"

# Logo + icon byte-identity
m=$(curl -s "$SITE/logo.svg" | md5sum | awk '{print $1}')
check "logo.svg md5" "$LOGO_MD5" "$m"
m=$(curl -s "$SITE/favicon-32.png" | md5sum | awk '{print $1}')
check "favicon-32.png md5" "$F32_MD5" "$m"
m=$(curl -s "$SITE/apple-touch-icon.png" | md5sum | awk '{print $1}')
check "apple-touch-icon.png md5" "$ATI_MD5" "$m"
m=$(curl -s "$SITE/favicon.ico" | md5sum | awk '{print $1}')
check "favicon.ico md5" "$ICO_MD5" "$m"
m=$(curl -s "$SITE/favicon-16.png" | md5sum | awk '{print $1}')
check "favicon-16.png md5" "$F16_MD5" "$m"
m=$(curl -s "$SITE/manifest.json" | md5sum | awk '{print $1}')
check "manifest.json md5" "$MANIFEST_MD5" "$m"

# Arabic feminine forms on the AR page
html=$(curl -s "$SITE/")
wrong=$(printf '%s' "$html" | grep -o 'أنس' | wc -l)
right=$(printf '%s' "$html" | grep -o 'إنس' | wc -l)
check "AR wrong-form count" 0 "$wrong"
echo "INFO AR correct-form count: $right"

# Social-preview meta on the homepage
og=$(printf '%s' "$html" | grep -c 'property="og:title"')
check "og:title present" 1 "$og"
tw=$(printf '%s' "$html" | grep -c 'name="twitter:card"')
check "twitter:card present" 1 "$tw"

# Favicon companion palette
fs=$(curl -s "$SITE/favicon.svg")
printf '%s' "$fs" | grep -q '#0f4c3a' && echo "PASS favicon palette (green companion present)" || echo "FAIL favicon palette changed"

# Profile avatars (targets from the uncommitted targets file)
gm=$(curl -s "https://avatars.githubusercontent.com/u/${GH_USER_ID}?v=4&s=460" | md5sum | awk '{print $1}')
check "GH user avatar md5" "$GH_USER_MD5" "$gm"
gm=$(curl -s "https://avatars.githubusercontent.com/u/${GH_ORG_ID}?v=4&s=460" | md5sum | awk '{print $1}')
check "GH org avatar md5" "$GH_ORG_MD5" "$gm"

for t in $TG_HANDLES; do
  u=$(curl -s "https://t.me/$t" | grep -o 'property="og:image" content="[^"]*"' | head -1 | sed 's/.*content="//;s/"//')
  if [ -n "$u" ]; then
    echo "PASS chat-profile og:image present (md5 $(curl -s "$u" | md5sum | awk '{print $1}'))"
  else
    echo "FAIL chat-profile og:image missing"
  fi
done
