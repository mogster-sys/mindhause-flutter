# Asset Tracking Ledger

Update this as assets are downloaded and integrated. This is the source of truth for "what's been gathered, where it lives in the project, and how well it met requirements."

## Status legend
- 🟦 **Pending** — recommended in `decisions.md`, not downloaded yet
- 🟨 **Downloaded** — file present in project, not yet imported into Godot
- 🟧 **Imported** — Godot recognized it but not used in any scene
- 🟩 **In-use** — placed in at least one scene/room
- ⬛ **Rejected** — downloaded then dropped (note why)
- ⬜ **N/A** — text shader, no download needed (paste-into-file)

## Fit-on-arrival score
After actually placing the asset in a room, re-rate fit on the 1–5 scale (Journey/ABZÛ = 5). The recon scores were judged from preview images; actual fit can differ.

---

## TIER A — Free essentials

### Materials (Poly Haven)

All downloaded 2026-05-10 via `tools/fetch_free_assets.sh`. 4K JPG with diffuse + nor_gl + arm + rough maps per asset. Total ~440 MB.

| Asset | Status | Downloaded path | Used in scene(s) | Fit-on-arrival | Notes |
|---|---|---|---|---|---|
| Marble 01 | 🟨 | `assets/materials/polyhaven/marble_01/` | | | 4K JPG, 4 maps |
| Wood Floor | 🟨 | `assets/materials/polyhaven/wood_floor/` | | | 4K JPG, 4 maps |
| Dark Wood | 🟨 | `assets/materials/polyhaven/dark_wood/` | | | 4K JPG, 4 maps |
| Castle Brick 01 | 🟨 | `assets/materials/polyhaven/castle_brick_01/` | | | 4K JPG, 4 maps |
| Painted Plaster Wall | 🟨 | `assets/materials/polyhaven/painted_plaster_wall/` | | | 4K JPG, 4 maps |
| Floral Jacquard | 🟨 | `assets/materials/polyhaven/floral_jacquard/` | | | 4K JPG, 4 maps |
| Brown Leather | 🟨 | `assets/materials/polyhaven/brown_leather/` | | | 4K JPG, 4 maps |
| Japanese Sycamore | 🟨 | `assets/materials/polyhaven/japanese_sycamore/` | | | 4K JPG, 4 maps |
| Herringbone Parquet | 🟨 | `assets/materials/polyhaven/herringbone_parquet/` | | | 4K JPG, 4 maps |
| Wood Floor Worn | 🟨 | `assets/materials/polyhaven/wood_floor_worn/` | | | 4K JPG, 4 maps |

### Materials (AmbientCG)

All downloaded 2026-05-10. 2K PNG with diffuse + normal + roughness + AO + displacement (full PBR map sets). Total ~114 MB.

| Asset | Status | Downloaded path | Used in scene(s) | Fit-on-arrival | Notes |
|---|---|---|---|---|---|
| Marble 012 | 🟨 | `assets/materials/ambientcg/Marble012/` | | | 2K PNG, full PBR set |
| Travertine 001 | 🟨 | `assets/materials/ambientcg/Travertine001/` | | | 2K PNG, full PBR set |
| Bricks 097 | 🟨 | `assets/materials/ambientcg/Bricks097/` | | | 2K PNG, full PBR set |

### Plants (Poly Haven)

All downloaded 2026-05-10. glTF + bin + 2K JPG textures. Total ~12 MB.

| Asset | Status | Downloaded path | Used in scene(s) | Fit-on-arrival | Notes |
|---|---|---|---|---|---|
| Potted Plant 04 (succulent) | 🟨 | `assets/models/plants/potted_plant_04/` | | | 6K tris, 2K textures |
| Calathea Orbifolia 01 | 🟨 | `assets/models/plants/calathea_orbifolia_01/` | | | 17K tris, 2K textures |

### Audio

| Asset | Status | Downloaded path | Used in scene(s) | Fit-on-arrival | Notes |
|---|---|---|---|---|---|
| Sonniss GDC 2026 Bundle | 🟦 | | | | Browser download — WebFetch blocked |

### Shaders (Godot Shaders, paste-in)

All installed 2026-05-10 via WebFetch + Write.

| Asset | Status | Saved as | Used in scene(s) | Fit-on-arrival | Notes |
|---|---|---|---|---|---|
| Ultimate Toon Shader | 🟧 | `shaders/toon.gdshader` | | | CC0, binbun |
| Stylized Sky With Clouds | 🟧 | `shaders/stylized_sky.gdshader` | | | CC0, axilirate — needs cloud textures |
| Water with Caustics | 🟧 | `shaders/water_caustics.gdshader` | | | CC0, binbun — needs caustics+wave textures |
| Distance Gradient Fog 4.3+ | 🟧 | `shaders/fog_gradient.gdshader` | | | MIT, Koaleszenz — needs gradient texture |
| Procedural Stained-Glass | 🟧 | `shaders/stained_glass.gdshader` | | | MIT, arlez80 |
| Procedural Torch & Candle | 🟧 | `shaders/candle.gdshader` | | | CC0/MIT, CaptainLaptop — purely procedural |
| Retro Parchment Paper | 🟧 | `shaders/parchment.gdshader` | | | CC0, GuoXiaoYao — purely procedural |

### Geometry placeholders (use only as last resort)

| Asset | Status | Downloaded path | Used in scene(s) | Fit-on-arrival | Notes |
|---|---|---|---|---|---|
| Quaternius Fantasy Props MegaKit | 🟨 | `assets/models/quaternius/fantasy_props/` | | | 94 glTF + 94 FBX + 94 OBJ. User-supplied 2026-05-10. 157 MB. Includes books (10 variants), scrolls (2), candles (4), keys (2), bookshelf, bookstand, etc. |
| Kenney Furniture Kit | 🟨 | `assets/models/kenney/furniture/` | | | 140 GLB files extracted (also FBX/OBJ/DAE/STL variants) |
| Quaternius Stylized Nature MegaKit | 🟨 | `assets/models/quaternius/stylized_nature/` | | | 68 glTF + 136 FBX + 68 OBJ. User-supplied 2026-05-10. 118 MB. Plants/trees/rocks for Ryokan/Cottage/Garden. |
| Quaternius Sushi Restaurant Kit | 🟨 | `assets/models/quaternius/sushi/` | | | 109 useful glTF (50 Environment + 36 Food + 15 Decoration + 16 Characters [skip]) + FBX/OBJ/Blend variants. User-supplied 2026-05-10 via Google Drive. 328 MB. **Useful chunk for Ryokan: Environment + Decoration**; Characters (Panda, Rabbits) are cartoon, skip. |
| Quaternius Sci-Fi Essentials Kit | 🟨 | `assets/models/quaternius/scifi_essentials/` | | | 37 glTF + 74 FBX + 37 OBJ. User-supplied 2026-05-10. 176 MB. Standard tier (Pro/Source has more). |

---

## TIER B — Cheap paid (~$89)

| Asset | Status | Cost paid | Downloaded path | Used in scene(s) | Fit-on-arrival | Notes |
|---|---|---|---|---|---|---|
| Binbun Effects Collection Vol. 1 | 🟦 | | | | | $26.25 |
| PixelLoops Fantasy Tavern Music | 🟦 | | | | | $4.49 |
| PixelLoops Calm Menu Music | 🟦 | | | | | $4.49 |
| PixelLoops Dark Ambient | 🟦 | | | | | $4.49 |
| PixelLoops Sci-Fi Ambient | 🟦 | | | | | $4.49 |
| Synty POLYGON - Samurai Pack | 🟦 | | | | | $15 |
| Synty POLYGON - Adventure Pack | 🟦 | | | | | $15 |
| Synty POLYGON - Knights Pack | 🟦 | | | | | $15 |

---

## TIER C — Theme anchors (~$220 add)

| Asset | Status | Cost paid | Downloaded path | Used in scene(s) | Fit-on-arrival | Notes |
|---|---|---|---|---|---|---|
| Synty POLYGON - Town Pack | 🟦 | | | | | $25 — ships Godot 4.5.1 project |
| Synty POLYGON - Office Pack | 🟦 | | | | | $25 (Modern Loft) |
| Synty POLYGON - Meadow Forest Biome | 🟦 | | | | | $27.50 |
| KitBash3D - Medieval Market | 🟦 | | | | | $95 |
| Airyluvs Japanese Music Collection | 🟦 | | | | | $49 |

---

## TIER D — Flagship (~$585 add)

| Asset | Status | Cost paid | Downloaded path | Used in scene(s) | Fit-on-arrival | Notes |
|---|---|---|---|---|---|---|
| KitBash3D - Elysium | 🟦 | | | | | $195 (Greco-Roman) |
| KitBash3D - Victorian | 🟦 | | | | | $145 |
| KitBash3D - Shogun | 🟦 | | | | | $245 (Ryokan) |

Or alternative: Cargo: KB3D Library subscription — $59/mo or $708/yr.

---

## Per-room asset assignment

Update as rooms get themed. Each row shows which assets ended up in which room.

| Room | Theme | Architecture textures | Furniture | Props | Plants | Audio loop | Shader stack |
|---|---|---|---|---|---|---|---|
| Foyer | (mixed/welcoming) | | | | | | |
| Study | greco_roman | | | | | | |
| Library | victorian | | | | | | |
| Kitchen | greco_roman | | | | | | |
| Bedroom | modern_loft | | | | | | |
| Cellar | gothic | | | | | | |
| Workshop | fallout | | | | | | |
| Garden | ryokan | | | | | | |
| Gymnasium | scifi | | | | | | |
| Treasury | gothic | | | | | | |

---

---

## Shopping list spec — additional categories

These rows capture the per-item shopping list (`requirements.md` + GPT/Perplexity scoping) at finer resolution than the theme×category matrix above. Update as items land.

### Task object models (target: `models/objects/`)

Phase 2 audit complete — see `phase2_audit.md` for full reasoning. Source paths are relative to `godot_palace/assets/models/`.

| File | Status | Source plan | Used in scene(s) | Fit-on-arrival | Notes |
|---|---|---|---|---|---|
| `scroll.glb` | 🟧 | `models/objects/scroll.gltf` (from Scroll_1) | | | Placed 2026-05-10 via `tools/place_phase3_assets.py` |
| `book.glb` | 🟧 | `models/objects/book.gltf` (from Book_5) | | | Placed Phase 3. Many alternates available in source pack |
| `candle.glb` | 🟧 | `models/objects/candle.gltf` (from Candle_1) | | | Placed Phase 3. Candle_2 / CandleStick variants in source pack |
| `statue.glb` | 🟧 SUB | `models/objects/statue.gltf` (from Dummy — substitute) | | | Placed Phase 3 as Dummy substitute. Custom for true bust |
| `letter.glb` | 🟦 CUSTOM | **Custom Blender** (~10 min) | | | No envelope shape in Quaternius. Closest substitute: Pouch_Large.gltf |
| `jar.glb` | 🟧 | `models/objects/jar.gltf` (from Pot_1) | | | Placed Phase 3. Pot_1_Lid.gltf still in source pack if needed for sealed look |
| `key.glb` | 🟧 | `models/objects/key.gltf` (from Key_Gold) | | | Placed Phase 3. Key_Metal silver alt available |
| `plant.glb` | 🟨 | `models/plants/potted_plant_04/potted_plant_04.gltf` | | | Already in TIER A — Poly Haven, photoreal, 6K tris |
| `blueprint.glb` | 🟦 CUSTOM | **Custom Blender** (~10 min) | | | Bent plane + paint texture |
| `post_it.glb` | 🟦 CUSTOM | **Custom Blender** (~5 min) | | | Quad with corner bend |

### Furniture models (target: `models/furniture/`)

Phase 2 audit complete. Source paths relative to `godot_palace/assets/models/`. Kenney Furniture Kit ships single-file `.glb`; Quaternius ships `.gltf + .bin` pairs.

| File | Status | Source plan | Used in scene(s) | Fit-on-arrival | Notes |
|---|---|---|---|---|---|
| `desk.glb` | 🟧 | `models/furniture/desk.glb` | | | Placed Phase 3 from Kenney |
| `bookshelf.glb` | 🟧 | `models/furniture/bookshelf.glb` (from Kenney bookcaseClosed) | | | Placed Phase 3 |
| `table_round.glb` | 🟧 | `models/furniture/table_round.glb` | | | Placed Phase 3 from Kenney |
| `bed.glb` | 🟧 | `models/furniture/bed.glb` (from Kenney bedSingle) | | | Placed Phase 3 |
| `counter.glb` | 🟧 | `models/furniture/counter.glb` (from Kenney kitchenBar) | | | Placed Phase 3 |
| `workbench.glb` | 🟧 | `models/furniture/workbench.gltf` (from Quaternius FP) | | | Placed Phase 3 |
| `display_case.glb` | 🟧 SUB | `models/furniture/display_case.glb` (from Kenney bookcaseClosedDoors) | | | Placed Phase 3. Re-material as glass when wiring |
| `notice_board.glb` | 🟦 CUSTOM | **Custom** (~5 min flat board + cork material) | | | Or stretch: Quaternius Sushi `Decoration_Painting.gltf` as frame |
| `pedestal.glb` | 🟧 SUB | `models/furniture/pedestal.gltf` (from BookStand) | | | Placed Phase 3. Substitute |
| `stone_bench.glb` | 🟧 SUB | `models/furniture/stone_bench.gltf` (from Bench) | | | Placed Phase 3. Apply stone material override |
| `stone_table.glb` | 🟧 SUB | `models/furniture/stone_table.gltf` (from Table_Large) | | | Placed Phase 3. Apply stone material override |
| `column_ionic.glb` | 🟦 CUSTOM | **Custom Blender** (~30 min) | | | Genuine Greco gap. Stretch: Sushi `Environment_ToriiGate.gltf` (wrong style) |

### Timepiece models (target: `models/timepieces/`)

**Updated 2026-05-10 after Sketchfab CC-BY recon** (`phase3_timepieces_recon.md`). 10 of 14 have verified Sketchfab picks (free CC-BY, requires Sketchfab login + manual download). 4 remain custom Blender work. All Sketchfab URLs use `/3d-models/none-<uid>` shortform which 301-redirects to canonical slug.

| File | Status | Source plan | Used in scene(s) | Fit-on-arrival | Notes |
|---|---|---|---|---|---|
| `hourglass.glb` | 🟦 USER | Sketchfab: [Lowpoly stylized hourglass](https://sketchfab.com/3d-models/none-986133a0708f4b49b96929634e2b0290) by Ragdoll | | | 1,634 faces, CC-BY. Login + glTF download |
| `kitchen_clock.glb` | 🟦 USER | Sketchfab: [PSX-Style Vintage Wall Clocks](https://sketchfab.com/3d-models/none-9dc475ad89874ccc9d2b199d0ec00806) by Icevanilla | | | 1,228 faces, CC-BY. PSX low-poly cottage fit |
| `mantel_clock.glb` | 🟦 USER | Sketchfab: [Mantel clock lowpoly](https://sketchfab.com/3d-models/none-bf7bc1cfa4ca41bbb1b06b8aabc31352) by Vyacheslav_SD | | | 922 faces, CC-BY. Direct title match |
| `grandfather_clock.glb` | 🟦 USER | Sketchfab: [Grandfather Clock](https://sketchfab.com/3d-models/none-a4e53f9ca8d748068d98731087f90ea9) by Gabrielle Speace | | | 3,398 faces, CC-BY |
| `digital_clock.glb` | 🟦 USER | Sketchfab: [Digital Radio Clock](https://sketchfab.com/3d-models/none-23b2d0e81d414836877c555e5b5fc18d) by NoMoreFeelings | | | 300 faces, CC-BY. Or quick custom Blender (~5 min) |
| `cuckoo_clock.glb` | 🟦 USER | Sketchfab: [Cuckoo Clock](https://sketchfab.com/3d-models/none-695e5fe669a04ad987a395539e02a8c0) by FFeller | | | 4,052 faces, CC-BY |
| `sundial.glb` | 🟦 USER | Sketchfab: [CT4012 - Clock: Sundial](https://sketchfab.com/3d-models/none-629cd7e55be145cf8fad5735af63ea33) by J. Pennell | | | 1,608 faces, CC-BY |
| `holo_clock.glb` | 🟦 USER | Sketchfab: [Futuristic Clock](https://sketchfab.com/3d-models/none-69d9539d1df24a06a77dbd7a115336bf) by s4306311 | | | 1,336 faces, CC-BY. Pair with Binbun hologram shader for full effect |
| `salvaged_clock.glb` | 🟦 USER | Sketchfab: [Rusty Broken Clock](https://sketchfab.com/3d-models/none-c5ce9aca654c49a490e492d5d02aa6ad) by @blue.blender.print | | | 8,610 faces, CC-BY. Direct match — perfect for Fallout |
| `crt_readout.glb` | 🟦 USER | Sketchfab: [Retro CRT Computer (1990s)](https://sketchfab.com/3d-models/none-ea9faf1298d24497b916c27a4ea38636) by MadeByYeshe | | | 2,416 faces, CC-BY |
| `clepsydra.glb` | 🟦 CUSTOM | **Custom Blender — no Sketchfab match** | | | 🔴 hero piece. Sketchfab has 0 acceptable clepsydra results |
| `astronomical_clock.glb` | 🟦 CUSTOM | **Custom Blender (~3 hrs) — Sketchfab options too primitive** | | | 🔴 hero piece. Only 388-face find on Sketchfab; brief deserves real geometry |
| `incense_clock.glb` | 🟦 CUSTOM | **Custom Blender — no Sketchfab match** | | | 🔴 hero piece. Sketchfab "incense burner" returns ceremonial burners, not timekeeping |
| `pillar_clock.glb` | 🟦 CUSTOM | **Custom Blender — no Sketchfab match** | | | 🔴 niche Edo wadokei. Zero Sketchfab results |

### SFX gaps (target: `audio/sfx/`)

**Per-slot candidate shortlist**: `sonniss_audio_shortlist.md` (2026-05-27) — narrows 605 Sonniss WAVs to specific candidates per slot. Sonniss covers 7 of 13 directly; 4 need Freesound (cat_purr/hiss/chirp, chime_westminster); 2 easier on Freesound than isolating from Sonniss (chime_cathedral_bell, chime_cuckoo).

| File | Status | Source plan | Used in scene(s) | Notes |
|---|---|---|---|---|
| `cat_meow.ogg` | 🟦 | Freesound | | |
| `cat_purr.ogg` | 🟦 | Freesound | | Loopable |
| `cat_hiss.ogg` | 🟦 | Freesound | | |
| `cat_chirp.ogg` | 🟦 | Freesound | | |
| `monster_chase.ogg` | 🟦 | Freesound | | Loopable |
| `chime_water_drip.ogg` | 🟦 | Freesound | | For clepsydra |
| `chime_digital.ogg` | 🟦 | Freesound or Kenney UI Audio | | For digital_clock |
| `chime_westminster.ogg` | 🟦 | Freesound | | For grandfather_clock |
| `chime_holo_pulse.ogg` | 🟦 | Freesound or Binbun (TIER B) | | For holo_clock |
| `chime_cathedral_bell.ogg` | 🟦 | Freesound | | For astronomical_clock |
| `chime_incense_clink.ogg` | 🟦 | Freesound | | For incense_clock |
| `chime_cuckoo.ogg` | 🟦 | Freesound | | For cuckoo_clock |
| `chime_bunker_static.ogg` | 🟦 | Freesound | | For salvaged_clock / crt_readout |

### Music — gaps after TIER B + C

PixelLoops + Airyluvs cover 6 of 8 themes. Remaining gaps:

| File | Status | Source plan | Notes |
|---|---|---|---|
| `ambient_greco_roman.ogg` | 🟦 | Pixabay Music search "harp ambient classical" or Suno AI generation | No dedicated paid pack found in recon |
| `ambient_modern_loft.ogg` | 🟦 | Pixabay Music search "lofi chill" / "minimal electronic" | Calm Menu is interim substitute |

### Implementation assets

| File | Status | Source | Notes |
|---|---|---|---|
| `assets/fonts/Cinzel-VariableFont_wght.ttf` | 🟨 | Google Fonts via GitHub mirror (raw.githubusercontent.com/google/fonts) | Variable weight font, OFL licence included alongside |
| `assets/fonts/Lora-VariableFont_wght.ttf` | 🟨 | Google Fonts via GitHub mirror | Plus `Lora-Italic-VariableFont_wght.ttf`. OFL licence included |
| `assets/icon/app_icon.png` (1024²) | 🟦 | Custom Figma — Cinzel + marble texture | Greco-Roman themed |
| `assets/store/feature_graphic.png` (1024×500) | 🟦 | Custom Figma | Same palette as icon |
| `assets/store/screenshot_*.png` (1290×2796 ×5) | 🟦 | In-app capture once Greco-Roman is kitted | Not actionable yet |

### Texture splitting

| Status | Notes |
|---|---|
| ✅ Already done | `textures/{theme}/` populated with ~37 PNGs matching the spec's ~36 target. Greco/Modern/Victorian/Sci-Fi/Gothic/Ryokan/Cottage have 4 each; Fallout has 9. |

---

## Out-of-scope but noted

- **Music for Victorian/scholarly mood** — no perfect dedicated paid pack found. PixelLoops Calm Menu is the closest. Could commission or curate from Sonniss bundles. Revisit when scoring becomes relevant.
- **Music for Greco-Roman** — same situation; using Calm Menu as substitute.
- **Custom-modeled architecture** — Path D from `decisions.md`. Out of asset-acquisition scope but the only way to truly hit Journey/ABZÛ visual target without paid kits.
- **Mobile LOD strategy** — Poly Haven models are 17K–96K tris each. Will need LOD setup or selective use on mobile target. Track as engineering task, not asset acquisition.

## License notes worth keeping
- **Sonniss UUL** — royalty-free, no attribution, lifetime, but cannot resell raw files. Read full text at sonniss.com/gdc-bundle-license/ before shipping.
- **Synty One-Time** — royalty-free game distribution, 5 seats. Prohibited: NFT, metaverse-platform redistribution, AI training. No revenue cap.
- **KitBash3D Individual** — solo-developer only. Upgrade to Small Business if MindHause becomes a multi-person company. Cannot redistribute editable source.
- **Binbun** — CC0, no restrictions.
- **PixelLoops** — royalty-free for game embedding, no standalone music resale.
- **EffectBlocks (Bukkbeek)** — commercial OK, no pack resale. Verify Godot 4.0 compatibility (asset says 4.4+).
