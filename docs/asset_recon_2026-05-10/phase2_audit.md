# Phase 2 Audit — Vendor Pack → Shopping List Mapping

Performed 2026-05-10 after all Phase 1 free assets landed (Quaternius Fantasy Props, Stylized Nature, Sushi, Sci-Fi Essentials, plus Kenney Furniture Kit). This maps each shopping-list item to a specific vendor file (or marks it as "custom needed").

Format: shopping list path → relative source path under `godot_palace/assets/models/`.
Fit notes: 5=painterly target, 3=low-poly fits-with-toon-shader, 2=stretch substitute.

---

## Task object models (10) — `models/objects/`

| Canonical file | Source | Fit | Notes / alternatives |
|---|---|---|---|
| `book.glb` | `quaternius/fantasy_props/Exports/glTF/Book_5.gltf` | 3 | Many alternates: Book_7, Book_Simplified_Single, Book_Stack_1/2; or BookGroup_Small/Medium_1/2/3 for grouped variant |
| `scroll.glb` | `quaternius/fantasy_props/Exports/glTF/Scroll_1.gltf` | 3 | Scroll_2 is alt |
| `candle.glb` | `quaternius/fantasy_props/Exports/glTF/Candle_1.gltf` | 3 | Candle_2; CandleStick / CandleStick_Stand / CandleStick_Triple for taller versions |
| `statue.glb` | **No exact match.** Best substitute: `quaternius/fantasy_props/Exports/glTF/Dummy.gltf` (training dummy) OR `Vase_4.gltf` (decorative urn) | 2 | Brief asks "small bust or figurine" — Quaternius doesn't ship one. Custom Blender or Sketchfab hunt for true bust |
| `letter.glb` | **No match.** Closest substitute: `quaternius/fantasy_props/Exports/glTF/Pouch_Large.gltf` | 2 | Brief asks "sealed envelope with wax stamp" — Quaternius has no envelope shape. **Custom Blender (~10 min)** is the right path |
| `jar.glb` | `quaternius/fantasy_props/Exports/glTF/Pot_1.gltf` (+ `Pot_1_Lid.gltf` for sealed look) | 3 | Or Bottle_1, Cauldron, Potion_1/2/4, SmallBottle, SmallBottles_1 — many candidates |
| `key.glb` | `quaternius/fantasy_props/Exports/glTF/Key_Gold.gltf` | 3 | Key_Metal is the silver variant |
| `plant.glb` | `models/plants/potted_plant_04/potted_plant_04.gltf` (already in TIER A) | 5 | Photoreal Poly Haven, mobile-safe 6K tris |
| `blueprint.glb` | **Custom Blender** (~10 min) | n/a | Trivial: bent plane + painted blueprint texture |
| `post_it.glb` | **Custom Blender** (~5 min) | n/a | Trivial: quad with corner bend |

**Coverage**: 7 of 10 directly sourceable + 1 already in TIER A. **3 need custom** (letter, blueprint, post_it). All three are quick Blender pieces.

---

## Furniture models (12) — `models/furniture/`

| Canonical file | Source | Fit | Notes |
|---|---|---|---|
| `desk.glb` | `kenney/furniture/Models/GLTF format/desk.glb` | 3 | Direct match. Also `deskCorner.glb` |
| `bookshelf.glb` | `kenney/furniture/Models/GLTF format/bookcaseClosed.glb` | 3 | Variants: `bookcaseClosedDoors`, `bookcaseClosedWide`, `bookcaseOpen`, `bookcaseOpenLow`. Quaternius FP `Bookcase_2.gltf` is a Victorian-leaning alternative |
| `table_round.glb` | `kenney/furniture/Models/GLTF format/tableRound.glb` | 3 | Direct match |
| `bed.glb` | `kenney/furniture/Models/GLTF format/bedSingle.glb` | 3 | `bedDouble`, `bedBunk`, `cabinetBed` are alts |
| `counter.glb` | `kenney/furniture/Models/GLTF format/kitchenBar.glb` (+ `kitchenBarEnd` for end caps) | 3 | Or `kitchenCabinet` series for traditional counter feel |
| `workbench.glb` | `quaternius/fantasy_props/Exports/glTF/Workbench.gltf` | 3 | Or `Workbench_Drawers.gltf` for utility variant |
| `display_case.glb` | `kenney/furniture/Models/GLTF format/bookcaseClosedDoors.glb` (closest) | 2 | Kenney has no true glass display case — could re-material as glass; or use Quaternius FP `Cabinet.gltf` |
| `notice_board.glb` | **Custom** (~5 min flat board with cork material) | n/a | Or stretch: `quaternius/sushi/Decoration/glTF/Decoration_Painting.gltf` as substitute frame |
| `pedestal.glb` | **No clean match.** Best substitute: `quaternius/fantasy_props/Exports/glTF/BookStand.gltf` | 2 | Custom Blender or wait for Modular Dungeon Pack |
| `stone_bench.glb` | `quaternius/fantasy_props/Exports/glTF/Bench.gltf` (wood, not stone) — re-material | 2 | True stone needs custom; or Quaternius Sushi `Environment_Bench.gltf` |
| `stone_table.glb` | `quaternius/fantasy_props/Exports/glTF/Table_Large.gltf` (wood, not stone) — re-material | 2 | Same situation |
| `column_ionic.glb` | **Custom Blender** OR substitute: `quaternius/sushi/Environment/glTF/Environment_ToriiGate.gltf` (Japanese gate, wrong style) | 2 | Real ionic capital needs custom (~30 min); ionic is the genuine gap for Greco-Roman |

**Coverage**: 5 strong matches (Kenney) + 1 strong (Quaternius Workbench) + 4 substitutes (with material/style compromises) + 2 custom (notice_board, column_ionic). **Total 12 with caveats; 6 are good-as-is, 6 need work.**

---

## Timepiece models (14) — `models/timepieces/` — THE GAP

After full inventory, **none of the downloaded packs contain hourglasses, clocks, sundials, or screens**. Sci-Fi Essentials Standard tier has Locker, Crate, SatelliteDish — but no animated panels, no CRT readouts, no clock-shaped objects. Quaternius Fantasy Props has Chalice, Dummy, Whetstone — no hourglass.

| Canonical file | Source | Notes |
|---|---|---|
| `hourglass.glb` | **Custom Blender** (~30 min) | Two hemispheres + sand particles. Recon assumption that Quaternius FP had one was wrong. |
| `kitchen_clock.glb` | **Custom Blender** (~5 min) | Round face + 2 hands + ring border |
| `mantel_clock.glb` | **Custom Blender** (~15 min) | Wooden box + face + hands |
| `grandfather_clock.glb` | **Custom or Sketchfab CC0 hunt** | Hero piece, ~2 hrs Blender or quick search |
| `digital_clock.glb` | **Custom Blender** (~5 min) + emissive material | Box + emissive plane front |
| `cuckoo_clock.glb` | **Custom or Sketchfab paid (~$5–15)** | Distinctive shape, hard to fake |
| `sundial.glb` | **Custom Blender** (~30 min) | Disc + gnomon + hour markers |
| `clepsydra.glb` | **Custom Blender** | Hero piece — vase + tube + basin assembly |
| `holo_clock.glb` | **Custom Blender** + Binbun hologram shader (TIER B paid) | Single quad with shader |
| `astronomical_clock.glb` | **Custom Blender** (~3 hrs) | Hero piece — concentric rings, zodiac plate, gears |
| `incense_clock.glb` | **Custom Blender** | Hero piece — wood plate with channels + small weights |
| `pillar_clock.glb` | **Custom or Sketchfab** | Niche Edo-period — likely custom |
| `salvaged_clock.glb` | **Custom** (or Quaternius FP `Whetstone.gltf` as cracked/distressed base) | Distress in shader/texture pass |
| `crt_readout.glb` | **Custom Blender** + emissive material | Sci-Fi Essentials Standard has no animated screens; Pro tier might |

**Coverage**: 0 of 14 from current packs. **All 14 are custom Blender or Sketchfab-hunt.** This category is the largest remaining gap and matches what was flagged in `decisions.md`.

Three classes of effort:
- **Quick** (~5 min each): kitchen_clock, digital_clock, mantel_clock — boxes/circles with painted faces
- **Medium** (~30 min each): hourglass, sundial, holo_clock, salvaged_clock, crt_readout — geometric primitives with shaders/distress
- **Hero** (~2–3 hrs each): grandfather_clock, cuckoo_clock, clepsydra, astronomical_clock, incense_clock, pillar_clock — bespoke craft pieces that signal each theme

---

## Bonus inventory: useful items NOT in original shopping list

These vendor files are worth knowing about — they cover gaps the shopping list didn't anticipate.

### Quaternius Fantasy Props bonus
- `Anvil.gltf` + `Anvil_Log.gltf` — workshop centerpiece
- `Banner_1/2.gltf` (+ Cloth variants) — Gothic / Victorian / Greco wall hangings
- `Barrel.gltf`, `Barrel_Apples.gltf`, `Barrel_Holder.gltf` — cellar set dressing
- `Cauldron.gltf` — Gothic / cottage hearth piece
- `Chain_Coil.gltf`, `Cage_Small.gltf` — cellar atmosphere
- `Chalice.gltf` — Greco-Roman / Gothic ritual prop
- `Chandelier.gltf` — Victorian ceiling fixture (real value)
- `Chest_Wood.gltf` — Treasury room interactable
- `Coin.gltf`, `Coin_Pile.gltf`, `Coin_Pile_2.gltf` — Treasury contents
- `Lantern_Wall.gltf`, `Torch_Metal.gltf` — Gothic / Cellar lighting
- `Peg_Rack.gltf`, `Shelf_Arch.gltf`, `Shelf_Simple.gltf`, `Shelf_Small_Bottles.gltf` — Workshop / kitchen
- `Pot_1.gltf` (+ `Pot_1_Lid.gltf`), `Cauldron.gltf` — Kitchen / alchemy
- `Pouch_Large.gltf`, `Bag.gltf` — small carryable props
- `Vase_2.gltf`, `Vase_4.gltf`, `Vase_Rubble_Medium.gltf` — Greco-Roman atrium decor
- `WeaponStand.gltf` — Gymnasium / armory

### Quaternius Sushi (Ryokan-relevant subset)
This is where Sushi pack quietly punches above its weight for our Ryokan theme:
- `Environment_ToriiGate.gltf` — iconic Japanese gateway, perfect garden centerpiece
- `Environment_Arch.gltf` — Japanese arch
- `Wall_Shoji.gltf`, `Wall_Shoji_Interior.gltf` — paper screen walls (THE Ryokan defining element)
- `Wall_RedWood.gltf`, `Wall_Stains.gltf` — variations
- `Floor_Tiles.gltf`, `Floor_Wood.gltf` — Ryokan flooring
- `Decoration_Bamboo.gltf` — bamboo plant
- `Decoration_Bell.gltf` — temple bell
- `Decoration_SakuraTree.gltf`, `Decoration_SakuraFlower.gltf` — cherry blossom
- `Decoration_Light.gltf`, `Decoration_WallLight.gltf` — Japanese lanterns
- `Decoration_Painting.gltf`, `Decoration_Painting_Small.gltf` — wall art
- `Environment_Cabinet_Doors/Shelves/Corner.gltf`, `Environment_Counter_*` — kitchen
- `Environment_CuttingTable.gltf` — workshop fit
- `Environment_Pan.gltf`, `Environment_KitchenKnives.gltf`, `Environment_Plate.gltf`, `Environment_Bowl.gltf` — kitchen props

### Quaternius Stylized Nature (garden / nature theme)
- `CommonTree_1–5.gltf`, `Pine_1–5.gltf`, `TwistedTree_1–5.gltf`, `DeadTree_1–5.gltf` — 20 trees total
- `Bush_Common.gltf` (+ Flowers variant), `Fern_1.gltf`
- `Grass_*` (4 variants), `Mushroom_Common/Laetiporus`, `Petal_1–5.gltf`
- `Plant_1.gltf` / `Plant_1_Big.gltf`, `Plant_7.gltf` / `Plant_7_Big.gltf`
- `Pebble_*` (11 variants), `Rock_Medium_1/2/3.gltf`
- `RockPath_*` (10 variants for path-laying)

### Quaternius Sci-Fi Essentials (Sci-Fi room)
- `Prop_Desk_Small/Medium/L.gltf` — 3 desk sizes
- `Prop_Locker.gltf`, `Prop_Chair.gltf`, `Prop_Mug.gltf`
- `Prop_Shelves_*` (4 variants — Thin/Wide × Short/Tall)
- `Prop_SatelliteDish.gltf` — exterior set dressing
- `Prop_KeyCard.gltf`, `Prop_HealthPack.gltf`, `Prop_HealthPack_Tube.gltf`, `Prop_Syringe.gltf` — symbolic interactables for Sci-Fi
- Skip: `Enemy_*`, `Gun_*`, `Prop_Grenade`, `Prop_Mine` (combat assets, off-brief)

### Kenney Furniture (Modern Loft / general interior)
- 7 lamp variants (Round/Square × Floor/Table/Ceiling, lampWall)
- 9 lounge sofa/chair variants (loungeSofa, loungeSofaCorner, loungeSofaLong, loungeSofaOttoman, loungeChair, loungeChairRelax, loungeDesignChair, loungeDesignSofa, loungeDesignSofaCorner)
- 10 chair variants (chair, chairCushion, chairDesk, chairModernCushion, chairModernFrameCushion, chairRounded, stoolBar, stoolBarSquare)
- Television/computer (cabinetTelevision, cabinetTelevisionDoors, computerScreen, computerKeyboard, computerMouse, laptop, televisionAntenna, televisionModern, televisionVintage)
- Kitchen appliances (kitchenFridge × 4 sizes, kitchenStove, kitchenStoveElectric, kitchenMicrowave, kitchenSink, kitchenCoffeeMachine, kitchenBlender, hoodLarge, hoodModern, toaster, dryer, washer, washerDryerStacked)
- Bathroom (bathtub, shower, showerRound, toilet, toiletSquare, bathroomCabinet, bathroomCabinetDrawer, bathroomMirror, bathroomSink, bathroomSinkSquare)
- Walls/doorways/floors/stairs (wall, wallCorner, wallCornerRond, wallDoorway, wallDoorwayWide, wallHalf, wallWindow, wallWindowSlide, doorway, doorwayFront, doorwayOpen, floorFull, floorHalf, floorCorner, floorCornerRound, stairs, stairsCorner, stairsOpen, stairsOpenSingle)
- Decor: 5 rugs, 4 pillows, 3 small plants, plantSmall1-3, pottedPlant, books, paneling, ceilingFan, coatRack/coatRackStanding, sideTable, sideTableDrawers, radio, speaker, speakerSmall, bear

### Notable: real architecture pieces!
Kenney Furniture Kit includes **walls, doorways, floors, and stairs** — meaning it can substitute for Quaternius Modular Dungeon Pack (which we didn't download). For the **Modern Loft architecture gap**, Kenney's `wall.glb` / `wallWindow.glb` / `wallDoorway.glb` / `floorFull.glb` / `stairs.glb` are usable modular base pieces.

---

## Updated coverage rollup

| Category | Sourced | Substitutes (compromise) | Custom needed | Total |
|---|---|---|---|---|
| Task objects | 7 + 1 already done = 8 | — | 2 | 10 |
| Furniture | 6 | 4 | 2 | 12 |
| Timepieces | 0 | 0 | 14 | 14 |
| **Subtotal** | **14** | **4** | **18** | **36** |

**Of the 36 model items in the shopping list, 14 (39%) have direct vendor matches and 18 (50%) need custom Blender work** — overwhelmingly concentrated in the timepieces category (14 of the 18 customs).

---

## Recommended next steps

1. **Defer timepieces to a dedicated Blender session** — the 14 are largely a self-contained craft pass (10–15 hours total for hero pieces, 1–2 hours for the simple ones). Not blocking anything else; do it when you have a Blender mood.
2. **Phase 3 (autonomous, ~30 min)**: copy/symlink the 14 directly-sourced files to canonical paths and author Godot StandardMaterial3D `.tres` resources from the 13 Poly Haven + AmbientCG materials.
3. **Phase 4 (test room)**: pick one room (Library or Foyer), apply real materials + drop in 3–5 Quaternius props + Kenney bookshelf/desk, evaluate visual fit before scaling to other rooms.
4. **2-min trivials**: `blueprint.glb` and `post_it.glb` are 5–10 min Blender pieces — knock them off in any quick window, no need to wait.
