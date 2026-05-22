# MindHause Asset Decisions

Synthesis of `recon_free.md` and `recon_premium.md`. This is the actionable shopping/download plan. Reasoning lives in the source recon files.

## Strategic framing

The recon revealed a binary choice. The free tier solves **materials, shaders, VFX, and SFX** completely. It does **NOT** solve **modular architecture geometry at the painterly target** — Quaternius/Kenney cap at flat-shaded low-poly (fit 3), which clashes with photoreal Poly Haven materials in the same room.

This forces a path decision:

| Path | Cost | Visual ceiling | Effort |
|---|---|---|---|
| **A. Free + low-poly** | $0 | "Polished mobile casual" — not Journey/ABZÛ | Low |
| **B. Free materials/shaders + cheap paid Synty packs** | ~$90–$310 | Stylized indie 3D unified by toon shader | Low–medium |
| **C. Free materials/shaders + KitBash3D flagship kits** | ~$585–$900 | Approaches reference (Journey/Witness/ABZÛ) for 2–3 themes | Medium (FBX import work) |
| **D. Free materials + custom Blender geometry** | $0 | Could hit the target exactly | High (modeling work, out of scope) |

**Recommendation**: regardless of which path is chosen later, **execute TIER A first** (free essentials) — it's value-neutral and unblocks visual progress on every room. The Synty/KB3D decision can wait until a single room is fully kitted out and the result evaluated.

---

## TIER A — Free essentials (do this first)

Total cost: **$0**. Total estimated download size: **~10–12 GB**. All licences confirmed CC0 or equivalent royalty-free with no attribution required.

| Asset | Source | Why | Size est. |
|---|---|---|---|
| **Marble 01** | [polyhaven.com/a/marble_01](https://polyhaven.com/a/marble_01) | Greco-Roman default — 306k downloads, full PBR set, 8K | ~50–200 MB |
| **Wood Floor** | [polyhaven.com/a/wood_floor](https://polyhaven.com/a/wood_floor) | Modern Loft default — 269k downloads, 8K | ~50–200 MB |
| **Dark Wood** | [polyhaven.com/a/dark_wood](https://polyhaven.com/a/dark_wood) | Victorian scholar wood — 205k downloads, 4K | ~30–100 MB |
| **Castle Brick 01** | [polyhaven.com/a/castle_brick_01](https://polyhaven.com/a/castle_brick_01) | Gothic + cellar walls — 8K | ~50–200 MB |
| **Painted Plaster Wall** | [polyhaven.com/a/painted_plaster_wall](https://polyhaven.com/a/painted_plaster_wall) | Modern + Greco walls — 16K | ~80–300 MB |
| **Floral Jacquard** | [polyhaven.com/a/floral_jacquard](https://polyhaven.com/a/floral_jacquard) | Victorian upholstery — 4K | ~20–80 MB |
| **Brown Leather** | [polyhaven.com/a/brown_leather](https://polyhaven.com/a/brown_leather) | Victorian armchair / book bindings — 8K | ~50–200 MB |
| **Japanese Sycamore** | [polyhaven.com/a/japanese_sycamore](https://polyhaven.com/a/japanese_sycamore) | Ryokan walls — 4K | ~30–100 MB |
| **Herringbone Parquet** | [polyhaven.com/a/herringbone_parquet](https://polyhaven.com/a/herringbone_parquet) | Victorian study floor — 16K | ~80–300 MB |
| **Wood Floor Worn** | [polyhaven.com/a/wood_floor_worn](https://polyhaven.com/a/wood_floor_worn) | Cottage floor — 4K | ~30–100 MB |
| **Marble 012** | [ambientcg.com/view?id=Marble012](https://ambientcg.com/view?id=Marble012) | Greco accent (white polished) — 403k downloads | ~30–150 MB |
| **Travertine 001** | [ambientcg.com/view?id=Travertine001](https://ambientcg.com/view?id=Travertine001) | Greco atrium (historically accurate) | ~30–150 MB |
| **Bricks 097** | [ambientcg.com/view?id=Bricks097](https://ambientcg.com/view?id=Bricks097) | Workshop / cellar / cottage exterior | ~30–150 MB |
| **Potted Plant 04** (succulent) | [polyhaven.com/a/potted_plant_04](https://polyhaven.com/a/potted_plant_04) | Mobile-safe plant (6K tris) — drop in any room | ~20–80 MB |
| **Calathea Orbifolia 01** | [polyhaven.com/a/calathea_orbifolia_01](https://polyhaven.com/a/calathea_orbifolia_01) | Ryokan + cottage indoor plant — 17K tris | ~40–150 MB |
| **Sonniss GDC 2026 Bundle** | [sonniss.com/gameaudiogdc](https://sonniss.com/gameaudiogdc/) | Ambient + UI + foley SFX — 7.47 GB. Browser download (WebFetch blocked) | ~7.5 GB |
| **Ultimate Toon Shader** (CC0) | [godotshaders.com/shader/ultimate-toon-shader/](https://godotshaders.com/shader/ultimate-toon-shader/) | THE painterly look — replaces Manus's $25 paid recommendation | text |
| **Stylized Sky With Clouds** (CC0) | [godotshaders.com/shader/stylized-sky-shader-with-clouds/](https://godotshaders.com/shader/stylized-sky-shader-with-clouds/) | Skybox with day/night | text |
| **Water with Caustics** (CC0) | [godotshaders.com/shader/water-with-caustics/](https://godotshaders.com/shader/water-with-caustics/) | Greco fountains + Ryokan ponds | text |
| **Distance Gradient Fog 4.3+** (MIT) | [godotshaders.com/shader/distance-gradient-fog-4-3/](https://godotshaders.com/shader/distance-gradient-fog-4-3/) | Among Trees–style atmospheric depth | text |
| **Procedural Stained-Glass** (MIT) | [godotshaders.com/shader/procedural-stained-glass-shader/](https://godotshaders.com/shader/procedural-stained-glass-shader/) | Gothic windows | text |
| **Procedural Torch & Candle** (CC0) | [godotshaders.com/shader/procedural-torch-candle-shader-fire-smoke-sparks/](https://godotshaders.com/shader/procedural-torch-candle-shader-fire-smoke-sparks/) | Gothic + Victorian + Cottage candles, no particles needed | text |
| **Retro Parchment Paper** (CC0) | [godotshaders.com/shader/retro-parchment-paper/](https://godotshaders.com/shader/retro-parchment-paper/) | Symbolic-prop scrolls/books, in-world parchment | text |

### TIER A geometry — accept the compromise temporarily

If you want any 3D models in rooms today (vs. CSG), download **only** these — they're the least-bad free placeholders:

| Asset | Source | Use as |
|---|---|---|
| Quaternius Fantasy Props MegaKit | [quaternius.com/packs/fantasypropsmegakit.html](https://quaternius.com/packs/fantasypropsmegakit.html) | **Symbolic props placeholder** (books/scrolls/keys/jars/candles/statues). Replace later. |
| Kenney Furniture Kit (140 files) | [kenney.nl/assets/furniture-kit](https://kenney.nl/assets/furniture-kit) | **Furniture placeholder**. Replace per-theme later. |
| Quaternius Sushi Restaurant Kit | [quaternius.com/packs/sushirestaurantkit.html](https://quaternius.com/packs/sushirestaurantkit.html) | Tightest free Ryokan props |

Skip Quaternius/Kenney architecture kits — they're worse than continuing with CSG that gets clad in Poly Haven materials.

---

## TIER B — Cheap paid (~$89 unlocks the painterly look)

This buys what the free tier can't: a coherent painterly post-process and ambient music. **Highest dollar leverage on the entire list.**

| Asset | Source | Price | Why |
|---|---|---|---|
| **Binbun Effects Collection Vol. 1** | [binbun3d.itch.io/effects-collection-vol1](https://binbun3d.itch.io/effects-collection-vol1) | **$26.25** | 22 toon-material presets + 24 sky presets + 300+ VFX, CC0. Closes the gap between low-poly Synty and the painterly target. |
| PixelLoops Fantasy Tavern Music | [pixelloops.itch.io/fantasy-tavern-music-pack-12-cozy-rpg-loops-wav-mp3](https://pixelloops.itch.io/fantasy-tavern-music-pack-12-cozy-rpg-loops-wav-mp3) | $4.49 | Cottage / foyer ambient |
| PixelLoops Calm Menu Music | [pixelloops.itch.io/main-menu-music-pack-10-calm-game-menu-loops-wav-mp3](https://pixelloops.itch.io/main-menu-music-pack-10-calm-game-menu-loops-wav-mp3) | $4.49 | Library / Victorian / scholarly |
| PixelLoops Dark Ambient | [pixelloops.itch.io/game-loops-vol4-dark-ambient-mystery](https://pixelloops.itch.io/game-loops-vol4-dark-ambient-mystery) | $4.49 | Cellar / Gothic / Fallout |
| PixelLoops Sci-Fi Ambient | [pixelloops.itch.io/sci-fi-ambient-music-pack-20-loopable-tracks-for-games](https://pixelloops.itch.io/sci-fi-ambient-music-pack-20-loopable-tracks-for-games) | $4.49 | Sci-Fi rooms |
| Synty POLYGON - Samurai Pack | [syntystore.com/products/polygon-samurai-pack](https://syntystore.com/products/polygon-samurai-pack) | $15.00 | Ryokan modular kit (best price/coverage) |
| Synty POLYGON - Adventure Pack | [syntystore.com/products/polygon-adventure-pack](https://syntystore.com/products/polygon-adventure-pack) | $15.00 | Cottage + garden filler |
| Synty POLYGON - Knights Pack | [syntystore.com/products/polygon-knights-pack](https://syntystore.com/products/polygon-knights-pack) | $15.00 | Gothic-ish modular castle |
| **TOTAL** | | **$89.21** | |

---

## TIER C — Worth considering (~$220 add-on, brings cumulative to ~$310)

If TIER A+B leaves themes feeling thin, these anchor specific themes.

| Asset | Source | Price | Why |
|---|---|---|---|
| Synty POLYGON - Town Pack | [syntystore.com/products/polygon-town-pack](https://syntystore.com/products/polygon-town-pack) | $25.00 | Cottage exterior + ships native Godot 4.5.1 project |
| Synty POLYGON - Office Pack | [syntystore.com/products/polygon-office-pack](https://syntystore.com/products/polygon-office-pack) | $25.00 | Modern Loft (use this, NOT Heist) |
| Synty POLYGON - Meadow Forest Biome | [syntystore.com/products/polygon-meadow-forest-nature-biome](https://syntystore.com/products/polygon-meadow-forest-nature-biome) | $27.50 | Garden + cottage nature, Ghibli-leaning |
| KitBash3D - Medieval Market | [kitbash3d.com/products/medieval-market](https://kitbash3d.com/products/medieval-market) | $95.00 | Cheapest KB3D — proves the workflow before bigger commits |
| Airyluvs Japanese Music Collection | [airyluvs.itch.io/japanese-style-game-music-collection](https://airyluvs.itch.io/japanese-style-game-music-collection) | $49.00 | Real shamisen/koto/shakuhachi for Ryokan |

---

## TIER D — Flagship architecture (~$585 add-on, brings cumulative to ~$900)

Only after TIER A–C is integrated and you've decided which 2–3 themes deserve premium treatment.

| Asset | Source | Price | Why |
|---|---|---|---|
| KitBash3D - Elysium | [kitbash3d.com/products/elysium](https://kitbash3d.com/products/elysium) | $195 | Greco-Roman flagship — closest single product to Journey/ABZÛ aesthetic |
| KitBash3D - Victorian | [kitbash3d.com/products/victorian](https://kitbash3d.com/products/victorian) | $145 | Only credible Victorian premium kit |
| KitBash3D - Shogun | [kitbash3d.com/products/shogun](https://kitbash3d.com/products/shogun) | $245 | Definitive Ryokan — 234 models |

**Alternative**: Cargo subscription [kitbash3d.com/pages/pricing](https://kitbash3d.com/pages/pricing) at **$59/mo / $708/yr** unlocks the entire KB3D library. Better economics if buying 4+ kits. Also try the **free Cargo tier (100+ samples, no card)** before any paid commit.

---

## Theme × category matrix (final picks)

Cell entries: best-fit recommendation. (T-A) = TIER A free, (T-B) = TIER B cheap paid, etc.

| Theme | Architecture | Furniture | Props | Materials | Plants | Music | Shaders/VFX |
|---|---|---|---|---|---|---|---|
| Greco-Roman | CSG + Marble 01 (T-A); Elysium (T-D) | Kenney Furniture (T-A) | Quaternius Fantasy Props (T-A) | Marble 01, Marble 012, Travertine 001 (T-A) | Calathea (T-A) | PixelLoops Calm Menu (T-B) | Toon + Sky + Water (T-A) |
| Victorian | CSG + Castle Brick (T-A); KB3D Victorian (T-D) | Kenney Furniture + Floral Jacquard upholstery (T-A) | Quaternius Fantasy Props (T-A) | Dark Wood, Herringbone Parquet, Brown Leather (T-A) | Potted Plant 04 (T-A) | PixelLoops Calm Menu (T-B) | Toon + Candle shader (T-A) |
| Modern Loft | CSG + Painted Plaster + Wood Floor (T-A); Synty Office (T-C) | Kenney Furniture (T-A) | Quaternius Fantasy Props minimal (T-A) | Wood Floor, Painted Plaster, Plaster 001 (T-A) | Potted Plant 02, Calathea (T-A) | PixelLoops Calm Menu (T-B) | Toon + Sky (T-A) |
| Sci-Fi | CSG + clean materials; Synty Sci-Fi City (T-C optional) | Kenney Furniture stripped (T-A) | Quaternius Sci-Fi Essentials (T-A) | Plaster 001 + emission glow (T-A) | — | PixelLoops Sci-Fi Ambient (T-B) | Toon + Hologram from Binbun (T-B) |
| Gothic | CSG + Castle Brick + Stained Glass (T-A); KB3D Dark Fantasy (T-D alt) | Kenney Furniture sparse (T-A) | Quaternius Fantasy Props (T-A) | Castle Brick, Church Bricks, Dark Wood (T-A) | — | PixelLoops Dark Ambient (T-B) | Stained Glass + Candle + Fog (T-A) |
| Ryokan | CSG + Japanese Sycamore; Synty Samurai (T-B); KB3D Shogun (T-D) | Sushi Restaurant Kit + Kenney (T-A) | Sushi Restaurant Kit (T-A) | Japanese Sycamore, Sakura Bark (T-A) | Calathea, Anthurium (T-A) | Airyluvs Japanese (T-C) | Toon + Water + Sky (T-A) |
| Cottage | CSG + Wood Floor Worn + Weathered Planks (T-A); Synty Town (T-C) | Kenney Furniture (T-A) | Quaternius Fantasy Props (T-A) | Wood Floor Worn, Medieval Wood, Weathered Planks (T-A) | Potted Plant 02 + Meadow Forest (T-C) | PixelLoops Fantasy Tavern (T-B) | Toon + Candle + Fog (T-A) |
| Fallout | CSG + Bricks 097 + existing fallout PNGs (T-A) | Kenney Furniture distressed (T-A) | Quaternius Fantasy Props weathered (T-A) | Bricks 097, Worn Plaster, Weathered Planks (T-A) | — | PixelLoops Dark Ambient (T-B) | Toon + Fog (T-A) |

---

## Skip / corrections to the Manus list

The recon disproved several Manus claims. Don't waste time chasing these:

- ❌ **`binbun.itch.io/*`** URLs all 404 — the real handle is **`binbun3d.itch.io`**
- ❌ **`kitbash3d.com/products/gothic`** — Gothic kit was retired. Use Dark Fantasy ($145) or Ghost Realm ($245)
- ❌ **`syntystore.com/products/polygon-victorian`** — does not exist. Use Fantasy Kingdom ($175) or KB3D Victorian
- ❌ **`syntystore.com/products/polygon-shops`** — 404
- ❌ Sketchfab "Stylized Japanese Village Environment by IanaM" — fabricated. Real IanaM listings are on Fab.com (props + house, separate, opaque pricing)
- ❌ POLYGON Heist for Modern Loft — wrong vibe (crime thriller). Use Office Pack
- ❌ POLYGON Apocalypse Wasteland for Fallout — Mad Max framing fights the brief
- ❌ KB3D Wasteland — same issue
- ❌ KB3D Ghost Realm — leans haunted-mansion which the brief rejects
- ❌ Manus prices in general — Synty $15–$175 (not flat $30); KB3D $95–$245 (not "$199+"); Binbun PWYW $3.75–$4.49 (not $20–$25)
- ⚠️ **Manus drop v2: POLYGON Fantasy Dungeon Map presented as a $9.99 standalone Victorian-Scholar pick** — it IS $9.99 and the URL works (`/products/polygon-fantasy-dungeon-map`), BUT it's an *expansion* requiring the **POLYGON Dungeon Pack base ($75)**, so true buy-in is **~$85**, not $10. Also: it's a fantasy-dungeon library (sarcophagi, suits of armour, crypts) — not Victorian wood-panelled scholar. Manus's framing was misleading on both price and theme fit.

---

## Recommended sequencing

1. **Download TIER A** (~10 GB free). Go to `tracking.md` and check off each as it lands in the project.
2. **Apply Poly Haven materials to one room** (suggest Foyer or Library). Add Ultimate Toon Shader. Evaluate.
3. **Decide Path A vs B vs C** based on how that one room looks.
4. **If continuing**: buy TIER B ($89). Apply Binbun toon presets + ambient music. Re-evaluate.
5. **TIER C and TIER D**: only after at least three rooms are at "shippable" quality with TIER A+B.

Update `tracking.md` continuously as downloads happen and assets land in the project — that's the source of truth for "where each asset went and how well it met requirements."

---

## Manus drop v2 verification (2026-05-10)

Two specific claims from a follow-up Manus drop were spot-checked against live storefronts.

### Claim 1 — Synty POLYGON Fantasy Dungeon Map for Victorian Scholar

- **Manus claim**: ~$9.99 standalone pack at `syntystore.com/products/polygon-fantasy-dungeon-map` containing "modular wood-panelled walls, library bookshelves, and secret study elements" fitting the Victorian Scholar theme.
- **Verified**: URL resolves. Price is **$9.99** (50% off $19.99) — accurate. BUT the page explicitly states it is an **expansion add-on requiring the separate POLYGON Dungeon Pack** (verified at `/products/polygon-dungeon-pack` — currently **$75**, 50% off $149.99). True buy-in is ~$85, not $10. Contents are 57 prefabs across eight zones (library, boss arena, **crypt, sarcophagus, suits of armour, tombs, shrine**) — it is a fantasy dungeon with a library zone, not a Victorian wood-panelled scholar set. Aesthetic is the standard Synty flat-shaded low-poly. **Fit for Victorian Scholar painterly target: 2/5** (cohort is fantasy-dungeon, not Victorian; per prior recon Synty caps at 3 for painterly intent and this one skews further off-brief).
- **Action**: **Add to skip list.** Do not adopt. The existing recommendation for Victorian (KB3D Victorian $145 in TIER D, or Synty Fantasy Kingdom $175 as low-poly fallback) stands. If $85 is the budget for low-poly Victorian filler, **POLYGON Knights Pack ($15)** is closer in vibe and standalone.

### Claim 2 — KitBash3D Victorian kit contents

- **Manus claim**: Kit at `kitbash3d.com/products/victorian` includes "University Headquarters", "Library of Parliament", and "Nobleman Mansion"; price $145.
- **Verified**: All three building names confirmed present in the live model list. Price is **$145** (Individual licence) — accurate. Full named structures include: University Headquarters, Library of Parliament, Nobleman Mansion, Westminster (Facade / Main Entrance / Corner / Hall / Tower), Tower Bridge, Cathedral, Clock Tower, Parliament House, House of Congress, Town Hall, Townhomes (incl. Large), Tower A/B/C, Downtown Business Block A/C, Restaurant Block, Multi-Level Block, Housing Block, Victorian Entrance, plus chimneys A–G, lanterns, fences, brick walls, fabric awnings, walkways. 103 models total. Manus's description is accurate (no fabrication this time).
- **Action**: **No change.** TIER D entry for KitBash3D Victorian remains the correct recommendation for the Victorian Scholar theme.

---

## Shopping list spec — additional categories

The original asset shopping list (`docs/asset_recon_2026-05-10/requirements.md` was derived from the brief) covers these sub-categories at finer per-item resolution than the recon's theme×category matrix. This section maps each missing item to a verified source where one exists.

Current project state by item count: **59/126 (47%)** — cats 8/8, textures 37/36, base SFX 14/19, everything else 0.

### Task object models (0/10) — mostly covered free

All 10 items are in scope of the Quaternius Fantasy Props MegaKit ([fantasypropsmegakit.html](https://quaternius.com/packs/fantasypropsmegakit.html), CC0, 200+ models on 4 atlases). Per-item:

| File | Source | Notes |
|---|---|---|
| `scroll.glb` | Quaternius Fantasy Props | Direct match |
| `book.glb` | Quaternius Fantasy Props | Direct match |
| `candle.glb` | Quaternius Fantasy Props | Direct match |
| `statue.glb` | Quaternius Fantasy Props | Bust/figurine in pack |
| `letter.glb` | Quaternius Fantasy Props | Envelope-shaped item present |
| `jar.glb` | Quaternius Fantasy Props | Glass jar / potion bottle |
| `key.glb` | Quaternius Fantasy Props | Ornate key included |
| `plant.glb` | Poly Haven [potted_plant_04](https://polyhaven.com/a/potted_plant_04) (already in TIER A) | Mobile-safe 6K tris succulent |
| `blueprint.glb` | **Custom Blender** | ~10 min — flat plane with subdivision + simple bend modifier, paint blueprint texture |
| `post_it.glb` | **Custom Blender** | ~5 min — quad with single-corner bend modifier |

Visual fit warning: Quaternius props are flat-shaded low-poly (fit 3 vs painterly target). Acceptable as placeholder; revisit per the painterly post-process Path B/C later.

### Furniture models (0/12) — mostly covered free, vendor known but no per-piece audit

Kenney Furniture Kit ([kenney.nl/assets/furniture-kit](https://kenney.nl/assets/furniture-kit), CC0, 140 files) is the primary free source. Quaternius Medieval Village ([medievalvillagemegakit.html](https://quaternius.com/packs/medievalvillagemegakit.html)) covers more rustic pieces. Synty Town Pack and Office Pack ($25 each) are TIER C upgrades.

| File | Likely source (unverified per-piece) | Confidence |
|---|---|---|
| `desk.glb` | Kenney Furniture Kit | 🟢 |
| `bookshelf.glb` | Kenney Furniture Kit | 🟢 |
| `table_round.glb` | Kenney Furniture Kit | 🟢 |
| `bed.glb` | Kenney Furniture Kit | 🟢 |
| `counter.glb` | Kenney Furniture Kit | 🟢 |
| `workbench.glb` | Quaternius Medieval Village (blacksmith bench) | 🟡 |
| `display_case.glb` | Kenney Furniture Kit (cabinet, may need glass material rework) | 🟡 |
| `notice_board.glb` | Quaternius Medieval Village (or custom — flat board with cork material) | 🟡 |
| `pedestal.glb` | Quaternius Modular Dungeon (column base) | 🟡 |
| `stone_bench.glb` | Quaternius Modular Dungeon | 🟡 |
| `stone_table.glb` | Quaternius Modular Dungeon (altar piece) | 🟡 |
| `column_ionic.glb` | **Custom Blender** or Quaternius Modular Dungeon (check for ionic capital) | 🔴 |

**Recommended workflow**: download both Kenney Furniture Kit + Quaternius Medieval Village, open in Blender, audit which exact pieces map to the file list, then export with unified scale + single-albedo materials. ~2 hr task. Fits the same Path A/B/C compromise as architecture geometry.

### Timepiece models (0/14) — biggest unrecon'd gap

This category was not surfaced in the original Manus brief and was not audited by the recon agents. **Specific recommendations are speculative until a verification pass is done.** Probable best paths per item:

| File | Probable source | Confidence | Notes |
|---|---|---|---|
| `hourglass.glb` | Quaternius Fantasy Props | 🟢 | Almost certainly present in this pack |
| `kitchen_clock.glb` | Kenney Furniture Kit (wall clock) | 🟡 | Probably |
| `mantel_clock.glb` | Quaternius Fantasy Props or Kenney | 🟡 | Generic mantel clock common in props packs |
| `grandfather_clock.glb` | Sketchfab CC0 search | 🟡 | "low poly grandfather clock" — common request, several free options likely |
| `digital_clock.glb` | **Custom Blender** | 🟢 | 5 min — rectangular box with emissive plane on front |
| `cuckoo_clock.glb` | Sketchfab paid (~$5–15) or custom | 🔴 | Distinctive shape — generic free options unlikely to read as cuckoo |
| `sundial.glb` | Custom Blender or Sketchfab | 🟡 | Simple disc + gnomon, ~30 min Blender work |
| `clepsydra.glb` (water clock) | **Custom Blender** | 🔴 | Bespoke shape — vase + tube + basin assembly |
| `holo_clock.glb` | **Custom Blender** + sci-fi shader | 🟢 | Single quad with holographic shader (Binbun Effects Collection has hologram preset) |
| `astronomical_clock.glb` | **Custom Blender** | 🔴 | Complex hero piece — concentric rings, zodiac plate, gears. Budget ~3 hrs. Worth more polycount per the spec. |
| `incense_clock.glb` | **Custom Blender** | 🔴 | Bespoke — wood plate with channels + small weights |
| `pillar_clock.glb` | Sketchfab / custom | 🔴 | Edo-period Japanese pillar clock — niche, likely custom |
| `salvaged_clock.glb` | Quaternius Sci-Fi Essentials or Kenney | 🟡 | Cracked/distressed analog clock — distress in shader/texture pass |
| `crt_readout.glb` | Quaternius Sci-Fi Essentials (animated screens) | 🟡 | Sci-Fi Essentials Kit explicitly includes animated screens |

**Verdict**: ~5 of 14 likely free-sourceable, ~3 from existing kits already in TIER A, ~6 require custom Blender work. The hero pieces (astronomical, clepsydra, incense, pillar, cuckoo) are intentional thematic anchors per the spec — custom modeling is appropriate.

**If this category becomes a priority**, dispatch a small recon pass against Sketchfab CC0 + itch.io for grandfather clock / cuckoo / sundial low-poly options. ~30 min agent run.

### SFX gaps (13 missing of 27)

| File | Source | Notes |
|---|---|---|
| `cat_meow.ogg` | Freesound (CC0/CC-BY) | "Cat purr meow.wav" by mukuh and similar — well-stocked category |
| `cat_purr.ogg` | Freesound | Loopable purr — multiple options |
| `cat_hiss.ogg` | Freesound | Common search term |
| `cat_chirp.ogg` | Freesound | "catpurrchirp.m4a" by dreamstobecome and similar |
| `monster_chase.ogg` | Freesound | "tension drone loop", "creature chase ambient" |
| `chime_water_drip.ogg` | Freesound | "water drop", "water drip basin" |
| `chime_digital.ogg` | Freesound or Kenney UI Audio | Soft electronic beep |
| `chime_westminster.ogg` | Freesound | "Westminster chimes" — abundant |
| `chime_holo_pulse.ogg` | Freesound or Binbun Effects Collection (TIER B) | Sci-fi pulse tone |
| `chime_cathedral_bell.ogg` | Freesound | "church bell toll", "cathedral bell" |
| `chime_incense_clink.ogg` | Freesound | "small wood tap", "metal on wood" |
| `chime_cuckoo.ogg` | Freesound | "cuckoo bird call" |
| `chime_bunker_static.ogg` | Freesound | "radio static burst" |

**Workflow**: ~1 hr Freesound audition + Audacity processing (trim, normalise, fade, export `.ogg`). All free CC0/CC-BY. No URLs verified per-file — Freesound's search is reliable for these terms.

### Ambient music gaps (3–4 of 8 themes)

TIER B PixelLoops covers 4 themes verified ($4.49 each):

| Theme | Coverage | Source |
|---|---|---|
| Cottage | ✅ TIER B | PixelLoops Fantasy Tavern |
| Victorian | ✅ TIER B | PixelLoops Calm Menu |
| Library/Foyer | ✅ TIER B | PixelLoops Calm Menu |
| Cellar / Gothic / Fallout | ✅ TIER B | PixelLoops Dark Ambient |
| Sci-Fi | ✅ TIER B | PixelLoops Sci-Fi Ambient |
| Ryokan | ✅ TIER C | Airyluvs Japanese ($49) |
| **Greco-Roman** | 🔴 Gap | Calm Menu is a substitute. No dedicated paid pack found. Suno AI generation or Pixabay "harp ambient classical" search recommended. |
| **Modern Loft** | 🔴 Gap | Calm Menu is a substitute. Pixabay "lofi chill" / "minimal electronic background" search. |

**Free alternative for any/all themes**: Pixabay Music ([pixabay.com/music](https://pixabay.com/music)) — search keywords are listed in the original shopping list spec. ~30 min/theme to find + loop-edit. No specific tracks verified; vendor reliability is high.

### Implementation tier (fonts + icon + textures)

| Item | Status | Source |
|---|---|---|
| **Texture splitting** | ✅ Already done | `textures/{theme}/` populated, ~37 files matching the spec's ~36 |
| **Cinzel font** | 🟦 Pending | [fonts.google.com/specimen/Cinzel](https://fonts.google.com/specimen/Cinzel) — direct download, free, ~2 min |
| **Lora font** | 🟦 Pending | [fonts.google.com/specimen/Lora](https://fonts.google.com/specimen/Lora) — direct download, free, ~2 min |
| **App icon (1024×1024)** | 🟦 Custom design | Figma + Cinzel + already-owned Greco-Roman marble texture. ~30 min iterative. No vendor needed. |
| **Play Store feature graphic (1024×500)** | 🟦 Custom design | Same toolchain. ~20 min. |
| **App Store screenshots (1290×2796 × 5)** | 🟦 Render in-app | Capture from a fully-themed Greco-Roman scene once visual progress is meaningful. Not actionable until rooms are kitted. |

### Updated sequencing recommendation

Front-load the items where source is verified and effort is low:

1. **TIER A free downloads** (already in the original sequencing) — materials, shaders, audio bundle
2. **Quaternius Fantasy Props MegaKit** — knocks out 7 of 10 task objects + the hourglass + likely several other timepiece building blocks
3. **Kenney Furniture Kit** — knocks out ~5 of 12 furniture items, audit for the rest
4. **Freesound SFX audition** (~1 hr) — closes the 13-item SFX gap
5. **Google Fonts** (~5 min) — Cinzel + Lora drop in
6. **Custom Blender batch** — blueprint, post_it, column_ionic, digital_clock, sundial (~2–3 hrs total for all five trivial items)
7. THEN evaluate remaining timepieces (the 5 hero pieces) for prioritised custom modeling vs Sketchfab hunt
