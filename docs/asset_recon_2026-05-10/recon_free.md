# MindHause Free / CC0 Asset Recon

Compiled 2026-05-10 by the recon agent. Verifies the Manus 2026-05-09 candidate set against actual vendor pages and adds missed candidates. URLs are confirmed via WebFetch / search results unless explicitly flagged "UNVERIFIED".

Fit scoring (1-5):
- 5 = Journey/ABZÛ/Ghibli — buy/use it
- 4 = stylized realism, fits well
- 3 = usable but generic stylized
- 2 = leans low-poly / cartoony, would need rework
- 1 = rejected

---

## 1. Quaternius — quaternius.com

**Coverage:** Excellent breadth for free 3D. Every Manus-flagged megakit verified. The catch: Quaternius is **flat-shaded low-poly with palette-atlas textures**. Beautiful and cohesive within the style, but it is unambiguously "Quaternius style" — soft pastel low-poly. That style decision dominates whatever you put it in.

**Aesthetic verdict (honest):** Quaternius is not Journey/Firewatch. It is closer to Crossy Road / Among Us / mobile-casual. The Ghibli claim Manus made about Stylized Nature MegaKit is generous — it's stylized, but it's flat-shaded low-poly stylized, not painterly stylized. **Treat Quaternius as the "blockout / placeholder / mobile fallback" tier**, not the final art.

**Gotchas:**
- All packs ship FBX/OBJ/Blend — newer megakits (Fantasy Props, Stylized Nature, Medieval Village, Sci-Fi Essentials) also ship glTF and explicitly list Godot 4.3+ implementation in the **Source** tier. Source is paid (Patreon).
- The free tier is the "Standard" download — 60-70% of models. Pro tier adds 30-40% more. Source tier (paid) adds shaders + engine projects.
- File sizes are not published anywhere on the pack pages.

| Asset | URL | Licence | Format | Size | Themes served | Fit | Notes |
|---|---|---|---|---|---|---|---|
| Fantasy Props MegaKit | https://quaternius.com/packs/fantasypropsmegakit.html | CC0 | FBX, OBJ, glTF, Blend | not listed | Victorian props, Cottage props, Greco-Roman vases, all symbolic objects (books/scrolls/keys/jars/candles) | 3 | 200+ models on 4 texture atlases. Best Quaternius pack for symbolic-prop coverage. Style is low-poly medieval, will read as "Among Us books" not "Witness scrolls". |
| Ultimate Furniture Pack | https://quaternius.com/packs/ultimatefurniture.html | CC0 | FBX, OBJ, Blend | not listed | Modern Loft furniture, generic interiors | 2 | Only 20 models, no glTF, untextured. Generic minimalist furniture. Thin compared to Kenney's Furniture Kit (140 files). Drop in favour of Kenney. |
| Stylized Nature MegaKit | https://quaternius.com/packs/stylizednaturemegakit.html | CC0 | FBX, OBJ, glTF, Blend | not listed | Garden, Ryokan garden, Cottage exterior, all plants | 3 | 116 models (40 trees, 35 plants, 27 rocks). "Ghibli-inspired" per page copy; in practice it's flat-shaded low-poly. Source tier ships custom wind shaders for grass/leaves. Acceptable as second-pass plants if Poly Haven's photoreal plants clash with the toon shader. |
| Modular Dungeon Pack | https://quaternius.com/packs/modulardungeon.html | CC0 | FBX, OBJ, Blend | not listed | Cellar, Gothic crypt areas | 2 | 48 models. 2019 vintage, no glTF, untextured. Crude — modern Gothic asks for more. Use only as cellar blockout. |
| Modular Sci-Fi MegaKit | https://quaternius.com/packs/ultimatemodularscifi.html | CC0 | FBX, OBJ, Blend | not listed | Sci-Fi room walls/floors | 3 | 46 modular interior pieces. Reasonable for a clean white sci-fi room. No glTF. |
| Medieval Village MegaKit | https://quaternius.com/packs/medievalvillagemegakit.html | CC0 | FBX, OBJ, Blend, glTF | not listed | Cottage exterior, Victorian exterior approximation | 3 | 304 models with grid-based modular snapping (walls/floors/stairs/roofs/doors/windows). Best Quaternius arch kit. Source tier has Godot 4.3 wear-color shaders. |
| Sushi Restaurant Kit | https://quaternius.com/packs/sushirestaurantkit.html | CC0 | FBX, OBJ, Blend, glTF | not listed | Ryokan kitchen / dining props | 3 | 108 models, animated characters (irrelevant to us), modular interior. Tightest theme fit Quaternius offers for Japanese. |
| Ultimate Buildings Pack | https://quaternius.com/packs/ultimatetexturedbuildings.html | CC0 | FBX, OBJ, Blend | not listed | Skybox / window-view buildings only | 2 | 76 modular buildings, low-poly. Atlas-textured. Useful only as background "village outside the window" set dressing. Not interior architecture. |
| Sci-Fi Essentials Kit | https://quaternius.com/packs/scifiessentialskit.html | CC0 | FBX, OBJ, Blend, glTF | not listed | Sci-Fi room props, screens, crates | 3 | 65 models. Includes animated screens and crates — good for treasury / sci-fi study props. Source tier targets Godot 4.3+. |

---

## 2. Kenney — kenney.nl

**Coverage:** Overlaps with Quaternius. Kenney is **flat-shaded, slightly chunkier, brighter palette than Quaternius**. Same "mobile-casual" aesthetic ceiling. CC0 across the board.

**Gotchas:**
- "Furniture Kit", "Nature Kit", "Fantasy Town Kit", "Modular Dungeon Kit" all confirmed live and CC0. The "Castle Kit" Manus implied (via Fantasy Town) does exist but I can't find a Furniture Kit page directly via the listing — only confirmed by direct URL fetch. The asset listing page (kenney.nl/assets at category:3D filter) does NOT show Furniture Kit; it surfaces via direct slug. May be a categorisation bug on Kenney's end, not a missing asset.
- All Kenney 3D kits ship as ZIP archives containing OBJ + GLB + FBX + Blend variants per model. Compatible with Godot's GLB importer out of the box.
- File sizes not exposed in the listing.

**Aesthetic verdict:** Same as Quaternius — fit score caps at 3 for the painterly target. **Use as blockout/mobile-LOD tier.**

| Asset | URL | Licence | Format | Size | Themes served | Fit | Notes |
|---|---|---|---|---|---|---|---|
| Furniture Kit | https://kenney.nl/assets/furniture-kit | CC0 | OBJ + GLB + FBX + Blend (ZIP) | not listed | Modern Loft, generic interior | 3 | 140 files. Largest free interior-furniture set on Kenney. Beats Quaternius Ultimate Furniture (20 models) on count. |
| Nature Kit | https://kenney.nl/assets/nature-kit | CC0 | OBJ + GLB + FBX + Blend (ZIP) | not listed | Garden, Ryokan garden, Cottage | 3 | 330 items — largest free nature kit anywhere. Trees, rocks, foliage, fences. Style is square-edge low-poly, will not blend with Poly Haven's photoreal plants. |
| Fantasy Town Kit | https://kenney.nl/assets/fantasy-town-kit | CC0 | OBJ + GLB + FBX + Blend (ZIP) | not listed | Cottage exterior, fantasy library exterior | 3 | 160 assets, v2.0 remake. Better than the Quaternius Medieval Village for fairy-tale cottage flavour but lower poly. |
| Modular Dungeon Kit | https://kenney.nl/assets/modular-dungeon-kit | CC0 | OBJ + GLB + FBX + Blend (ZIP) | not listed | Cellar, Treasury underground | 2 | 40 files. Includes animation + colour variation slots. Cleaner than Quaternius's dungeon pack but still cartoony. |
| Mini Dungeon | https://kenney.nl/assets/mini-dungeon | CC0 | ZIP of GLB+OBJ+FBX | not listed | Cellar | 2 | Mini variant. Skip. |
| Graveyard Kit | https://kenney.nl/assets/graveyard-kit | CC0 | ZIP of GLB+OBJ+FBX | not listed | Garden ruins, Gothic exterior | 2 | Confirmed exists via category listing. Could provide statues/urns for Gothic if combined with PBR retexture. |
| Modular Space Kit | https://kenney.nl/assets/modular-space-kit | CC0 | ZIP of GLB+OBJ+FBX | not listed | Sci-Fi room | 2 | Confirmed exists. Alternative to Quaternius Modular Sci-Fi. Pick one. |
| Platformer Kit | https://kenney.nl/assets/platformer-kit | CC0 | ZIP | not listed | — | 1 | Wrong style for memory palace. Skip. |
| Pirate Kit | https://kenney.nl/assets/pirate-kit | CC0 | ZIP | not listed | — | 1 | Off-theme. Skip. |
| Factory Kit | https://kenney.nl/assets/factory-kit | CC0 | ZIP | not listed | Workshop room only | 2 | Could dress workshop room with placeholder machinery, but style clash unless committing to whole Kenney aesthetic. |

---

## 3. Poly Haven — polyhaven.com

**Coverage:** This is the **highest-quality CC0 asset library that will fit MindHause's stylized realism target.** All textures ship as proper PBR sets (diffuse + normal-DX + normal-GL + roughness + AO + ARM + displacement). Models are photogrammetry-based with multiple LOD options (1K through 8K textures). All CC0.

**Gotchas:**
- Poly Haven's category filter pages (`polyhaven.com/textures/marble` etc) return **0 results to unauthenticated WebFetch** — they're client-rendered. To enumerate, you must hit the API at `api.polyhaven.com/assets?type=textures&categories=<name>`. The API does NOT have a "marble" category — marble textures are tagged under their actual visual category (cobblestone/tiles/stone) and discoverable only by name search.
- "Marble 01" by Rob Tuytel has 306k downloads — that's the canonical Poly Haven marble. Confirmed direct URL.
- Models are **photogrammetry-realistic**, NOT stylized. They will look extremely high-fidelity dropped into a Quaternius/Kenney scene — style clash. **Use either the photoreal Poly Haven path OR the Quaternius/Kenney path, not both, in a given room.** This is the decisive choice for the project.
- Plant models are 17K-96K triangles each. Mobile-friendly only with LOD tiers (Poly Haven supplies 1K texture options but polycount is fixed per-model).

**Aesthetic verdict:** Photoreal PBR. Fit-score 4 across the board for the stylized-realism target — the painterly look comes from the toon shader pass on top, not from the source asset. **This is the right foundation for textures.**

### 3a. Marble (Greco-Roman Sanctuary)

| Asset | URL | Licence | Format | Max res | Themes | Fit | Notes |
|---|---|---|---|---|---|---|---|
| Marble 01 | https://polyhaven.com/a/marble_01 | CC0 | Blend, glTF, MaterialX, ZIP (EXR/JPG/PNG maps) | 8K | Greco-Roman floors/walls | 5 | Cream-beige with subtle veining, low sheen. The "default Greco-Roman marble". 306k downloads. Includes diffuse, normal (DX+GL), roughness, AO, ARM, displacement, specular. |
| Marble Tiles | https://polyhaven.com/a/marble_tiles | CC0 | Blend, glTF, MaterialX, ZIP | 4K | Greco-Roman floor (tiled grid) | 4 | Beige square tiles with dark grout, weathered. Distinct from Marble 01 — gives you an actual tiled-floor pattern vs. continuous slab. |
| Marble Mosaic Tiles | https://polyhaven.com/a/marble_mosaic_tiles | CC0 | Blend, glTF, MaterialX, ZIP | 16K | Greco-Roman accent floor / mosaic | 4 | Cream + brown checkered mosaic. Use sparingly as accent (atrium centre, plinth). |
| Floor Tiles 06 | https://polyhaven.com/a/floor_tiles_06 | CC0 | Blend, glTF, MaterialX, ZIP | 4K | Greco-Roman alternate floor | 4 | Brown/beige checkered marble — alternative to Marble Tiles for variation between rooms. |

### 3b. Wood (Modern Loft, Ryokan, Victorian, Cottage)

| Asset | URL | Licence | Format | Max res | Themes | Fit | Notes |
|---|---|---|---|---|---|---|---|
| Wood Floor | https://polyhaven.com/a/wood_floor | CC0 | Blend, glTF, MaterialX, ZIP | 8K | Modern Loft floor | 5 | Warm medium-brown narrow oak planks, satin finish. The canonical Poly Haven loft floor. 269k downloads. |
| Herringbone Parquet | https://polyhaven.com/a/herringbone_parquet | CC0 | Blend, glTF, MaterialX, ZIP | 16K | Modern Loft accent floor, Victorian study floor | 5 | Glossy herringbone — strong choice for Victorian study or modern loft accent. |
| Dark Wood | https://polyhaven.com/a/dark_wood | CC0 | Blend, glTF, MaterialX, ZIP | 4K | Victorian library / scholar woodwork | 5 | Dark cherry/mahogany, warm red tones, satin. Exactly the Victorian scholar wood. 205k downloads. |
| Japanese Sycamore | https://polyhaven.com/a/japanese_sycamore | CC0 | Blend, glTF, MaterialX, ZIP | 4K | Ryokan wall panels / shoji frames | 4 | Dry, peeling, mottled pale-grey/tan with raised knots. Specifically Japanese-themed bark/wood. |
| Sakura Bark | https://polyhaven.com/a/sakura_bark | CC0 | Blend, glTF, MaterialX, ZIP | 8K | Ryokan garden cherry tree | 4 | Cherry trunk surface — pair with a sakura model for the ryokan garden. |
| Medieval Wood | https://polyhaven.com/a/medieval_wood | CC0 | Blend, glTF, MaterialX, ZIP | 4K | Cottage / Victorian door / cellar door | 4 | Weathered medieval planks with rusted iron rivets. Includes Bump + Specular maps in addition to standard PBR. |
| Wood Floor Worn | https://polyhaven.com/a/wood_floor_worn | CC0 | Blend, glTF, MaterialX, ZIP | 4K | Cottage floor | 4 | Worn pine planks with knots, nail holes. Cottage / cellar floor candidate. |
| Weathered Planks | https://polyhaven.com/a/weathered_planks | CC0 | Blend, glTF, MaterialX, ZIP | 8K | Cottage exterior, Workshop walls, Fallout planks | 4 | Dark brown cracked boards. Versatile for rustic surfaces. |

### 3c. Brick / Stone (Gothic, Cottage, Cellar)

| Asset | URL | Licence | Format | Max res | Themes | Fit | Notes |
|---|---|---|---|---|---|---|---|
| Castle Brick 01 | https://polyhaven.com/a/castle_brick_01 | CC0 | Blend, glTF, MaterialX, ZIP | 8K | Gothic cathedral walls, Cellar walls | 5 | Rough damp bricks with moss, eroded mortar. Reads as "ancient cellar" perfectly. |
| Church Bricks 03 | https://polyhaven.com/a/church_bricks_03 | CC0 | Blend, glTF, MaterialX, ZIP | 8K | Gothic cathedral, Victorian library exterior | 5 | Weathered red brick, deep mortar lines. Classic gothic-church facade. |
| (browse via brick category — 102 textures) | https://polyhaven.com/textures/brick | CC0 | varies | up to 16K | All themes | — | Full brick library is 102 assets via API. Pull more on demand. |

### 3d. Plaster (Modern Loft, Victorian, Cottage interior walls)

| Asset | URL | Licence | Format | Max res | Themes | Fit | Notes |
|---|---|---|---|---|---|---|---|
| Painted Plaster Wall | https://polyhaven.com/a/painted_plaster_wall | CC0 | Blend, glTF, MaterialX, ZIP | 16K | Modern Loft wall, Greco-Roman wall | 5 | Slightly discoloured exterior plaster with worn patches. 270k downloads. Highest-resolution texture confirmed in the audit. |
| Worn Plaster Wall | https://polyhaven.com/a/worn_plaster_wall | CC0 | Blend, glTF, MaterialX, ZIP | 8K | Cottage interior, Fallout walls | 4 | Recent (2025), 6k downloads. Newer aesthetic, more worn/grungy than Painted Plaster Wall. |
| (browse via plaster category — 31 textures) | — | CC0 | varies | varies | — | — | API confirms 31 plaster textures total. |

### 3e. Fabric / Leather (Victorian, Modern Loft upholstery)

| Asset | URL | Licence | Format | Max res | Themes | Fit | Notes |
|---|---|---|---|---|---|---|---|
| Floral Jacquard | https://polyhaven.com/a/floral_jacquard | CC0 | Blend, glTF, MaterialX, ZIP | 4K | Victorian armchair, drapes | 5 | Black with embossed floral weave. Full PBR + anisotropy maps. Quintessential Victorian upholstery. |
| Brown Leather | https://polyhaven.com/a/brown_leather | CC0 | Blend, glTF, MaterialX, ZIP | 8K | Victorian armchair, study chair, book bindings | 5 | Vintage matte brown leather. 200k downloads. The Victorian leather. |
| (fabric category — 43 textures, leather subcat — 6) | — | CC0 | varies | varies | — | — | Use as needed. |

### 3f. Plant Models (Ryokan, Cottage, Garden)

| Asset | URL | Licence | Format | Polycount | Themes | Fit | Notes |
|---|---|---|---|---|---|---|---|
| Potted Plant 01 | https://polyhaven.com/a/potted_plant_01 | CC0 | Blend, glTF, USD, FBX, ZIP | 96K tris | Modern Loft, Ryokan, Cottage | 5 | Lush scalloped leaves, weathered terracotta pot. 4K textures. **HIGH polycount — use sparingly or LOD.** |
| Potted Plant 02 | https://polyhaven.com/a/potted_plant_02 | CC0 | Blend, glTF, USD, FBX, ZIP | 70K tris | Modern Loft, Ryokan | 5 | Heart-shaped variegated leaves, terracotta pot. 0.8m tall. 102k downloads. |
| Potted Plant 04 | https://polyhaven.com/a/potted_plant_04 | CC0 | Blend, glTF, USD, FBX, ZIP | 6K tris | All themes (succulent) | 4 | Zebra haworthia succulent — small ceramic pot. **Low polycount — mobile-safe.** Use this as the default if performance matters. |
| Calathea Orbifolia 01 | https://polyhaven.com/a/calathea_orbifolia_01 | CC0 | Blend, glTF, USD, FBX, ZIP | 17K tris | Ryokan garden, Cottage interior | 5 | Broad ribbed heart-shaped leaves. Indoor / outdoor shrub, 2.5m wide. |
| Anthurium Botany 01 | https://polyhaven.com/a/anthurium_botany_01 | CC0 | Blend, glTF, USD, FBX, ZIP | not listed | Garden, Ryokan | 5 | Glossy broad leaves. 2.8m wide groundcover. |
| (more in models/plants — at least 7 confirmed via API) | https://polyhaven.com/models/plants | CC0 | varies | varies | — | — | Plus dandelion, celandine, didelta, cheiridopsis, iceplant — all 8K-source botany scans. |

---

## 4. AmbientCG — ambientcg.com

**Coverage:** ~2000 PBR materials, all **CC0 confirmed** (Creative Commons CC0 1.0, no attribution required, commercial use OK — verified via docs.ambientcg.com/license/). **Strong complement to Poly Haven** because AmbientCG leans procedural / Substance-generated, while Poly Haven leans photogrammetry. Different but compatible PBR styles.

**Gotchas:**
- AmbientCG's category list pages are largely empty to WebFetch (returns navigation only) — same client-render issue as Poly Haven. Use site:search to find specific assets.
- All assets ship as ZIPs of JPG or PNG PBR map sets at 1K through 8K. No glTF wrappers — you have to assemble the StandardMaterial3D in Godot manually.
- Map types follow USDZ-compatible PBR convention: Color, Normal (DX/GL), Roughness, Metallic, AO, Displacement. Some include Specular and IOR.
- Naming convention is `<Category>NNN`, e.g. Marble012, WoodFloor007, Bricks097.

**Aesthetic verdict:** Photoreal PBR, slightly more procedural / cleaner than Poly Haven. Fit 4 for stylized-realism target. **Use AmbientCG when Poly Haven doesn't have what you need — they fill complementary gaps.**

| Asset | URL | Licence | Format | Max res | Themes | Fit | Notes |
|---|---|---|---|---|---|---|---|
| Marble 002 | https://ambientcg.com/view?id=Marble002 | CC0 | JPG/PNG ZIP | 8K | Greco-Roman | 4 | Procedural. 104k downloads. |
| Marble 012 | https://ambientcg.com/view?id=Marble012 | CC0 | JPG/PNG ZIP | 8K | Greco-Roman | 5 | The canonical AmbientCG marble: white, polished, smooth. 403k downloads (most popular marble). |
| Marble 023 | https://ambientcg.com/view?id=Marble023 | CC0 | JPG/PNG ZIP | 8K | Sci-fi accent floor, Treasury luxury | 4 | Black/blue marble, dark, reflective. Use for treasury or Greco-Roman accent. |
| Wood Floor 007 | https://ambientcg.com/view?id=WoodFloor007 | CC0 | JPG/PNG ZIP | 4K | Modern Loft alt | 4 | Light parquet, clean, smooth. 188k downloads. |
| Wood Floor 032 | https://ambientcg.com/view?id=WoodFloor032 | CC0 | JPG/PNG ZIP | up to 8K | Modern Loft alt | 4 | Procedural Substance Designer. |
| Wood Floor 040 | https://ambientcg.com/view?id=WoodFloor040 | CC0 | JPG/PNG ZIP | 8K | Modern Loft alt | 4 | Procedural. |
| Bricks 097 | https://ambientcg.com/view?id=Bricks097 | CC0 | JPG/PNG ZIP | 8K | Workshop, Cellar, Cottage exterior | 4 | Photogrammetry-based (rare for AmbientCG). Damaged, dirty, factory-style. |
| Plaster 001 | https://ambientcg.com/view?id=Plaster001 | CC0 | JPG/PNG ZIP | up to 8K | Modern Loft, Greco-Roman | 4 | Clean, matte, modern, white plaster. |
| Plaster 003 | https://ambientcg.com/view?id=Plaster003 | CC0 | JPG/PNG ZIP | up to 8K | Modern Loft alt | 4 | Clean, rough white. |
| Travertine 001 | https://ambientcg.com/view?id=Travertine001 | CC0 | JPG/PNG ZIP | up to 8K | Greco-Roman atrium | 4 | Travertine — historically accurate Roman building stone. |
| (full library) | https://ambientcg.com/list?type=Material | CC0 | varies | up to 8K | All | — | 2000+ materials browsable. |

---

## 5. Sonniss GDC Bundles — sonniss.com/gameaudiogdc

**Coverage:** Confirmed live. **GDC 2026 bundle is the current release** (~7.47GB). The full archive across 9+ years totals ~160-200GB on the secondary archive.org mirror.

**Gotchas:**
- **NOT CC0.** Custom Sonniss "Unlimited User License" — but the practical terms are equivalent: royalty-free, commercial use OK, no attribution required, lifetime, unlimited projects.  Restrictions: cannot resell the raw sound files, cannot sublicense.
- Direct download from `gdc.sonniss.com` is currently behind WSL/datacentre IP block (HTTP 403 to WebFetch). User will need to download from a normal browser. No login or email required.
- Content per yearly bundle: 5-15GB of WAV files across foley, ambient, UI, music, weapons, vehicles. Mix is dictated by which contributors donated each year.
- The `audio/music/` folder gap in the project is partially fillable from Sonniss bundles, but ambient music specifically is a small fraction — Sonniss is mostly SFX. **Music will need a separate source.**

| Asset | URL | Licence | Format | Size | Themes served | Fit | Notes |
|---|---|---|---|---|---|---|---|
| GDC 2026 Game Audio Bundle | https://gdc.sonniss.com/ | Sonniss UUL (royalty-free, no attribution) | WAV | ~7.47GB | All themes (ambient, UI, foley) | 5 | Most recent bundle. Direct download. |
| GDC 2024 Bundle | https://gdc.sonniss.com/gdc-2024-game-audio-bundle/ | Sonniss UUL | WAV | not listed | All themes | 4 | Prior-year, additive. |
| GDC 2023 Bundle | https://gdc.sonniss.com/gdc-game-audio-bundle/ | Sonniss UUL | WAV | not listed | All themes | 4 | Prior-year, additive. |
| Bundle archive (all years) | https://sonniss.com/gameaudiogdc/ | Sonniss UUL | WAV | ~160GB cumulative | All themes | 5 | Master archive page. **This is the right starting URL.** |
| License full text | https://sonniss.com/gdc-bundle-license/ | — | — | — | — | — | Read before shipping. |

---

## 6. Godot Shaders — godotshaders.com

**Coverage:** All confirmed live. Mostly **CC0 or MIT** — license is per-shader, must check each. Authors are individual community members.

**Gotchas:**
- License is per-post; site itself does not force CC0. CaptainLaptop/binbun/axilirate/sebashtioon all default to CC0. arlez80 and Koaleszenz use MIT. Both are MindHause-compatible.
- Shaders are pasted as code blocks — no installer / addon. Copy-paste into a `.gdshader` file in your project. Source explicitly available on every page.

| Asset | URL | Licence | Author | Themes / use | Fit | Notes |
|---|---|---|---|---|---|---|
| Ultimate Toon Shader | https://godotshaders.com/shader/ultimate-toon-shader/ | CC0 | binbun | Stylized realism — apply to all room geometry | 5 | Stepped lighting, shadow tinting, pattern overlays, rim lighting, normal mapping, specular. Godot 4.x. **Free replacement for the Manus-flagged $25 itch.io toon shader. Use this.** |
| Stylized Sky Shader With Clouds | https://godotshaders.com/shader/stylized-sky-shader-with-clouds/ | CC0 | axilirate | Outdoor rooms (Garden, Greco-Roman atrium), skybox | 5 | Day/night cycle, animated clouds, sun/moon, stars, customisable colours. Godot 4. Full source provided. |
| Stylized Sky | https://godotshaders.com/shader/stylized-sky/ | per-page (likely CC0) | unknown | Skybox alt | 4 | Lighter-weight alternative to the above. Godot 4.x. |
| Water with Caustics | https://godotshaders.com/shader/water-with-caustics/ | CC0 | binbun | Greco-Roman fountains, Garden water, Ryokan koi pond | 5 | Spatial shader with caustics, foam edges, refraction, optional toon banding. Modern Godot 4 syntax. **The exact Manus-recommended shader, confirmed CC0.** |
| Stylized Toon Water | https://godotshaders.com/shader/stylized-toon-water/ | MIT | Thundergecko8 | Garden, Ryokan, Greco-Roman pools | 5 | Color-banded water using mesh-normal/camera relationship. 4 colour bands. Pairs perfectly with the Ultimate Toon Shader. |
| Distance Gradient Fog 4.3+ | https://godotshaders.com/shader/distance-gradient-fog-4-3/ | MIT | Koaleszenz | All themes (Among Trees–style atmosphere) | 5 | Inspired by Among Trees. Full-screen postprocess depth-fog with custom gradient. **Strongly recommended for the dreamlike target.** |
| Stylized Spatial Clouds | https://godotshaders.com/shader/realistic-spatial-clouds/ | CC0 | sebashtioon | Sky / atmosphere (separate from sky shader) | 4 | 3D cloud volume on a plane. Author admits it's for toon/low-poly games specifically. |
| Procedural Stained-Glass | https://godotshaders.com/shader/procedural-stained-glass-shader/ | MIT | arlez80 (Yui Kinomoto) | Gothic cathedral windows | 5 | Procedural Voronoi-cell stained glass with leading edges and surface noise. Exact gothic-cathedral fit. |
| Procedural Torch & Candle | https://godotshaders.com/shader/procedural-torch-candle-shader-fire-smoke-sparks/ | CC0/MIT | CaptainLaptop | All themes (torches, candles) | 4 | Canvas_item shader (2D — applies as overlay or to billboard). Procedural fire+smoke+sparks, no textures or particles needed. Single draw call. |
| Retro Parchment Paper | https://godotshaders.com/shader/retro-parchment-paper/ | CC0 | GuoXiaoYao | Symbolic-prop scrolls, books, 2D map UI | 5 | 2D canvas_item shader. Sepia + ink-bleed glow + dirt + vignette. **Exact fit for in-world parchment props.** |
| (Also confirmed exists) Stylized Cloudy Sky v2 | https://godotshaders.com/shader/stylized-cloudy-sky/ | per-page | unknown | Sky alt | 4 | Cloud variation. |
| (Also confirmed exists) Volumetric Raymarched Animated Clouds v2 | https://godotshaders.com/shader/volumetric-raymarched-animated-clouds-v2/ | per-page | unknown | Sky alt — premium look | 5 | Volumetric clouds — significantly more expensive at runtime. |

---

## 7. OpenGameArt / itch.io free section

**Coverage:** Browsed via search. **Nothing exceptional matching the painterly/Ghibli target was found in the free tier.** Consistent with the brief's "skip generic low-poly" guidance.

| Asset | URL | Licence | Format | Themes | Fit | Notes |
|---|---|---|---|---|---|---|
| CC0 3D Furniture and Decorables | https://opengameart.org/content/3d-furniture-and-other-interiorexterior-decorables-under-cc0 | CC0 | mostly Blend / OBJ | All | 2 | 200+ furniture/storage/decorative items. Mixed styles (low-poly, hand-painted, realistic). Quality is uneven — game-jam tier mostly. Skim only if a specific gap appears. |
| Stylized House 3D | https://opengameart.org/content/stylized-house-3d | **CC-BY 3.0** (NOT CC0) | Blend, FBX, OBJ | Cottage exterior | 3 | Single fantasy cabin, hand-painted 2K texture, 1816 tris. Charming but isolated. Attribution required. |

**Verdict:** OpenGameArt's free 3D tier consistently delivers lower visual quality than Quaternius/Kenney for similar low-poly aesthetics, and lower quality than Poly Haven for realistic. Skip unless a specific symbolic prop appears that nothing else covers.

itch.io free 3D-asset section was not exhaustively combed — most of its painterly/Ghibli content is paid (and recon for those is the premium agent's job). Free section is dominated by Kenney/Quaternius mirrors and amateur work.

---

## OVERALL FREE COVERAGE GAP (Tier 1 audit)

The brief's Tier 1 priorities are **architecture, furniture, symbolic props**. Honest assessment of the gap:

### 1. Architecture — PARTIAL with a hard stylistic compromise

- **Photoreal PBR textures (Poly Haven + AmbientCG):** complete. You can fully clad the existing CSG room walls/floors/ceilings in proper PBR materials matching every theme. **This is solved.**
- **Modular geometry (walls/arches/pillars/stairs/door frames):** **The free tier ONLY offers low-poly Quaternius/Kenney style.** There is no free CC0 modular architecture kit at the Witness/Firewatch fidelity level. To get there you must either (a) use Poly Haven textures on hand-built CSG / Blender geometry, or (b) buy Synty/KitBash. The Manus pass papered over this by listing Modular Dungeon Pack and Medieval Village MegaKit as "good" — they are stylistically wrong for the project.

### 2. Furniture — PARTIAL, same story

- Kenney Furniture Kit (140 files) and Quaternius Ultimate Furniture (20 models) are the only free furniture sources of any breadth. Both are flat-shaded low-poly. They will look like Crossy Road sat next to a Poly Haven plant.
- **No free CC0 stylized-realism furniture pack exists** that I could verify. The Poly Haven model library has ~7 confirmed plant models and a few decoratives but is not a furniture catalogue. This is the **single biggest free-tier gap**.

### 3. Symbolic props — ADEQUATE but stylistically compromised

- Quaternius Fantasy Props MegaKit (200+ items: books, scrolls, keys, jars, candles, statues) is the only one-stop free shop. Style is the same low-poly issue. Acceptable as placeholder/initial implementation; revisit once core architecture style is locked.
- Custom Blender-modeled props using Poly Haven materials would solve this but is out of scope for asset acquisition.

### 4. Music — NOT COVERED by these vendors

- Sonniss GDC bundles are 95% SFX, ~5% music stems. The `audio/music/` empty folder is a gap that **no free vendor in this audit covers well**. Possible candidates not yet recon'd: incompetech.com (Kevin MacLeod, CC-BY), FreePD (CC0), itch.io free music tag. Worth a follow-up.

### 5. Architectural shader/lighting — COVERED

- Ultimate Toon + Distance Gradient Fog + Stylized Sky + Water with Caustics + Procedural Stained Glass = a complete free shader stack that achieves the painterly target on top of Poly Haven materials. **This is the underrated win of this recon.** Manus listed paid alternatives (Godot Skies $20, Godot Ultimate Toon $25, Godot VFX $9.99) — all have free CC0/MIT equivalents on godotshaders.com, confirmed.

### Decision pressure for the next phase

The free tier forces a binary choice on **modular architecture geometry**:

- **Path A (free, stylistic compromise):** Quaternius Medieval Village + Kenney Furniture Kit + Quaternius Fantasy Props, all under one toon shader. Cohesive, mobile-friendly, but caps visual ceiling at "polished mobile casual" — not Journey/ABZÛ.
- **Path B (free + paid):** Poly Haven/AmbientCG textures on CSG architecture today, then buy Synty POLYGON ($30/pack) or KitBash3D for the modular kits later. Fewer assets immediately, but preserves the painterly ceiling.
- **Path C (long-term):** Custom modular Blender geometry textured with Poly Haven materials. Out of scope for asset acquisition but the only way to truly hit the visual target with zero asset spend.

The premium recon (next deliverable) should focus specifically on Path B costs and KitBash3D-equivalent fit.
