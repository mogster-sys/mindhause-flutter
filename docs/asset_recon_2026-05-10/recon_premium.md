# MindHause Premium Asset Recon

Verified 2026-05-10. Real product pages were visited (WebFetch + WebSearch); prices quoted are what the storefront displayed at fetch time. Themes follow `requirements.md`. Fit scores per the 1–5 rubric in the brief: 5=Journey/Ghibli, 4=stylized-fits, 3=usable but generic-stylized, 2=low-poly cartoony, 1=rejected.

> **Manus document audit:** the prior shopping list was largely fabricated. Synty packs are NOT a flat $30 — pricing varies $15–$175 depending on size and current sale. KitBash3D is $95–$245 (most $145–$245), not "$199+". Binbun's individual itch.io shaders are CC0 / pay-what-you-want (~$3.75–$4.49 minimum), not the $15–$25 prices Manus claimed. The "Stylized Japanese Village Environment" attributed to IanaM does not exist on Sketchfab — IanaM has *Traditional Japanese Scenery Props* and *Traditional Japanese House with Lanterns* (separate paid Fab.com listings, prices not visible without checkout). The KitBash3D *Gothic* kit has been retired; *Ghost Realm* and *Dark Fantasy* are the live alternatives.

---

## 1. Synty Studios — POLYGON series

**Pricing model:** One-time perpetual purchase. Most packs are currently 50% off "regular" list prices; shown prices reflect that sale. SyntyPass subscription at **$30/mo annual** or **$40/mo with 3-mo minimum** unlocks the entire library (130+ packs). 5 seats per One-Time licence; 1 seat per Humble Bundle.
**Licence (game distribution):** Royalty-free for commercial games — explicitly permits incorporation into Products and distribution. Prohibited: NFT/blockchain, metaverse-platform redistribution, generative AI training/inputs, game-creation-software ingestion. **No revenue cap.** Distributing source FBX is not allowed; embedding into shipped game binaries is fine.
**Format:** FBX source files + Unity package + Unreal project. **Several newer packs (Fantasy Kingdom, Town Pack) now ship a Godot 4.5.1 project officially.** Older packs FBX-only — manual import required for Godot 4.0.
**Aesthetic warning:** Synty is cohesive low-poly with flat shading. It is NOT painterly/Ghibli. It will read as "stylized indie 3D" not "Journey." Score accordingly. The visual gap can be closed somewhat with a toon shader (Binbun's) and post-process — but you will not get Witness/ABZÛ from Synty alone.

| Product | URL | Price | Licence | Themes served | Fit (1-5) | Why valuable / cheaper alt? |
|---|---|---|---|---|---|---|
| POLYGON - Ancient Empire | https://syntystore.com/products/polygon-ancient-empire | **$75.00** (50% off $149.99) | One-Time, 5 seats, royalty-free | greco_roman | 3 | 700+ prefabs incl. amphitheatre, baths, pillars, statues. Most complete single answer for Greco-Roman. But cohort-level low-poly. |
| POLYGON - Sci-Fi City | https://syntystore.com/products/polygon-sci-fi-city | **$25.00** (50% off $49.99) | One-Time, 5 seats | scifi | 3 | 509 assets. Cheap. Caveat: page shows "Sold out" on the one-time licence — may need SyntyPass to access right now. |
| POLYGON - Sci-Fi Space | https://syntystore.com/products/polygon-sci-fi-space-pack | **$75.00** (50% off $149.99) | One-Time, 5 seats | scifi | 3 | 660 assets. Bigger than Sci-Fi City. Also marked "Sold out". |
| POLYGON - Fantasy Kingdom | https://syntystore.com/products/polygon-fantasy-kingdom | **$175.00** (50% off $349.99) | One-Time, 5 seats | victorian, gothic, cottage | 3 | 2,100+ prefabs, modular castles + houses with interiors. **Officially ships a Godot 4.5.1 project** — biggest Godot-native Synty pack. Marked "Sold out" on page but listed. Only single-pack answer for victorian gap. |
| POLYGON - Knights Pack | https://syntystore.com/products/polygon-knights-pack | **$15.00** (50% off $29.99) | One-Time, 5 seats | gothic, victorian | 3 | 204 assets, modular church/castle, includes winter variants. Cheap entry to gothic-ish architecture. |
| POLYGON - Heist Pack | https://syntystore.com/products/polygon-heist-pack | **$15.00** (50% off $29.99) | One-Time, 5 seats | modern_loft (weak) | 2 | 251 assets (bank/vault/jewelry/offices). Aesthetic skews crime-thriller, not "warm modern minimalism." Office Pack is a better fit. |
| POLYGON - Office Pack | https://syntystore.com/products/polygon-office-pack | **$25.00** (50% off $49.99) | One-Time, 5 seats | modern_loft | 3 | 750+ items, 626 props, 128 modular pieces. Closer to "tasteful modern" than Heist. Marked "Sold out" — SyntyPass may be only path right now. |
| POLYGON - Town Pack | https://syntystore.com/products/polygon-town-pack | **$25.00** (50% off $49.99) | One-Time, 5 seats | cottage, victorian | 3 | 125 buildings + 412 props. **Ships Godot 4.5.1 project.** Useful for cottage exteriors and as victorian filler. |
| POLYGON - Samurai Pack | https://syntystore.com/products/polygon-samurai-pack | **$15.00** (50% off $29.99) | One-Time, 5 seats | ryokan | 3 | 245 assets — modular temple, modular Japanese castle, zen lanterns, bamboo, Mt Fuji. Best price/coverage for Ryokan. |
| POLYGON - Samurai Empire | https://syntystore.com/products/polygon-samurai-empire | **$99.50** (50% off $199.00) | One-Time, 5 seats | ryokan | 3 | Larger Samurai pack. Buy Samurai Pack first, only upgrade if you need more. |
| POLYGON - Adventure Pack | https://syntystore.com/products/polygon-adventure-pack | **$15.00** (50% off $29.99) | One-Time, 5 seats | cottage, garden | 3 | 265 assets — adventurer/forest/dungeon. Cheap broad filler. |
| POLYGON - Apocalypse Wasteland | https://syntystore.com/products/polygon-apocalypse-wasteland | **$114.00** (70% off $379.99) | One-Time, 5 seats | fallout | 2 | 1,600+ prefabs, 23 vehicles, 23 characters. Two biomes (desert + mutant goop). **Aesthetic warning:** the "Goop Mutants vs Desert Anarchists" framing is Mad Max + Fortnite — not the calm "stylized oxidized metal" the brief asks for. Use parts only. |
| POLYGON - Apocalypse | https://syntystore.com/products/polygon-apocalypse-pack | not fetched | One-Time, 5 seats | fallout | 2 | Smaller older sibling of Apocalypse Wasteland. Same warning. |
| POLYGON - Meadow Forest Biome | https://syntystore.com/products/polygon-meadow-forest-nature-biome | **$27.50** (50% off $54.99) | One-Time, 5 seats | cottage, garden, ryokan | 3 | 187 assets — hills, flowers, trees, butterflies. Best Synty answer for serene nature. |
| POLYGON - Enchanted Forest Biome | https://syntystore.com/products/polygon-enchanted-forest-nature-biomes | **$27.50** (50% off $54.99) | One-Time, 5 seats | garden, ryokan | 3 | "Mossy floor, celestial canopy, tranquility" — closest to Ghibli intent of the Synty nature line. |
| **SyntyPass (subscription)** | https://syntystore.com/products/syntypass | **$30/mo annual** ($360/yr) or **$40/mo (3-mo min, $120 min)** | Subscription, 5 seats, $10/mo store credit | all | n/a | If you want >4 packs, subscription beats one-time purchase. $10/mo credit converts to perpetual one-time licences if cancelled. Reasonable for a 3–6 month dev cycle. |

**Synty packs that DO NOT EXIST despite Manus claiming them:** "POLYGON - Victorian" (no such pack — closest is Fantasy Kingdom). "POLYGON - Shops" (404 — was retired or renamed).

---

## 2. KitBash3D

**Pricing model:** Per-kit perpetual (Individual / Small Business / Enterprise tiers). **Most kits are $145 or $245** — Manus's "$199+" was wrong on both ends. Cheapest sit at $95 (Medieval Market). Enterprise pricing is custom.
**Licence (game distribution):** Royalty-free for commercial games. You can ship rendered/embedded assets in your game executable. **You cannot redistribute editable source kits** — practically irrelevant for shipping a game, but means you can't share a Godot project with .glb files in it on a public repo. **Individual licence is solo-developer only** (single-member entity) — if MindHause becomes a multi-person company you must upgrade to Small Business. No revenue cap.
**Format:** Native files for Blender/Unreal/Unity/C4D/Maya/3dsMax/Houdini, plus FBX, OpenUSD, MaterialX. Layout scenes included for everything except Unreal/Unity. **No Godot-native files** — FBX import for Godot 4.0 will work but materials will need rebuilding.
**Aesthetic warning:** KitBash3D is high-fidelity PBR — closer to Hollywood pre-vis than Ghibli. Polycounts are big (Atlantis = 53M tris, Wasteland = ~5M typical). For mobile-friendly Godot 4.0, you'd need to retopo or use these as KITBASH source for screen-space hero shots, not as in-game realtime geometry. Painterly post-process can pull them toward the brief but it's an active art-direction effort, not free.

**Cargo subscription model:** KitBash3D has pivoted to "Cargo" — a unified asset manager combining KB3D + Greyscalegorilla. Tiers (verified at /pages/pricing):
- Greyscalegorilla Library only: **$39/mo** or $468/yr
- KitBash3D Library only: **$59/mo** or $708/yr (20,000+ textured models, 2,000+ "game ready" assets, 300+ hero props)
- Everything Bundle: **$79/mo** (sale, was $99) or $948/yr
- Teams: **$99/user/mo** annual, 4-seat min
Cargo also has a **free tier with 100+ sample assets, no credit card** — worth trying as a free probe before committing. All tiers include "full commercial license."

**Retired kits:** Gothic kit has been retired (still downloadable for past purchasers). The current gothic alternatives are *Ghost Realm* (more "haunted") and *Dark Fantasy* (more "grim castles"). Manus pointing at the Gothic kit URL was a stale guess.

| Product | URL | Price (Individual) | Licence | Themes served | Fit (1-5) | Why valuable / cheaper alt? |
|---|---|---|---|---|---|---|
| Elysium | https://kitbash3d.com/products/elysium | **$195** | Indiv. royalty-free, no source resale | greco_roman | 5 | 58 models, 4.2M polys. *Levitating Greco-Roman fantasy courtyards* — closest single product to the brief's "Mediterranean light, marble, magical." Highest aesthetic ROI on the entire list. |
| Roman Empire | https://kitbash3d.com/products/roman-empire | **$145** | same | greco_roman | 4 | 43 models inc. Colosseum, Pantheon. More historical than Elysium's fantasy take. |
| Ancients (Ancient Temples) | https://kitbash3d.com/products/ancient-temples | **$145** | same | greco_roman, fallout (ruined) | 4 | 66 models — temple structures, pillars, weathered archways. Good for "ancient sanctuary in decay." |
| Atlantis | https://kitbash3d.com/products/atlantis | **$245** | same | greco_roman | 5 | 79 models, 53M polys — temples, agoras, ports, palaces. Mythic Mediterranean. Heavy. |
| Colonial | https://kitbash3d.com/products/colonial | **$145** | same | greco_roman, victorian | 4 | 54 models — Palladian/Regency neo-classical, Venetian windows, masonry domes. Versatile for "scholarly grand." |
| Victorian | https://kitbash3d.com/products/victorian | **$145** | same | victorian | 5 | 103 models. Most direct answer for the Victorian Scholar theme. Only premium kit specifically Victorian — nothing in Synty fills this gap. |
| Art Nouveau (Parisian) | https://kitbash3d.com/products/parisian | **$145** | same | victorian, modern_loft | 4 | 68 models, neo-classical Paris. Elegant alternative to Victorian for the scholar theme. |
| Ghost Realm | https://kitbash3d.com/products/ghost-realm | **$245** | same | gothic | 4 | 105 models — gothic + supernatural. Manus's "Gothic" replacement. **Caution:** leans haunted-mansion which the brief explicitly rejects. |
| Dark Fantasy | https://kitbash3d.com/products/dark-fantasy | **$145** | same | gothic | 4 | 110 models, 2.6M polys. Shadowy castles, gargoyles, "magnificent edifices." More "mystic vertical cathedral" than "horror" — better fit than Ghost Realm. |
| Shogun | https://kitbash3d.com/products/shogun | **$245** | same | ryokan | 5 | 234 models, 106 PBR materials. Largest premium Japanese architecture kit on the market. |
| Americana | https://kitbash3d.com/products/americana | **$245** | same | cottage | 4 | 268 models — suburban houses, libraries, mobile homes, mall. Brief's reference is "ET, Sandlot, Stand By Me" nostalgia. Excellent for cottage if you want "warm small-town Americana." |
| Wasteland | https://kitbash3d.com/products/wasteland | **$145** | same | fallout | 3 | 61 models — broken trailers, ramshackle warehouses, oil tankers. More "Mad Max derelict" than the calm "oxidized metal" the brief wants. Useable in pieces. |
| Brooklyn | https://kitbash3d.com/products/brooklyn | **$145** | same | modern_loft | 3 | 66 models — red brick, residential, skyscrapers. Closest exterior architecture for "modern luxury loft" feel; not interiors. |
| Medieval Market | https://kitbash3d.com/products/medieval-market | **$95** | same | cottage, victorian | 3 | 201 models, $95 — cheapest KB3D kit. Stalls, market structures. Useful filler for cottage exteriors. |
| Enchanted | https://kitbash3d.com/products/enchanted | **$245** | same | gothic (whimsical), cottage | 4 | 129 models — fairy-tale castles, villages. Tonally closer to Ghibli than any other KB3D kit. |
| **Cargo Free Tier** | https://kitbash3d.com/pages/cargo | **$0** | commercial | sampling | n/a | 100+ free sample assets, no card. **Try this first** before committing $145+. |
| **Cargo: KB3D Library** | https://kitbash3d.com/pages/pricing | **$59/mo** ($708/yr) | full commercial, perpetual while subscribed | all themes | n/a | Best path if you want 4+ kits. Per-kit equivalent ~$15 if you grab 4 kits in a year. **Note:** assets are perpetually licensed for projects in progress while subscribed — verify project-end retention with KB3D before unsub. |

---

## 3. itch.io paid Godot shaders & VFX

**Critical correction:** the Manus document's prices for Binbun shaders ($20–$25) are wrong. **The real Binbun handle is `binbun3d` not `binbun` — the URLs Manus published 404.** All Binbun individual products are CC0 with optional pay-what-you-want minimums of $3.75–$4.49. The smart purchase is the Effects Collection bundle at $26.25 which contains all shaders + 12 VFX packs.

**Licence (game distribution):**
- **Binbun:** CC0 — fully usable in commercial games, no attribution required. (Individual products explicitly state "personal, educational and commercial projects with no attribution required.")
- **Bukkbeek (EffectBlocks):** "Use in commercial and non-commercial projects, do not resell or redistribute as-is or modified." Game shipping fine; pack redistribution prohibited.

| Product | URL | Price | Licence | Themes served | Fit (1-5) | Why valuable / cheaper alt? |
|---|---|---|---|---|---|---|
| Godot Skies (Binbun) | https://binbun3d.itch.io/godot-skies | PWYW, **$3.75 min** for full version | CC0 | all (esp. ryokan, cottage, garden) | 5 | 24 sky presets (10 realistic + 10 stylized + 4 experimental). Native Godot 4.x. Free version is just the shader; paid adds presets. Buy this. |
| Godot Ultimate Toon Shader (Binbun) | https://binbun3d.itch.io/godot-ultimate-toon-shader | PWYW, **$4.49 min** for full | CC0 | all | 5 | 22 preset materials "from basic toon to painterly." Godot 4.x. **This is the single most important purchase** for closing the gap between Synty low-poly and the painterly target. |
| Godot Effects Collection Vol. 1 (Binbun) | https://binbun3d.itch.io/effects-collection-vol1 | **$26.25** (25% off $35) | CC0 | all | 5 | Bundle: 12 VFX packs (fire, impact, magic-area, magic-orb, smoke, ice, poison, portal, beam, loot, muzzle-flash, magic-projectile) + 8 shaders w/ presets (transitions, skies, toon, grass, water, glass UI, card FX, hologram FX). 300+ effects, CC0. **Best dollar value on the entire premium list.** |
| Magic Area VFX (Binbun) | https://binbun3d.itch.io/magic-area-vfx | **$4.49** (25% off $5.99) | CC0 | all (mnemonic interactables) | 5 | 30 magical area effects, customizable via @tool scripts. Caveat: Forward+ renderer issue in Godot 4.6.x — Compatibility mode safer. Godot 4.0 should be fine. |
| Magic Orb VFX (Binbun) | https://binbun3d.itch.io/magic-orb-vfx | **$4.49** | CC0 | all (mnemonic objects) | 5 | 30 orb/spell effects. Pair with Magic Area for the "symbolic task object" interaction VFX in the brief. |
| EffectBlocks (Bukkbeek) | https://bukkbeek.itch.io/effectblocks | **$9.99** (or more) | Commercial OK, no resale | all | 4 | 100+ low-poly 3D VFX (fire/smoke/combat/energy/magic/nature/water). Godot 4.4+ (NOT verified for Godot 4.0 — recommend testing or upgrading engine). Less painterly than Binbun, more general-purpose. |

**Recommendation:** the Binbun Effects Collection Vol. 1 at $26.25 dominates this category — it includes Godot Skies + Toon Shader + 30+ other effects, all CC0. Buying individual Binbun packs only makes sense if you want to test one before committing.

---

## 4. itch.io paid music / audio

**Licence:** PixelLoops packs are royalty-free for commercial games but explicitly prohibit "redistribution as standalone music." Embedding in shipped games is fine. Airyluvs Japanese pack is "royalty-free" with terms of service to confirm before purchase.

| Product | URL | Price | Licence | Themes served | Fit (1-5) | Why valuable / cheaper alt? |
|---|---|---|---|---|---|---|
| Sci-Fi Ambient Music Pack (PixelLoops) | https://pixelloops.itch.io/sci-fi-ambient-music-pack-20-loopable-tracks-for-games | **$4.49** (10% off $4.99) | Royalty-free, commercial OK, no resale | scifi | 4 | 20 loopable tracks, WAV+MP3+OGG, 748MB. Tone is "space exploration, cyberpunk, atmospheric" — fits "contemplative sci-fi" reasonably well. |
| Fantasy Tavern Music Pack (PixelLoops) | https://pixelloops.itch.io/fantasy-tavern-music-pack-12-cozy-rpg-loops-wav-mp3 | **$4.49** | royalty-free | cottage, ryokan (warm room), foyer | 5 | 12 cozy RPG loops, WAV+MP3, 353MB. "Tavern, inn, town, campfire, cozy" — directly hits the cottage/foyer ambient brief. |
| Calm Menu Music Pack (PixelLoops) | https://pixelloops.itch.io/main-menu-music-pack-10-calm-game-menu-loops-wav-mp3 | **$4.49** | royalty-free, no resale | foyer, library, all UI | 4 | 10 ambient loops, "soft piano, calm atmospheric, indie background." Excellent for the meditative menu/foyer state. |
| Dark Ambient Game Music Pack (PixelLoops vol 4) | https://pixelloops.itch.io/game-loops-vol4-dark-ambient-mystery | **$4.49** | royalty-free | cellar, gothic, fallout | 4 | 10 dark ambient + 10 short loop variants. "Mystery, escape room, narrative indie." Fits cellar / gothic mood — not horror, but contemplative-dark. |
| Japanese-Style Game Music Collection (Airyluvs) | https://airyluvs.itch.io/japanese-style-game-music-collection | **$49.00 min** | royalty-free (verify ToS) | ryokan | 5 | 21 tracks (1 vocal + 20 instrumental) using Shakuhachi, Koto, Shamisen. Seamless OGG loops included. Highest-quality dedicated Japanese pack found. **No cheaper equivalent** — generic "Asian" loops on itch are noticeably worse. |

**No good "Victorian scholar / library" paid pack found** — the closest is PixelLoops Calm Menu (piano/ambient) which works as scholarly background. If a dedicated dark-academia pack matters, expect to commission or curate from Sonniss GDC bundles (free, covered by other agent).

**No good dedicated "Greco-Roman" paid pack found.** Generic ambient + Calm Menu cover it.

---

## 5. Sketchfab / Fab

| Product | URL | Price | Licence | Themes served | Fit (1-5) | Why valuable / cheaper alt? |
|---|---|---|---|---|---|---|
| Traditional Japanese Scenery Props (IanaM) | https://sketchfab.com/3d-models/traditional-japanese-scenery-props-9b557aeb8c0947a5b321616867d147ec | **price not visible without Fab.com checkout** (hosted at https://www.fab.com/listings/687bd0cc-8783-4aee-b279-2f1105a77b4b — returned 403 to recon) | Fab Standard licence (commercial OK by default) | ryokan, garden | 4 | 8 props — gazebo, stone+wood lanterns w/ lights, bell tower. PBR materials. ~68k tris combined. Stylistically cohesive. |
| Traditional Japanese House with Lanterns (IanaM) | https://sketchfab.com/3d-models/traditional-japanese-house-with-lanterns-50912108044e4c1992438fc97cab48f4 | **price not visible without Fab.com checkout** | Fab Standard | ryokan | 4 | Single hero building. 83k tris. Modular shoji-style windows, 6 lantern garlands × 8 lanterns each w/ individual lights. |

**The Manus-cited "Stylized Japanese Village Environment by IanaM" does not exist.** The actual IanaM products are the two above (props kit + single house) sold separately on Fab. Other comparable Fab listings in the search (Stylized Japanese Market by Cgi_Guy, Japan Village, Stylized Japanese Street with 133 assets) exist but pricing again only visible at Fab checkout and weren't fetchable by recon. Synty Samurai Pack at $15 is a much cheaper coverage answer; Shogun KitBash at $245 is the high end. **Conclusion: skip Sketchfab/Fab unless one specific hero asset is missing after Synty + Shogun.**

---

## PREMIUM PRIORITY LIST

### Budget tier 1: ~$100 — "stylize what you have"
This buys you the painterly look on top of the existing CSG and free-asset rooms. It does NOT buy environment kits. Best ROI per dollar on the entire list.

| Buy | Price | Why |
|---|---:|---|
| Binbun Effects Collection Vol. 1 (bundle) | $26.25 | 24 sky presets + 22 toon-material presets + 300+ VFX, CC0, native Godot 4.x. **Single highest-leverage purchase.** |
| PixelLoops Fantasy Tavern Music Pack | $4.49 | Cottage/foyer ambient — 12 cozy loops |
| PixelLoops Calm Menu Music Pack | $4.49 | Library/menu ambient — 10 piano-driven loops |
| PixelLoops Dark Ambient Music Pack | $4.49 | Cellar/gothic/fallout — 10 contemplative-dark loops |
| PixelLoops Sci-Fi Ambient Music Pack | $4.49 | Sci-Fi rooms — 20 ambient loops |
| Synty POLYGON - Samurai Pack | $15.00 | Ryokan modular kit, best ratio for one missing theme |
| Synty POLYGON - Adventure Pack | $15.00 | Cottage/garden filler, characters + flora |
| Synty POLYGON - Knights Pack | $15.00 | Gothic-ish modular church/castle entry, also winter variants |
| **TOTAL** | **~$89** | |

### Budget tier 2: ~$300 — "anchor each theme with a real kit"
Adds a couple more Synty packs and one mid-tier KB3D kit to give one or two themes signature architecture.

Tier 1 above ($89), plus:
| Add | Price | Why |
|---|---:|---|
| Synty POLYGON - Town Pack | $25.00 | Cottage exterior + Godot 4.5.1 native project |
| Synty POLYGON - Office Pack | $25.00 | Modern_loft (better than Heist for the brief) — caveat sold-out |
| Synty POLYGON - Meadow Forest Biome | $27.50 | Garden + cottage nature, Ghibli-leaning |
| KitBash3D - Medieval Market | $95.00 | Cheapest KB3D kit, $95, modular market for cottage exteriors w/ real PBR fidelity |
| Airyluvs Japanese Music Collection | $49.00 | Real shamisen/koto/shakuhachi for Ryokan (replaces fake substitutes) |
| **SUBTOTAL ADD** | **$221.50** | |
| **CUMULATIVE** | **~$311** | |

### Budget tier 3: ~$1000 — "production-quality flagship themes"
Tiers 1+2 above (~$311), plus three premium architecture anchors targeting the highest-impact themes. This is the budget where the game starts to look like the reference (Journey/Witness/ABZÛ) for at least 2-3 rooms. Note: these are individual licences — solo developer only.

| Add | Price | Why |
|---|---:|---|
| KitBash3D - Elysium | $195.00 | Greco-Roman flagship. Highest aesthetic ROI on the entire list. Levitating mythic-Mediterranean — no substitute. |
| KitBash3D - Victorian | $145.00 | Only credible Victorian premium kit. Synty Fantasy Kingdom is the alternative at $175 but is low-poly. |
| KitBash3D - Shogun | $245.00 | Definitive Ryokan architecture — 234 models, 106 materials. Heavy but unrivaled. |
| Synty POLYGON - Fantasy Kingdom | $175.00 | (Optional swap for Victorian if you want low-poly cohesion across all themes — and ships native Godot 4.5.1 project.) |
| **SUBTOTAL ADD (Elysium+Victorian+Shogun)** | **$585** | |
| **CUMULATIVE** | **~$896** | |

**Alternative tier 3 strategy:** instead of three KB3D kits at $585, subscribe to **Cargo: KitBash3D Library at $708/yr** which unlocks all kits including Elysium, Victorian, Shogun, Atlantis, Roman Empire, Americana, Dark Fantasy. Better economics if you want 4+ kits — and you can cancel after the project's content lock (verify with KB3D first that already-imported assets retain their licence after unsub).

### Skip / caution list
- **POLYGON - Heist** — wrong vibe for modern_loft (crime thriller). Use Office Pack instead.
- **POLYGON - Apocalypse Wasteland** at $114 — Mad Max framing fights the brief. Use only if you actually want post-apocalyptic combat aesthetics.
- **KitBash3D - Wasteland** at $145 — same issue, more derelict than calm-decay.
- **KitBash3D - Ghost Realm** at $245 — leans "haunted house" which the brief explicitly rejects. Use Dark Fantasy ($145) instead for gothic.
- **Sketchfab/Fab IanaM packs** — exist but pricing opaque without Fab account, and Synty Samurai at $15 covers most of what they offer. Only worth it for hero-shot specific assets.
- **Old Manus-cited URLs (binbun.itch.io/, kitbash3d.com/products/gothic, syntystore.com/products/polygon-victorian, polygon-shops, polygon-ancient-empire-pack, sketchfab "stylized-japanese-village-environment-...")** — all return 404. Do not use.

---

## Notes on Godot 4.0 compatibility (per MEMORY.md)

- **Synty Fantasy Kingdom and Town Pack** ship Godot 4.5.1 projects — your project is on 4.0. The .tscn format is compatible across 4.x but materials/lights may need re-saving in 4.0. Lower-effort path: import the FBX source files instead of opening the 4.5.1 project.
- **Binbun shaders** are Godot 4.x — confirmed against 4.0 baseline by the asset descriptions. Magic Area VFX has a known Forward+ rendering issue in 4.6.1+ that doesn't apply to 4.0 (Mobile profile uses Compatibility renderer anyway).
- **EffectBlocks (Bukkbeek)** says "Godot 4.4+" — recon could not verify 4.0 backwards-compat. Test with a refund-eligible purchase or upgrade engine.
- **KitBash3D** has no Godot-native files. Plan for FBX import + manual material rebuild for any KB3D kit. The Cargo app does not support Godot directly.
