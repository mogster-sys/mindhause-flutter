# MindHause — Asset Shopping List

> Every asset the project still needs, with exact specs, format requirements, and where each file goes. Organised by priority — get the essentials first, polish later.

---

## Priority Key

- **P1 (Essential)** — Game won't feel right without these
- **P2 (Important)** — Noticeable improvement, do before any public demo
- **P3 (Polish)** — Nice to have, can ship without

---

## 1. CAT MODELS (P1)

The cat is the emotional core of the app. Currently a placeholder orange capsule.

### Default Cat (Greco-Roman)

| Spec | Value |
|------|-------|
| **Format** | `.glb` (binary glTF) — Godot's preferred import format |
| **Poly count** | 500–2,000 tris (low-poly stylised) |
| **Size** | Roughly 0.3m wide × 0.5m long × 0.35m tall (in Godot units = metres) |
| **Rig** | Simple skeleton: spine (3 bones), tail (3-4 bones), legs (2 bones each), head, jaw |
| **Animations needed** | idle_sit, idle_stand, walk, run, nap (curl up), hiss (arched back), purr (kneading), meow (head up), celebrate (roll/play) |
| **Material** | Pale cream/ivory, simple toon or unlit style, warm undertones |
| **File path** | `godot_palace/models/cats/cat_greco_roman.glb` |

### Theme Variant Cats (P2 — one per DLC theme)

| Theme | Cat Description | File |
|-------|----------------|------|
| Modern Loft | Grey/steel-blue short hair, sleek | `models/cats/cat_modern_loft.glb` |
| Victorian Scholar | Black or dark tabby, slightly fluffier | `models/cats/cat_victorian.glb` |
| Sci-Fi Minimal | White/silver, sleek, holographic collar | `models/cats/cat_scifi.glb` |
| Gothic Cathedral | Long-haired black, shadowy | `models/cats/cat_gothic.glb` |
| Japanese Ryokan | Calico Japanese bobtail, compact | `models/cats/cat_ryokan.glb` |
| Countryside Cottage | Ginger fluffy, chunky | `models/cats/cat_cottage.glb` |
| Fallout Bunker | Scrappy tabby, maybe one-eared, bandana | `models/cats/cat_fallout.glb` |

**All variant cats must share the same skeleton and animation set** so the same AnimationTree works for all. Only mesh and material differ.

### Where to Get Them

| Source | Cost | Notes |
|--------|------|-------|
| [Quaternius](https://quaternius.com/) | Free CC0 | Has a low-poly animal pack with cats |
| [Kenney](https://kenney.nl/assets/category:3D) | Free CC0 | Check animal packs |
| [Sketchfab](https://sketchfab.com/search?q=low+poly+cat&type=models) | Free–$30 | Filter by "downloadable", check licence |
| [itch.io](https://itch.io/game-assets/tag-3d/tag-animals) | Free–$15 | Low-poly animal packs |
| Blender + tutorial | Time (~4hrs) | "Low poly cat Blender tutorial" on YouTube |
| Commission (Fiverr/ArtStation) | $50–$150 | Get one rigged + animated, recolour for variants |

**Recommended approach:** Buy/find ONE good rigged low-poly cat, then duplicate and re-skin for each theme. Total cost: $0–$50 for all 8 cats.

---

## 2. TASK OBJECT MODELS (P2)

Currently using primitive meshes (cylinders, boxes, spheres). Works but looks placeholder-y.

| Object Type | Description | Approx Size (m) | File |
|-------------|-------------|------------------|------|
| **scroll** | Rolled parchment with ribbon | 0.25 × 0.06 × 0.06 | `models/objects/scroll.glb` |
| **book** | Leather-bound book, closed | 0.15 × 0.22 × 0.04 | `models/objects/book.glb` |
| **candle** | Short pillar candle on dish | 0.06 × 0.15 × 0.06 | `models/objects/candle.glb` |
| **statue** | Small bust or figurine | 0.08 × 0.15 × 0.08 | `models/objects/statue.glb` |
| **letter** | Sealed envelope with wax stamp | 0.12 × 0.01 × 0.08 | `models/objects/letter.glb` |
| **blueprint** | Rolled/flat plan with markings | 0.2 × 0.02 × 0.15 | `models/objects/blueprint.glb` |
| **plant** | Small potted plant | 0.1 × 0.15 × 0.1 | `models/objects/plant.glb` |
| **post_it** | Sticky note (flat, slightly curled) | 0.07 × 0.07 × 0.005 | `models/objects/post_it.glb` |
| **jar** | Glass jar with cork | 0.08 × 0.12 × 0.08 | `models/objects/jar.glb` |
| **key** | Ornate old-fashioned key | 0.12 × 0.06 × 0.02 | `models/objects/key.glb` |

**All objects:** 50–300 tris each. No rig needed. Simple albedo material. The glow colour is applied by `task_object.gd` at runtime based on priority.

### Where to Get Them

| Source | Cost | Notes |
|--------|------|-------|
| [Kenney RPG Items](https://kenney.nl/) | Free | Books, keys, potions, scrolls |
| [Quaternius Ultimate RPG Pack](https://quaternius.com/) | Free | Scrolls, books, chests, keys, candles |
| [Kay Lousberg](https://kaylousberg.itch.io/) | Free | Dungeon items, furniture items |
| Blender batch | ~2 hrs | All 10 objects are simple shapes, very quick |

**Recommended:** Download Kenney + Quaternius RPG packs (both free CC0). Between them you'll get 8/10 objects immediately. Model the remaining 2 in Blender.

---

## 3. SOUND EFFECTS (P1)

No audio exists in the project yet. These make the palace feel alive.

### Interaction Sounds

| Sound | Description | Duration | Format | File |
|-------|-------------|----------|--------|------|
| **task_pickup** | Soft "pick up object" — paper rustle or gentle thud | 0.3–0.5s | `.ogg` | `audio/sfx/task_pickup.ogg` |
| **task_complete** | Satisfying completion chime — warm, musical | 0.5–1.0s | `.ogg` | `audio/sfx/task_complete.ogg` |
| **task_place** | Set object down on surface — soft clunk | 0.2–0.4s | `.ogg` | `audio/sfx/task_place.ogg` |
| **door_open** | Wooden door creak open | 0.8–1.5s | `.ogg` | `audio/sfx/door_open.ogg` |
| **door_close** | Wooden door close — quieter than open | 0.5–1.0s | `.ogg` | `audio/sfx/door_close.ogg` |

### Cat Sounds

| Sound | Description | Duration | Format | File |
|-------|-------------|----------|--------|------|
| **cat_meow** | Short, friendly meow (attention-getting) | 0.5–1.0s | `.ogg` | `audio/sfx/cat_meow.ogg` |
| **cat_purr** | Warm purring loop (task completion/idle) | 2–4s loopable | `.ogg` | `audio/sfx/cat_purr.ogg` |
| **cat_hiss** | Warning hiss (monster nearby) | 0.5–0.8s | `.ogg` | `audio/sfx/cat_hiss.ogg` |
| **cat_chirp** | Short chirpy meow (greeting) | 0.3–0.5s | `.ogg` | `audio/sfx/cat_chirp.ogg` |

### Monster Sounds (P2)

| Sound | Description | Duration | Format | File |
|-------|-------------|----------|--------|------|
| **monster_growl** | Low rumble — neglected task getting worse | 1–2s | `.ogg` | `audio/sfx/monster_growl.ogg` |
| **monster_chase** | Escalating tension loop — monster pursuing | 3–5s loopable | `.ogg` | `audio/sfx/monster_chase.ogg` |
| **monster_defeat** | Relief sound — task completed, monster dissolves | 1–2s | `.ogg` | `audio/sfx/monster_defeat.ogg` |

### Environment Sounds

| Sound | Description | Duration | Format | File |
|-------|-------------|----------|--------|------|
| **footstep_stone** | Walking on marble/stone floor | 0.2–0.3s | `.ogg` | `audio/sfx/footstep_stone.ogg` |
| **footstep_wood** | Walking on wooden floor | 0.2–0.3s | `.ogg` | `audio/sfx/footstep_wood.ogg` |
| **footstep_grass** | Walking on garden ground | 0.2–0.3s | `.ogg` | `audio/sfx/footstep_grass.ogg` |
| **stairs_step** | Going up/down stairs | 0.3–0.4s | `.ogg` | `audio/sfx/stairs_step.ogg` |

### UI Sounds (P3)

| Sound | Description | Duration | Format | File |
|-------|-------------|----------|--------|------|
| **ui_tap** | Soft click for button presses | 0.1s | `.ogg` | `audio/sfx/ui_tap.ogg` |
| **ui_swipe** | Swoosh for screen transitions | 0.2–0.3s | `.ogg` | `audio/sfx/ui_swipe.ogg` |
| **ui_notification** | Gentle ping for alerts | 0.3–0.5s | `.ogg` | `audio/sfx/ui_notification.ogg` |

### Where to Get Them

| Source | Cost | Notes |
|--------|------|-------|
| [Freesound.org](https://freesound.org/) | Free (CC0/BY) | Huge library, search by keyword, check licence per sound |
| [Kenney Audio](https://kenney.nl/assets/category:Audio) | Free CC0 | UI sounds, impacts, RPG sounds |
| [Mixkit](https://mixkit.co/free-sound-effects/) | Free | Curated free SFX library |
| [Zapsplat](https://www.zapsplat.com/) | Free (account) | Large library, good creature/ambient section |
| [Pixabay Audio](https://pixabay.com/sound-effects/) | Free | Royalty-free SFX |

**Format note:** Godot prefers `.ogg` (Ogg Vorbis) for sound effects. Convert `.wav` or `.mp3` using Audacity (free) or `ffmpeg -i input.wav -c:a libvorbis output.ogg`.

**Recommended:** Freesound + Kenney covers 90% of these. Budget: $0.

---

## 4. AMBIENT MUSIC / ATMOSPHERE (P2)

Background audio per theme. Should be calm, non-intrusive, loopable. Each track plays while the user is inside the corresponding palace theme — crossfading when switching rooms or themes.

### Tracks Needed

| Track | Description | Duration | Format | File |
|-------|-------------|----------|--------|------|
| **ambient_greco_roman** | Warm, classical, soft strings + harp | 2–4 min loop | `.ogg` | `audio/music/ambient_greco_roman.ogg` |
| **ambient_modern_loft** | Lo-fi electronic, soft pads + beat | 2–4 min loop | `.ogg` | `audio/music/ambient_modern_loft.ogg` |
| **ambient_victorian** | Gentle piano + strings, brass accents | 2–4 min loop | `.ogg` | `audio/music/ambient_victorian.ogg` |
| **ambient_scifi** | Synth pads, subtle bleeps, spacey | 2–4 min loop | `.ogg` | `audio/music/ambient_scifi.ogg` |
| **ambient_gothic** | Choir drone, organ undertone, reverent | 2–4 min loop | `.ogg` | `audio/music/ambient_gothic.ogg` |
| **ambient_ryokan** | Koto + shakuhachi, flowing water, wind | 2–4 min loop | `.ogg` | `audio/music/ambient_ryokan.ogg` |
| **ambient_cottage** | Acoustic guitar, birdsong, fireplace | 2–4 min loop | `.ogg` | `audio/music/ambient_cottage.ogg` |
| **ambient_fallout** | Industrial hum, distant radio static, dripping | 2–4 min loop | `.ogg` | `audio/music/ambient_fallout.ogg` |

### Search Keywords Per Theme

Use these when hunting on Pixabay, Freesound, etc.:

| Theme | Search Keywords |
|-------|----------------|
| Greco-Roman | `classical ambient loop`, `ancient greek meditation`, `harp strings peaceful`, `marble hall ambience` |
| Modern Loft | `lofi ambient chill`, `minimal electronic background`, `soft beats workspace`, `urban loft ambience` |
| Victorian | `victorian piano ambient`, `dark academia music`, `gentle classical study`, `library ambience strings` |
| Sci-Fi | `space ambient synth`, `sci-fi background loop`, `cyberpunk calm`, `futuristic pad drone` |
| Gothic | `gothic cathedral ambient`, `dark choir drone`, `organ reverb meditation`, `sacred space ambience` |
| Ryokan | `japanese zen ambient`, `koto meditation`, `zen garden water`, `shakuhachi nature loop` |
| Cottage | `cottagecore ambient`, `countryside acoustic`, `fireplace birdsong loop`, `pastoral folk ambient` |
| Fallout | `post apocalyptic ambient`, `bunker atmosphere`, `industrial drone loop`, `dystopian background noise` |

### Audio Spec

- **Format:** `.ogg` (Ogg Vorbis) — Godot's preferred format for streamed audio
- **Sample rate:** 44.1 kHz stereo
- **Bitrate:** 128–192 kbps (keeps file size reasonable, ~2–4 MB per track)
- **Looping:** Must loop seamlessly. Trim silence at start/end. Use a fade or compose for a clean loop point
- **Volume:** Normalize to around -14 LUFS so they sit well under SFX without clipping
- **Convert with:** `ffmpeg -i input.mp3 -c:a libvorbis -b:a 160k output.ogg`

### Implementation — What Needs Building

**Godot side (palace view):**
1. Add an `AudioStreamPlayer` node to the palace scene (or an `AudioManager` autoload)
2. On palace entry, look up the active theme from the DB `settings` table (`theme` key)
3. Load the matching `audio/music/ambient_{theme_id}.ogg` as an `AudioStreamOggVorbis`
4. Play with `loop = true`, volume around -10 dB
5. Crossfade (1–2 second linear interpolation) when switching between rooms/themes
6. Fade out on palace exit
7. Respect a `music_enabled` setting (add to settings screen) and a volume slider

**Flutter side (optional — for non-palace ambient):**
- If you want ambient in the flat organiser view too, use the `audioplayers` package
- But recommended to keep ambient Godot-only so the palace feels special

**Settings to add:**
- `music_enabled` (bool) — master toggle
- `music_volume` (0.0–1.0) — slider in settings under a new "Audio" section

### Where to Get Them

| Source | Cost | Notes |
|--------|------|-------|
| [Pixabay Music](https://pixabay.com/music/) | Free | Royalty-free ambient/lofi tracks — best starting point |
| [Freesound.org](https://freesound.org/) | Free (CC0/BY) | More raw/atmospheric, great for Fallout/Gothic/Sci-Fi |
| [Incompetech](https://incompetech.com/music/) | Free (BY) | Kevin MacLeod's library, tons of ambient |
| [Freepd.com](https://freepd.com/) | Free CC0 | Public domain ambient music |
| [Suno AI](https://suno.ai/) | Free tier | AI-generated music — describe the vibe, get a loop |
| [Epidemic Sound](https://www.epidemicsound.com/) | $15/mo | High quality, good for final production |

**Recommended:** Start with Pixabay Music (best free library for this). Search using the keywords above. Suno AI is a good fallback for any themes you can't find a good match for — just describe the atmosphere and it'll generate a loop. Budget: $0–$15.

---

## 5. ROOM TEXTURES — SPLIT FROM SHEETS (P2)

The 8 texture sheets are in `godot_palace/textures/sheets/`. Each is a multi-panel image that needs to be **split into individual tileable textures** for Godot material use.

### What to Extract

From each sheet, crop out the individual panels and save as separate PNGs:

**greco_roman.png** → crop into:
| Panel | Size | Save As |
|-------|------|---------|
| Top-left: White marble | 512×512+ | `textures/greco_roman/marble_floor.png` |
| Top-right: Gold trim + cream wall | 512×512+ | `textures/greco_roman/wall_trim.png` |
| Bottom-left: Panelled wall | 512×512+ | `textures/greco_roman/wall_panels.png` |
| Bottom-right: Warm parchment | 512×512+ | `textures/greco_roman/parchment.png` |

**Repeat for all 8 themes.** Each sheet has 4 panels (except Fallout which has 9).

Total: ~36 individual texture files.

**Tool:** Any image editor (GIMP is free). Crop each quadrant, resize to power-of-2 (512×512 or 1024×1024), save as PNG.

**Directory structure:**
```
godot_palace/textures/
  sheets/          ← raw sheets (already here)
  greco_roman/     ← split individual textures
  modern_loft/
  victorian/
  scifi/
  gothic/
  ryokan/
  cottage/
  fallout/
```

---

## 6. FURNITURE MODELS (P3)

Currently rooms use CSGBox3D for desks, counters, beds, etc. Replacing with proper models adds visual quality.

| Model | Used In | Approx Size (m) | File |
|-------|---------|------------------|------|
| **desk** | Study, Bedroom | 1.5 × 0.75 × 0.8 | `models/furniture/desk.glb` |
| **bookshelf** | Library, Study | 1.0 × 2.0 × 0.3 | `models/furniture/bookshelf.glb` |
| **table_round** | Kitchen, Library | 1.2 × 0.75 × 1.2 | `models/furniture/table_round.glb` |
| **workbench** | Workshop | 2.0 × 0.85 × 0.8 | `models/furniture/workbench.glb` |
| **bed** | Bedroom | 2.0 × 0.6 × 2.5 | `models/furniture/bed.glb` |
| **stone_bench** | Garden, Gymnasium | 1.5 × 0.5 × 0.5 | `models/furniture/stone_bench.glb` |
| **pedestal** | Foyer, Treasury, Garden | 0.4 × 1.0 × 0.4 | `models/furniture/pedestal.glb` |
| **notice_board** | Kitchen | 0.8 × 1.0 × 0.05 | `models/furniture/notice_board.glb` |
| **display_case** | Treasury, Library | 0.6 × 1.2 × 0.6 | `models/furniture/display_case.glb` |
| **stone_table** | Cellar | 1.5 × 0.7 × 0.8 | `models/furniture/stone_table.glb` |
| **counter** | Kitchen | 2.0 × 0.9 × 0.6 | `models/furniture/counter.glb` |
| **column_ionic** | Foyer (decorative) | 0.4 × 4.0 × 0.4 | `models/furniture/column_ionic.glb` |

**All furniture:** 200–1,000 tris each. No rig. Simple albedo material.

### Where to Get Them

| Source | Cost | Notes |
|--------|------|-------|
| [Kenney Furniture Kit](https://kenney.nl/) | Free | Great low-poly furniture |
| [Quaternius](https://quaternius.com/) | Free | Medieval/fantasy furniture packs |
| [Kay Lousberg](https://kaylousberg.itch.io/) | Free | Dungeon and house furniture |

**Recommended:** Kenney + Quaternius will cover 90%. Budget: $0.

---

## 7. THEME TIMEPIECES (P2)

Each theme has a signature clock/timekeeping device that displays real local time. These tie into the existing `time_of_day.gd` system and double as ambient sound sources. See [THEME_REFERENCE.md](THEME_REFERENCE.md) for full design descriptions.

### Models Needed

| Theme | Primary | Secondary | Tris (each) | Files |
|-------|---------|-----------|-------------|-------|
| Greco-Roman | Stone sundial | Water clock (clepsydra) | 500–1,500 | `models/timepieces/sundial.glb`, `clepsydra.glb` |
| Modern Loft | LED wall display | — | 200–500 | `models/timepieces/digital_clock.glb` |
| Victorian Scholar | Grandfather clock | Brass mantel clock | 1,000–2,000 | `models/timepieces/grandfather_clock.glb`, `mantel_clock.glb` |
| Sci-Fi Minimal | Holographic projector | — | 300–800 | `models/timepieces/holo_clock.glb` |
| Gothic Cathedral | Astronomical clock face | Monastic hourglass | 1,000–2,000 | `models/timepieces/astronomical_clock.glb`, `hourglass.glb` |
| Japanese Ryokan | Incense clock | Pillar clock | 500–1,000 | `models/timepieces/incense_clock.glb`, `pillar_clock.glb` |
| Countryside Cottage | Cuckoo clock | Kitchen wall clock | 800–1,500 | `models/timepieces/cuckoo_clock.glb`, `kitchen_clock.glb` |
| Fallout Bunker | Salvaged analog clock | CRT readout bank | 500–1,000 | `models/timepieces/salvaged_clock.glb`, `crt_readout.glb` |

**All timepieces:** Simple albedo material. Animated elements (hands, pendulum, dripping, burning) via AnimationPlayer or shader. Clock hand rotation / display updates driven by `timepiece.gd` at runtime.

### Hourly Chime Sounds

| Sound | Description | Duration | File |
|-------|-------------|----------|------|
| **chime_water_drip** | Water droplet into basin | 0.5–1.0s | `audio/sfx/chime_water_drip.ogg` |
| **chime_digital** | Soft electronic beep | 0.3–0.5s | `audio/sfx/chime_digital.ogg` |
| **chime_westminster** | Classic Westminster quarter chime | 2–4s | `audio/sfx/chime_westminster.ogg` |
| **chime_holo_pulse** | Sci-fi digital pulse tone | 0.5–1.0s | `audio/sfx/chime_holo_pulse.ogg` |
| **chime_cathedral_bell** | Deep reverberant bell toll | 2–4s | `audio/sfx/chime_cathedral_bell.ogg` |
| **chime_incense_clink** | Small weight dropping onto wood | 0.3–0.5s | `audio/sfx/chime_incense_clink.ogg` |
| **chime_cuckoo** | Cuckoo bird call (1x per hour) | 1–2s | `audio/sfx/chime_cuckoo.ogg` |
| **chime_bunker_static** | Burst of radio static + beep | 0.5–1.0s | `audio/sfx/chime_bunker_static.ogg` |

### Where to Get Them

| Source | Cost | Notes |
|--------|------|-------|
| [Quaternius](https://quaternius.com/) | Free | May have hourglass, basic clocks in fantasy packs |
| [Kenney](https://kenney.nl/) | Free | Furniture packs sometimes include clocks |
| [Sketchfab](https://sketchfab.com/) | Free–$20 | Search "grandfather clock low poly", "sundial", "hourglass" |
| Blender | Time (~6 hrs total) | Most of these are simple shapes with painted faces |
| Freesound.org | Free | Clock chimes, bell tolls, cuckoo sounds are abundant |

**Recommended:** The hourglass and basic clocks can likely be found free. The more exotic ones (incense clock, astronomical clock, clepsydra) will probably need to be modelled. The chime sounds are all easily sourced from Freesound. Budget: $0–$20.

---

## 8. APP ICON + STORE ASSETS (P2)

| Asset | Spec | File |
|-------|------|------|
| **App icon** | 1024×1024 PNG, no transparency, rounded corners applied by OS | `assets/icon/app_icon.png` |
| **Play Store feature graphic** | 1024×500 PNG | `assets/store/feature_graphic.png` |
| **App Store screenshots** | 1290×2796 (iPhone 15 Pro Max) × 5 minimum | `assets/store/screenshot_*.png` |

**Style:** Match the Greco-Roman theme. Golden castle/column silhouette on warm marble background. The cat should be in the icon.

---

## 9. FONTS (P3)

Currently using Material 3 defaults. Theme-specific fonts add character.

| Font | Use Case | Source | File |
|------|----------|--------|------|
| **Cinzel** | Headings (Greco-Roman) | Google Fonts, free | `assets/fonts/Cinzel-Regular.ttf` |
| **Lora** | Body text | Google Fonts, free | `assets/fonts/Lora-Regular.ttf` |

These get registered in `pubspec.yaml` under `fonts:` and applied in `theme.dart`.

---

## Summary — Total Shopping List

| Category | Items | Priority | Est. Cost | Est. Time |
|----------|-------|----------|-----------|-----------|
| Cat model (default) | 1 rigged + animated | P1 | $0–$50 | 1–4 hrs |
| Cat variants | 7 re-skins | P2 | $0 (re-skin) | 1 hr each |
| Sound effects (20 files) | See Section 3 | P1 | $0 | 2–3 hrs sourcing |
| Ambient music (8 tracks) | See Section 4 | P2 | $0–$15 | 1–2 hrs |
| Task object models (10) | See Section 2 | P2 | $0 | 1–2 hrs |
| Texture splitting | 36 files from sheets | P2 | $0 | 1 hr |
| Timepiece models (14) | See Section 7 | P2 | $0–$20 | 3–6 hrs |
| Timepiece chime SFX (8) | See Section 7 | P2 | $0 | 30 min |
| Furniture models (12) | See Section 6 | P3 | $0 | 2 hrs sourcing |
| App icon | 1 file | P2 | $0–$25 | 30 min |
| Fonts | 2 files | P3 | $0 | 10 min |

**Total estimated budget: $0–$110**
**Total estimated time: 13–20 hours of sourcing/processing**

---

## File Structure When Complete

```
godot_palace/
  audio/
    sfx/
      task_pickup.ogg
      task_complete.ogg
      task_place.ogg
      door_open.ogg
      door_close.ogg
      cat_meow.ogg
      cat_purr.ogg
      cat_hiss.ogg
      cat_chirp.ogg
      monster_growl.ogg
      monster_chase.ogg
      monster_defeat.ogg
      footstep_stone.ogg
      footstep_wood.ogg
      footstep_grass.ogg
      stairs_step.ogg
      ui_tap.ogg
      ui_swipe.ogg
      ui_notification.ogg
      chime_water_drip.ogg
      chime_digital.ogg
      chime_westminster.ogg
      chime_holo_pulse.ogg
      chime_cathedral_bell.ogg
      chime_incense_clink.ogg
      chime_cuckoo.ogg
      chime_bunker_static.ogg
    music/
      ambient_greco_roman.ogg
      ambient_modern_loft.ogg
      ambient_victorian.ogg
      ambient_scifi.ogg
      ambient_gothic.ogg
      ambient_ryokan.ogg
      ambient_cottage.ogg
      ambient_fallout.ogg
  models/
    cats/
      cat_greco_roman.glb
      cat_modern_loft.glb
      cat_victorian.glb
      cat_scifi.glb
      cat_gothic.glb
      cat_ryokan.glb
      cat_cottage.glb
      cat_fallout.glb
    objects/
      scroll.glb
      book.glb
      candle.glb
      statue.glb
      letter.glb
      blueprint.glb
      plant.glb
      post_it.glb
      jar.glb
      key.glb
    furniture/
      desk.glb
      bookshelf.glb
      table_round.glb
      workbench.glb
      bed.glb
      stone_bench.glb
      pedestal.glb
      notice_board.glb
      display_case.glb
      stone_table.glb
      counter.glb
      column_ionic.glb
    timepieces/
      sundial.glb
      clepsydra.glb
      digital_clock.glb
      grandfather_clock.glb
      mantel_clock.glb
      holo_clock.glb
      astronomical_clock.glb
      hourglass.glb
      incense_clock.glb
      pillar_clock.glb
      cuckoo_clock.glb
      kitchen_clock.glb
      salvaged_clock.glb
      crt_readout.glb
  textures/
    sheets/           (already populated)
    greco_roman/
    modern_loft/
    victorian/
    scifi/
    gothic/
    ryokan/
    cottage/
    fallout/
```

---

*Asset shopping list for MindHause. Generated 2026-02-15.*
