# MindHause Asset Requirements

Derived 2026-05-10 from the project state, the Manus brief (`docs/_manus_drop_2026-05-09/pasted_content.txt`), and `MEMORY.md`. This is the contract the recon must satisfy.

## Project context
- **App**: Memory palace productivity tool — psychologically restorative
- **Engine**: Godot 4.0.stable (mobile profile), targeting desktop + mobile
- **Current state**: 10 rooms wired with CSG primitives, no real 3D assets in the world. Cat models + SFX exist; everything else is empty placeholders.
- **Visual target**: Journey / Firewatch / ABZÛ / Studio Ghibli / The Witness — stylized realism, painterly, dreamlike, calm
- **Visual REJECTION criteria**: crude low-poly game-jam, voxel art, meme aesthetics, photorealistic urban, horror, military

## The 8 themes (each themes a subset of rooms)
| ID | Theme | Notes |
|---|---|---|
| `greco_roman` | Greco-Roman Sanctuary | Marble, columns, atriums, fountains, Mediterranean light |
| `victorian` | Victorian Scholar | Libraries, dark wood, brass, fireplaces, scholarly |
| `modern_loft` | Modern Luxury Loft | Architectural minimalism, warm woods, soft indirect light |
| `scifi` | Sci-Fi Minimal | White architecture, subtle neon, contemplative |
| `gothic` | Gothic Cathedral | Vast vertical, stained glass, candlelight, mystical |
| `ryokan` | Japanese Ryokan | Paper screens, warm wood, lanterns, gardens, zen |
| `cottage` | Countryside Cottage | Rustic, fireplaces, plants, cozy, comforting |
| `fallout` | Post-apocalyptic | Stylized — oxidized metal, peeling paint, broken tiles (NOT military/horror) |

## The 10 rooms (all in `godot_palace/scenes/rooms/`)
foyer, study, library, kitchen, bedroom, cellar, workshop, garden, gymnasium, treasury, plus the `house.tscn` orchestrator.

## Asset categories — priority order

### Tier 1 — completely empty, blocking visual progress
1. **Architecture kits** — modular walls, floors, doors, windows, stairs, arches, pillars, ceiling. (Rooms are CSG boxes today.)
2. **Furniture** — bookshelves, desks, tables, seating, beds. (Rooms are empty.)
3. **Symbolic props** — books, scrolls, keys, jars, candles, statues, fountains. (Mnemonic interactables — central to gameplay.)

### Tier 2 — partial coverage, would lift quality
4. **Nature / plants** — for ryokan, cottage, garden room
5. **PBR textures (multi-map)** — current textures are single-channel PNGs, want proper PBR (albedo + normal + roughness + AO) for material upgrade
6. **Atmospheric shaders** — sky, fog, water, glow, toon shader. (Only painterly post-process exists.)
7. **Music / ambient loops** — `audio/music/` is empty (only `.gitkeep`)

### Already covered — DEPRIORITIZE
- 8 themed cat GLBs in `models/cats/`
- SFX: doors, footsteps (grass/stone/wood), monsters, UI tap/swipe/notification, task pickup/place/complete
- Theme PNG textures (single-channel) — keep but PBR upgrades welcome

## Constraints
- **License**: Free CC0 strongly preferred. CC-BY acceptable with attribution.
- **Premium**: Considered for foundation pieces only (Synty POLYGON $30/pack, KitBash3D ~$325–425/kit) if exceptional fit.
- **Cannot purchase or login**: Recon agent cannot access paid downloads, Synty/KitBash accounts, or itch.io purchase flows. Premium recon is information-gathering only — final purchase is human decision.
- **Format**: GLB/GLTF preferred (native Godot support). FBX/OBJ acceptable but require import work.
- **Performance**: Stylized-medium polycounts. Mobile-friendly draw calls matter — modular kits with shared atlas preferred.

## Out of scope for this recon
- Concept art generation
- Custom asset creation
- Buying anything
- Downloading anything (this pass is recon only)

## Definition of done
The recon produces these artifacts in `docs/asset_recon_2026-05-10/`:
- `requirements.md` — this file
- `recon_free.md` — verified per-asset audit of CC0 sources
- `recon_premium.md` — verified per-asset audit of paid sources (info only)
- `decisions.md` — consolidated tier list + (theme × category) recommendation matrix
- `tracking.md` — empty ledger for tracking actual downloads when they happen
