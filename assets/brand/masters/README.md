# Brand masters - Ins public identity

Source-of-truth vector masters for Ins's public identity (site, avatars, group photos). Variants derive from these; never fork them. Owner: agent:branding (publishing + public identity). Design ownership: agent:reem.

## Files

| File | What | Canvas | Status (2026-10-21) |
| --- | --- | --- | --- |
| `logo.svg` | Site master mark (face-crescent, rounded rect) | 64x64 viewBox | LIVE - byte-identical to https://ins.sherbeeny.com/logo.svg (md5 866652fa1316...) |
| `mark-1280-base.svg` | Full-bleed 1280 base for all photo variants: live face path re-wrapped with `translate(640 640) scale(1.1) translate(-636 -638)`, navy #1e1b4a full-bleed | 1280x1280 | Stable base |
| `photo-mokalem-mic-v5-1280.svg` | Mokalem / Calls Log group photo candidate: base + mask cutting mic dot (cx521 cy662 r30) and up-curving mic line exiting the face edge to the right (stroke 14, round caps) | 1280x1280 | Candidate v5, awaiting final pick |
| `photo-workspace-glasses-v5-1280.svg` | Ins Workspace group photo candidate: base + glasses (rect x515 y408 w80 h58 rx16, arm to (716,493), bridge curve) in navy #1e1b4a stroke 13 | 1280x1280 | Candidate v5, awaiting final pick |

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

Known-good checks (640px render): glasses v5 = 13920 bytes PNG; mic v5 = 13864 bytes PNG. Site logo must stay byte-identical to the live file; recover it with `curl -s https://ins.sherbeeny.com/logo.svg`.

## Rules

- Changes to a master = new issue + PR (issue-first workflow). "Do not redesign without his instruction" applies to approved photos.
- Placement is measured (pixel scans), never eyeballed; report numbers.
- No secrets, no personal data, no machine paths in this directory.
