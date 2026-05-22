# Asset Audit — 2026-05-10

Audit of `godot_palace/` against the Manus asset database in `docs/_manus_drop_2026-05-09/`. Manus credits exhausted — pausing acquisition here. Pick up by downloading the items in the **Recommended next downloads** section when credits/budget allow.

## What's already in the project

| Category | Present | Coverage |
|---|---|---|
| Cat models | 8 themed `.glb` in `godot_palace/models/cats/` | ✅ Complete (1 per theme) |
| Textures (theme PNGs) | 4–9 PNGs per theme across all 8 themes in `godot_palace/textures/` | 🟡 Single-channel PNGs only (not PBR multi-map) — likely hand-curated or AI-generated, not Poly Haven |
| Texture sheets | 8 theme overview sheets in `godot_palace/textures/sheets/` | ✅ One per theme |
| SFX | Doors, footsteps (grass/stone/wood), monsters, task pickup/place/complete, UI tap/swipe/notification in `godot_palace/audio/sfx/` | ✅ Core interactions covered |
| Shaders | Just `painterly_post.gdshader` (an unrelated detour) | 🔴 No toon shader, sky, water, glow, etc. |

## What's missing — major gaps

| Category | Status | Database picks not yet pulled |
|---|---|---|
| 3D models — architecture | 🔴 EMPTY (`godot_palace/assets/models/` is a placeholder) | Quaternius Modular Dungeon Pack, Modular Sci-Fi MegaKit, Medieval Village MegaKit; Kenney Modular Dungeon Kit; Synty POLYGON kits |
| 3D models — furniture | 🔴 EMPTY | Quaternius Ultimate Furniture Pack; Kenney Furniture Kit |
| 3D models — props | 🔴 EMPTY | Quaternius Fantasy Props MegaKit (books, candles, vases, scrolls, keys, jars) |
| 3D models — nature | 🔴 EMPTY | Quaternius Stylized Nature MegaKit (Ghibli-flavored) for Ryokan/Cottage |
| Music / ambient | 🔴 EMPTY (only `.gitkeep` in `godot_palace/audio/music/`) | Sonniss GDC Bundles (CC0); itch.io cozy/sci-fi packs |
| Materials (.tres) | 🔴 EMPTY (`godot_palace/assets/materials/`) | None pre-built — would be authored from PBR textures |
| Fonts | 🔴 EMPTY (`godot_palace/assets/fonts/`) | Not in Manus database |
| PBR textures (real, multi-map) | 🔴 None | Poly Haven Marble 012/014, Wood 095; AmbientCG bulk |
| Shader library | 🔴 None beyond painterly | Godot Skies ($20), Ultimate Toon Shader ($25), Water with Caustics (free), Stylized Spatial Clouds (free), Retro Parchment (free) |

## Headline

The whole 3D world is built from CSG primitives. **Zero architecture, furniture, or prop models have been downloaded.** `assets/models/`, `assets/materials/`, `assets/sounds/`, `assets/fonts/` are all empty placeholder folders. SFX and themed cat models are the only real 3D/audio content beyond textures.

## Recommended next downloads (when credits/budget allow)

Highest leverage for unblocking visual progress on every room. All CC0, all GLB-ready for Godot.

1. **Quaternius — Fantasy Props MegaKit** (books, candles, vases, scrolls, keys, jars) — covers symbolic task objects across all themes
2. **Quaternius — Ultimate Furniture Pack** — Modern Loft, Victorian, Cottage interiors
3. **Quaternius — Stylized Nature MegaKit** (Ghibli-inspired) — Ryokan, Cottage, Garden
4. **Quaternius — Modular Dungeon Pack** — arches/pillars for Gothic + Greco-Roman
5. **Sonniss GDC Bundles** (CC0) — ambient loops to fill the empty `audio/music/` folder

Source: <https://quaternius.com> and <https://sonniss.com/gameaudiogdc/>

## Reference

Full curated database (with premium picks, per-theme breakdown, strategic notes): `docs/_manus_drop_2026-05-09/MindHause Production Asset Database.md`
