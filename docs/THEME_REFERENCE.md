# MindHause — Theme Reference

> Complete design spec for all 8 house themes. Each theme is a full aesthetic world with architecture, textures, lighting, cat familiar, and monetizable DLC skin potential. Used across the website, Flutter app skins, and Godot palace rooms.

---

## Design Principles

- Every theme must feel like a **sanctuary + war-room for thought**
- Serene, inviting, but purposeful — this is where you organize your life
- Sense of space, openness, welcome
- Each room communicates its function (Tasks, Notes, Calendar, Projects)
- The matching cat familiar is always present
- Consistency across: website hero banner, app theme skin, Godot 3D assets
- Camera angle and composition style consistent across all theme images (16:9, 1920x1080)

---

## The 8 Official Themes

### 1. Greco-Roman Classic (Default)

**Palette:** warm cream, marble white, gold, terracotta
**Materials:** marble, gold trims, mosaic tile, plaster columns
**Lighting:** sunlit through arches, warm flame lamps, golden hour glow
**Textures:** polished marble (4096x4096 seamless), mosaic borders, warm stone
**Iconography:** laurel wreaths, scrolls, amphorae, ionic columns
**Atmosphere:** grand, sunlit, classical civilization at its peak

**Cat Familiar:** Pale cream, dignified bearing, possibly with a tiny gold collar. Think: a cat that lives in a Roman senator's villa and knows it.

**Timepiece:** Sundial — a stone pedestal sundial in the garden or courtyard, with a bronze gnomon. Indoors, a Roman-style water clock (clepsydra) with a carved marble basin and slow dripping mechanism. Historically authentic to the theme's origin as the birthplace of the method of loci.

**Godot Notes:** This is the default theme. All 10 room CSG materials currently use this palette (warm marble floor 0.92/0.88/0.82, cream walls 0.95/0.92/0.87). The foyer chandelier warmth (1.0/0.95/0.85) matches the golden-hour lighting.

---

### 2. Modern Loft

**Palette:** charcoal, concrete grey, cool white, electric blue accents
**Materials:** exposed concrete, brushed steel, frosted glass, matte black fixtures
**Lighting:** cool LED strips, blue accent lighting, large windows with city views
**Textures:** raw concrete (4096x4096 seamless), brushed metal, frosted glass panels
**Iconography:** clean lines, minimal sans-serif labels, floating shelves
**Atmosphere:** sleek, urban, focused productivity

**Cat Familiar:** Grey or steel-blue short hair. Sleek and modern, the kind of cat that sits on a minimalist shelf and looks like a design object.

**Timepiece:** Minimalist digital wall clock — a flush-mounted LED display on brushed steel, showing time in clean sans-serif digits. Subtle blue glow pulses gently on the hour. Think: the kind of clock you'd find in a high-end co-working space.

**Godot Notes:** Swap CSG materials to concrete grey floors (~0.45/0.45/0.45), dark walls (~0.3/0.3/0.32). Add blue-tinted OmniLight3D accent lights. Cool white ambient (0.9/0.92/1.0).

---

### 3. Victorian Scholar

**Palette:** deep green, burgundy, walnut, brass
**Materials:** carved wood, leather, velvet, embossed wallpaper
**Lighting:** gaslamps, amber glow, brass desk lamps, warm fireplace
**Textures:** polished woodgrain (4096x4096 seamless), embossed wallpaper pattern, leather
**Iconography:** fountain pens, brass compasses, magnifying glasses, leather-bound books
**Atmosphere:** warm, academic, intimate — a naturalist's study

**Cat Familiar:** Black or dark tabby with academic presence. The kind of cat that sits on an open book and stares at you like it's grading your thesis.

**Timepiece:** Grandfather clock — tall mahogany case with brass face, roman numeral dial, visible pendulum behind bevelled glass. Ticks audibly. In the study, a smaller brass mantel clock with exposed gears sits on the desk. Steampunk-adjacent without going full fantasy — grounded in real Victorian horology.

**Godot Notes:** Dark wood floor materials (~0.35/0.25/0.15), deep green walls (~0.2/0.35/0.2). Warm amber OmniLight3D for gaslamp feel (1.0/0.8/0.5). Low ambient energy (0.25).

---

### 4. Sci-Fi Minimal (White Neon)

**Palette:** pure white, cyan, holographic shimmer, matte grey
**Materials:** smooth white panels, translucent displays, holographic UI elements
**Lighting:** cyan neon strips, soft diffused white, holographic glow
**Textures:** smooth white panels (4096x4096 seamless), subtle grid lines, holographic overlays
**Iconography:** holographic interfaces, 3D data visualizations, floating UI elements
**Atmosphere:** clean, futuristic, organized — a command center from the future

**Cat Familiar:** White or silver, sleek build, possibly with a subtle holographic collar or faintly glowing eyes. Elegant and otherworldly.

**Hero Image Notes:** Should include a holographic 3D futuristic interface in the scene — a desk with floating screens or a command console. The sense of organization the app is built around should be visible.

**Timepiece:** Holographic time projection — a floating, translucent cyan display that hovers above a small emitter disc on a surface. Digits shimmer and rotate subtly. Could show additional data (date, timezone, next task due) in smaller orbiting text. The most "functional" of all the timepieces — information-dense but visually clean.

**Godot Notes:** Near-white floor/walls (~0.95/0.95/0.97), cyan accent lights (0.0/0.9/1.0). Add emissive strips using StandardMaterial3D with emission enabled. Very high ambient (0.8).

---

### 5. Gothic Cathedral

**Palette:** deep purple, stone grey, midnight blue, candlelight gold
**Materials:** stone arches, iron fixtures, stained glass, heavy wood pews
**Lighting:** candlelight (warm orange points), stained glass color bleed, purple ambient, low fog
**Textures:** rough stone (4096x4096 seamless), iron-studded wood, stained glass patterns
**Iconography:** pointed arches, rose windows, illuminated manuscripts, iron candelabras
**Atmosphere:** awe-inspiring, scholarly, devotional — a monk's scriptorium beneath vaulted ceilings

**Cat Familiar:** Long-haired black or shadowy gray. Moves through candlelight like a living shadow. Knows all the hidden passages.

**Hero Image Notes:** Prioritize sense of awe — depth, height, vaulted ceilings. Stained glass windows should be lit up. Scholarly monk energy. Different room names for the cathedral context (Scriptorium, Nave, Cloister, etc.).

**Timepiece:** Astronomical clock — a large ornate clock face mounted on a stone wall, inspired by the Prague Orloj. Concentric rings show hours, moon phases, and zodiac positions. Iron hands move in real time. Smaller rooms get a monastic hourglass on a wooden stand — sand trickling through, periodically flipped by an unseen hand.

**Godot Notes:** Dark stone floor (~0.3/0.28/0.25), grey walls (~0.4/0.38/0.35). Low ambient (0.1-0.15). Multiple warm OmniLight3D at low energy (0.4-0.6) for candle clusters. Purple-tinted environment ambient (0.3/0.2/0.4). FogVolume for atmosphere.

---

### 6. Japanese Ryokan

**Palette:** warm wood, cream, soft green, cherry blossom pink, paper lantern gold
**Materials:** tatami mats, shoji screens (paper + wood lattice), bamboo, lacquered wood
**Lighting:** paper lantern warm glow, diffused natural light through shoji, subtle moonlight
**Textures:** tatami weave (4096x4096 seamless), wood plank, shoji paper, bamboo
**Iconography:** calligraphy brushes, ikebana arrangements, torii gate motifs, paper fans
**Atmosphere:** tranquil, meditative, every object placed with intention — wabi-sabi aesthetic

**Cat Familiar:** Calico or warm-toned Japanese bobtail. Sits neatly on tatami like it's meditating. Small and compact.

**Timepiece:** Incense clock (koudokei) — a long wooden tray with a continuous line of incense ash tracing a pattern. Small weighted markers hang at intervals along the incense trail; as it burns, markers drop with a soft clink to mark the hours. Alternatively, a shaku-dokei (traditional Japanese pillar clock) with a sliding weight mechanism. Deeply meditative — you tell the time by how far the incense has burned.

**Godot Notes:** Tatami-toned floor (~0.72/0.65/0.45), cream walls (~0.9/0.87/0.8). Warm lantern lights (1.0/0.9/0.7) at low energy (0.5-0.7). Natural feel — no harsh shadows.

---

### 7. Countryside Cottage

**Palette:** warm cream, honey, sage green, terracotta, timber brown
**Materials:** exposed timber beams, lime-washed plaster, handmade tiles, copper fixtures
**Lighting:** warm sunlight through small windows, fireplace glow, copper oil lamps
**Textures:** lime plaster (4096x4096 seamless), timber grain, handmade tile, woven textile
**Iconography:** dried herbs, copper pots, hand-bound journals, wildflower vases
**Atmosphere:** cozy, nurturing, creative — where ideas grow organically

**Cat Familiar:** Ginger or warm-toned fluffy companion. The quintessential cottage cat — probably asleep by the fireplace.

**Timepiece:** Cuckoo clock — carved wooden case with leaf and bird motifs, hanging pine cone weights, swinging pendulum. The cuckoo door opens on the hour (with sound). In the kitchen, a simpler wall-mounted round clock with hand-painted flowers on the face. Charming, handcrafted, slightly whimsical.

**Godot Notes:** Warm wood floor (~0.6/0.48/0.32), cream plaster walls (~0.92/0.88/0.82). Fireplace-tinted lights (1.0/0.85/0.6) plus cooler window light (0.95/0.95/1.0). Cozy ambient (0.4).

---

### 8. Fallout Bunker (Post-Apocalyptic)

**Palette:** rust orange, military olive, corroded metal, radiation green accents, warning yellow
**Materials:** corrugated steel, exposed pipes, cracked concrete, salvaged electronics, hazard tape
**Lighting:** flickering fluorescents (slightly green-tinted), emergency red spots, CRT monitor glow
**Textures:** rusted metal panels (4096x4096 seamless), cracked concrete, hazard stripes, grime overlays
**Iconography:** Geiger counters, duct-taped terminals, salvage crates, vault doors, pip-boy style UI elements
**Atmosphere:** resourceful, gritty survival meets ingenuity — a bunker where someone brilliant is keeping the world running with duct tape and determination

**Cat Familiar:** Scrappy but resilient — maybe a one-eared tabby with a bandana, or a lean tortoiseshell that's clearly the real boss of the bunker. Survival instincts sharp.

**Timepiece:** Jury-rigged industrial clock — a salvaged analog wall clock with cracked glass and a bent hour hand, still ticking defiantly. The face has hand-scratched tally marks where numbers should be. In the command room, a bank of mismatched digital readouts cobbled from old CRT monitors showing time, radiation levels, and days-since-last-incident (always suspiciously low). Resourceful, battered, still working.

**Godot Notes:** Dark concrete floor (~0.35/0.33/0.3), rust-tinged walls (~0.5/0.4/0.32). Green-tinted fluorescent lights (0.8/0.95/0.75) at medium energy. Occasional red emergency OmniLight3D. Low ambient (0.2) with slight green tint.

---

## Theme Timepieces

Every theme has a signature way of telling the time. These aren't decorative — they're functional objects that display the user's real local time, tying the palace to reality and grounding the experience. The timepiece is the one object in the palace that the player never placed and can't move. It belongs to the house.

### Design Principles

- **Thematically authentic.** Each timepiece should feel like the *only* kind of clock that could exist in that world.
- **Readable at a glance.** The player should be able to look at it and know roughly what time it is without interaction.
- **Tied to `time_of_day.gd`.** The existing system tracks 6 time periods (dawn/morning/afternoon/dusk/evening/night) and updates lighting every 60 seconds. Timepieces should reflect the same real clock and complement the lighting shifts.
- **Ambient sound opportunity.** Ticking, chiming, dripping, burning — each timepiece adds to the room's soundscape. Hourly chimes or marker sounds double as gentle time-awareness nudges (helpful for ADHD time-blindness).
- **One per room** (foyer always gets the "hero" timepiece; other rooms may get a smaller variant or none).

### Summary Table

| Theme | Primary Timepiece | Secondary (smaller rooms) | Key Sound |
|-------|------------------|---------------------------|-----------|
| Greco-Roman | Stone sundial / water clock (clepsydra) | Bronze water clock | Dripping water |
| Modern Loft | Flush LED wall display | — (same, smaller) | Soft hourly beep |
| Victorian Scholar | Mahogany grandfather clock | Brass mantel clock with exposed gears | Pendulum tick, Westminster chime |
| Sci-Fi Minimal | Holographic floating projection | Smaller emitter disc | Soft digital pulse |
| Gothic Cathedral | Astronomical clock (Orloj-style) | Monastic hourglass | Deep bell toll |
| Japanese Ryokan | Incense clock (koudokei) | Pillar clock (shaku-dokei) | Marker clink, burning hiss |
| Countryside Cottage | Carved cuckoo clock | Hand-painted kitchen clock | Cuckoo call, ticking |
| Fallout Bunker | Salvaged cracked analog clock | CRT bank readout | Erratic ticking, static hum |

### Implementation Notes

**Model requirements:**
- Each primary timepiece: 500–2,000 tris, `.glb` format
- Secondary variants: 200–500 tris
- Animated elements (pendulum, hands, dripping, burning incense) via AnimationPlayer or shader
- Clock faces/displays update from `time_of_day.gd` via a `timepiece.gd` script

**Godot script (`timepiece.gd`):**
- Attached to all timepiece scene instances
- Reads system time (same source as `time_of_day.gd`)
- Updates visual state: rotates clock hands, advances incense burn, updates digital readout text
- Triggers hourly sound (theme-specific chime/toll/beep/clink) via AudioManager
- Sundial variant adjusts gnomon shadow angle based on DirectionalLight3D position

**Asset file paths:**
```
godot_palace/models/timepieces/
  sundial.glb              # Greco-Roman (outdoor)
  clepsydra.glb            # Greco-Roman (indoor)
  digital_clock.glb        # Modern Loft
  grandfather_clock.glb    # Victorian Scholar
  mantel_clock.glb         # Victorian Scholar (secondary)
  holo_clock.glb           # Sci-Fi Minimal
  astronomical_clock.glb   # Gothic Cathedral
  hourglass.glb            # Gothic Cathedral (secondary)
  incense_clock.glb        # Japanese Ryokan
  pillar_clock.glb         # Japanese Ryokan (secondary)
  cuckoo_clock.glb         # Countryside Cottage
  kitchen_clock.glb        # Countryside Cottage (secondary)
  salvaged_clock.glb       # Fallout Bunker
  crt_readout.glb          # Fallout Bunker (secondary)
```

**Audio file paths (hourly chimes):**
```
godot_palace/audio/sfx/
  chime_water_drip.ogg     # Greco-Roman
  chime_digital.ogg        # Modern Loft
  chime_westminster.ogg    # Victorian Scholar
  chime_holo_pulse.ogg     # Sci-Fi Minimal
  chime_cathedral_bell.ogg # Gothic Cathedral
  chime_incense_clink.ogg  # Japanese Ryokan
  chime_cuckoo.ogg         # Countryside Cottage
  chime_bunker_static.ogg  # Fallout Bunker
```

---

## Texture Sheet Specifications

Each theme needs one seamless texture sheet (4096x4096):

| Theme | Primary Texture | Description |
|-------|----------------|-------------|
| Greco-Roman | Marble | Warm white marble with subtle gold veining |
| Modern Loft | Concrete | Raw concrete with subtle aggregate visible |
| Victorian Scholar | Woodgrain | Polished walnut with deep grain pattern |
| Sci-Fi Minimal | Panels | Smooth white panels with faint grid lines |
| Gothic Cathedral | Stone | Rough-cut grey stone blocks with mortar lines |
| Japanese Ryokan | Tatami | Woven rush mat pattern, warm golden |
| Countryside Cottage | Plaster | Lime-washed plaster with subtle texture variation |
| Fallout Bunker | Rusted Metal | Corroded steel panels with rivets and grime |

These textures tile seamlessly and are used for:
- Godot room floors/walls (applied via StandardMaterial3D albedo_texture)
- Website background patterns
- App UI texture overlays

---

## Hero Hallway Image Specifications

Each theme has a hero hallway image (1920x1080, 16:9 landscape):

- Same camera angle: standing at one end of a hallway/corridor, looking in
- Depth and perspective — draw the eye inward
- The theme's cat familiar visible somewhere in the scene
- Room function labels visible on doors or signs (Tasks, Notes, Calendar, Projects)
- Full theme materials and lighting applied
- A table, desk, or workspace element with "a few bits and pieces" to suggest activity

**Generated So Far:**
- [x] Greco-Roman Classic — hero hallway + table version
- [x] Modern Loft — hero hallway
- [x] Victorian Scholar — study with desk + turned-up lamps + natural history vibe
- [x] Sci-Fi Minimal — with holographic interface
- [x] Gothic Cathedral — stained glass, vaulted, awe-inspiring
- [x] Japanese Ryokan — tranquil hallway
- [x] Countryside Cottage — warm interior
- [x] Fallout Bunker — post-apocalyptic command center

---

## Applying Themes in Godot

To switch themes at runtime, the room CSG materials need to be swapped. Strategy:

1. **Theme resource files** — create a `.tres` resource per theme containing the material colors, light colors, ambient settings
2. **room_manager.gd** — on room load, apply the active theme's materials to all CSGBox3D children
3. **time_of_day.gd** — each theme can override the lighting presets (e.g., Gothic is always dimmer)
4. **Cat model swap** — each theme's cat has different mesh/material

The current Greco-Roman colors in all room .tscn files serve as the default. Theme switching overlays new materials at runtime rather than requiring separate scene files per theme.

---

## Cross-Platform Consistency

| Asset | Website | Flutter App | Godot Palace |
|-------|---------|-------------|--------------|
| Hero image | Homepage banner | Theme preview card | Loading screen |
| Texture sheet | CSS background-image | ThemeData surface | StandardMaterial3D albedo |
| Cat | Hero image element | Avatar icon | 3D model + AnimationTree |
| Color palette | CSS variables | ColorScheme | Material albedo_color + light_color |
| Room names | Navigation labels | Screen titles | Door labels + HUD |

---

## DLC / Monetization

Each theme beyond Greco-Roman (the default) is a potential paid skin:
- **Theme Pack** = texture sheet + hero art + cat model + color palette + room name set
- Bundle all visual assets per theme into a downloadable pack
- Apply via settings toggle — no gameplay difference, purely aesthetic
- The Fallout Bunker theme was added by popular inspiration and could be a "special edition" pack

---

*Theme reference for MindHause. Sourced from design sessions 2026-02-15.*
