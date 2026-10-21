# Brand masters - Ins public identity

Source-of-truth vector masters for the Ins public identity (site, avatars, group photos). Variants derive from these files; never fork them.

## Files

| File | What | Canvas | Status (2026-10-21) |
| --- | --- | --- | --- |
| `logo.svg` | Site master mark (face-crescent, rounded rect) | 64x64 viewBox | Live - byte-identical to https://ins.sherbeeny.com/logo.svg |
| `mark-1280-base.svg` | Full-bleed 1280 base for all photo variants: face path re-wrapped with `translate(640 640) scale(1.1) translate(-636 -638)`, navy #1e1b4a full-bleed | 1280x1280 | Stable base |
| `photo-mokalem-mic-v5-1280.svg` | Group photo variant: base + mic dot (cx521 cy662 r30) and up-curving mic line exiting the face edge to the right (stroke 14, round caps) | 1280x1280 | Candidate |
| `photo-workspace-glasses-v5-1280.svg` | Group photo variant: base + glasses (rect x515 y408 w80 h58 rx16, arm to (716,493), bridge curve) in navy #1e1b4a stroke 13 | 1280x1280 | Candidate |

## Brand constants

- Mark: face-crescent vector trace, lavender #e4dbf9 on navy #1e1b4a.
- Round-crop safety: mark at 88% height, centered.
- Favicon companion (separate, intentional): crescent + star, see `/favicon.svg` on the live site.
- Arabic forms on every surface: feminine إِنس, never أنس.

## Rebuild / render

Render any master to a square PNG (example 640px):

```
google-chrome --headless --disable-gpu --no-sandbox \
  --screenshot=out.png --window-size=640,640 file:///path/to/master.svg
```

Known-good checks (640px render): glasses variant = 13920 bytes PNG; mic variant = 13864 bytes PNG. The site logo must stay byte-identical to the live file; recover it with `curl -s https://ins.sherbeeny.com/logo.svg`.

## Rules

- Placement is measured (pixel scans), never eyeballed.
- Variants derive from the masters; approved photos change only through the documented review process.
- No secrets, no personal data, no machine paths in this directory.
