# MindHause Pitch Video — Shot Script (60–90s)

The single most important pitch asset. Goal: the "I want to be in there" moment. Let visuals + ambient audio carry it; minimal or no voiceover.

## Source

Recorded from Godot, running the kitted Greco-Roman vertical slice:
- `scenes/rooms/library.tscn` — cinematic camera auto-plays 30s (press R to replay)
- `scenes/rooms/garden.tscn` — cinematic camera auto-plays 30s

Two options for the continuous feel:
- **A (simplest)**: record each scene's 30s glide separately (F6 each scene), then cut them together in any video editor with a 1s crossfade at the library→garden door.
- **B (best)**: run the full app via `house.tscn`, walk Library→Garden manually for one continuous take. Higher effort, needs player+door transitions working smoothly.

Recommend A for the pitch — controllable, repeatable, no live-walk risk.

## Shot breakdown (~75s target)

| Time | Shot | Source |
|---|---|---|
| 0–4s | **Title card**: "MindHause" + "Turn your mind into a place you can walk through." Fade in over a held library still. | Static |
| 4–30s | **Library glide**: enter from foyer door → sweep the bookshelves → descend toward the display case with statue + jar. Cat visible on/near reading table. | library.tscn camera |
| 30–32s | **Crossfade** at the garden door (1–2s dissolve). | Editor |
| 32–58s | **Garden glide**: down the marble path to the fountain → circle right → rise toward cypress against the golden sky → settle on bench+fountain. | garden.tscn camera |
| 58–68s | **One-tap mode flip** (if you can capture it): palace → organiser list view → back. Shows it's a real planner, not just a tech demo. | Flutter/organiser (optional) |
| 68–75s | **End card**: tagline + "Not another list app." + [your URL / contact]. | Static |

## Audio

- **Bed**: the Greco-Roman ambient track (Suno music + Sculptunes-Rome layer from Sonniss, per the audio plan). ~-14 LUFS, sits under everything.
- **Accent**: a single soft cat purr (`Mechanical Wave - ANMLCat` from Sonniss) timed to the cat shot. Optional.
- **No voiceover** for v1 — let the space speak. If you add VO later, keep it to 1–2 lines max ("Your tasks live somewhere. Walk through them.").

## Recording tips

- In Godot, run the scene (F6), use OBS or the OS screen recorder at 1080p/60fps (or 4K if the GTX 1080 holds frame rate — test first).
- Hide the Godot editor chrome — record the game window only, fullscreen if possible.
- Do 3–4 takes of each scene; the camera path is deterministic so they'll match — pick the cleanest frame timing.
- If frame rate dips during the glide, drop the painterly post-process strength or window resolution; smooth motion matters more than max fidelity for a pitch.

## Fallback if video underwhelms

If the real-time render doesn't hit "investor-grade" on the GTX 1080, capture **high-res stills** instead (pause the camera at the best frames, screenshot at max resolution) and build a Ken Burns slideshow. Stills are very forgiving and can look spectacular. The deck's hero images can come from the same captures.
