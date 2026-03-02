# MindHause — Asset Strategy

> How to build a 3D memory palace without a full art team. Smart shortcuts, free resources, and AI-assisted workflows.

---

## The Reality Check

Building a fully furnished two-storey Greco-Roman villa with 10+ rooms, interactive objects, a cat, and monsters sounds like it needs a 3D art team and six months of production. It doesn't — but it does need strategy.

The key insight: **MindHause is a productivity app with a 3D layer, not a AAA game.** The visual bar is "charming and functional," not "photorealistic." Low-poly, stylised, warm. Think Firewatch or A Short Hike, not Skyrim.

---

## Asset Categories & Sourcing

### 1. Room Geometry (Walls, Floors, Ceilings, Architecture)

**What you need:** 10 rooms, hallways, stairs, basement. Roughly 15-20 distinct environments.

**Strategy: Modular BSP-style construction**

- Build rooms from **modular wall/floor/ceiling pieces** rather than unique meshes for every room
- A column piece, an arch piece, a wall segment, a floor tile, a staircase — mix and match
- 20-30 modular pieces can build the entire house

**Sources:**
| Source | Cost | Notes |
|--------|------|-------|
| [Kenney.nl](https://kenney.nl/) | Free (CC0) | Excellent modular building kits, low-poly style |
| [Quaternius](https://quaternius.com/) | Free (CC0) | Low-poly furniture, architecture, nature packs |
| [Kay Lousberg](https://kaylousberg.itch.io/) | Free / donation | Great low-poly environment packs |
| [itch.io 3D assets](https://itch.io/game-assets/tag-3d) | Free–$20 | Huge variety, search "low-poly room" or "medieval interior" |
| Godot Asset Library | Free | Community-submitted scenes and models |
| **Build your own** (Blender) | Time | CSG operations in Blender or even Godot's CSG nodes for basic rooms |

**Pro tip:** Start with Godot's built-in **CSG nodes** (CSGBox3D, CSGCylinder3D, CSGPolygon3D) for room geometry. You can build surprisingly decent rooms with just CSG before ever touching Blender. Add detail meshes (columns, arches) from asset packs later.

---

### 2. Textures & Materials

**What you need:** Stone, marble, wood, terracotta, parchment, metal. The Greco-Roman palette.

**Strategy: AI generation + free texture libraries**

| Source | Cost | Notes |
|--------|------|-------|
| [Poly Haven](https://polyhaven.com/) | Free (CC0) | PBR textures, superb quality, marble/stone/wood available |
| [AmbientCG](https://ambientcg.com/) | Free (CC0) | Large PBR texture library |
| [Midjourney / DALL-E / Stable Diffusion](https://stability.ai/) | Sub or free | Generate tileable textures with AI. Prompt: "seamless tileable marble texture, warm ivory, 1024x1024" |
| **mindhause-spaces textures** | Already yours | The website repo has themed texture samples — use as reference or directly |
| Godot shader-based | Free | Use Godot's visual shader editor to create procedural materials (marble veining, worn stone) |

**Pro tip:** Generate a small set of **hero textures** (5-6 materials: marble, warm stone, dark wood, terracotta tile, parchment, bronze metal) and reuse them across the entire house. Consistency in palette is more important than variety.

---

### 3. Task Objects (10 Types)

**What you need:** Scroll, book, candle, statue, letter, blueprint, plant, post-it, jar, key.

**Strategy: Simple meshes, distinguish by material/glow**

These objects are small. They don't need high detail. A scroll is a cylinder with a parchment texture. A book is a box with a cover texture. The visual distinction comes from:

- **Shape** (cylinder, box, sphere variants — can start with primitives)
- **Material colour** (warm tones per type)
- **Glow colour** (priority-based: green/amber/red)
- **Particle effects** (for corruption/monster states)

| Source | Cost | Notes |
|--------|------|-------|
| [Kenney](https://kenney.nl/assets/category:3D) | Free | Has books, potions, keys, candles in low-poly |
| [Quaternius RPG packs](https://quaternius.com/) | Free | Scrolls, books, potions, chests, keys |
| Godot primitive meshes | Free | CylinderMesh, BoxMesh, SphereMesh — genuinely sufficient for v1 |
| Blender quick models | Time | 10 simple objects take 2-3 hours in Blender for a beginner |

**Current implementation:** The `task_object.gd` script already creates primitive meshes procedurally (cylinder for scroll, box for book, etc.). This works for development and is honestly acceptable for v1 — just add proper materials.

---

### 4. The Cat

**What you need:** One animated cat model with: idle, walk, run, sit, sleep, hiss, purr/happy poses.

**Strategy: This is the one model worth investing in**

The cat is on screen constantly and is emotionally central to the experience. Options:

| Option | Cost | Quality | Notes |
|--------|------|---------|-------|
| [Quaternius animals pack](https://quaternius.com/) | Free | Good low-poly | Includes a cat. May need animation work |
| [Mixamo](https://www.mixamo.com/) | Free | High quality | Auto-rigging + animation. Upload a cat mesh, get walk/idle/run anims |
| [Sketchfab](https://sketchfab.com/) | Free–$30 | Varies | Search "low poly cat animated." Many CC-licensed options |
| Commission an artist | $50-200 | Custom | Fiverr/ArtStation. Get exactly the cat you want |
| AI-generate concept art + manual model | Time + AI | Custom | Use AI to design the cat's look, then model in Blender |
| **mindhause-spaces cats** | Reference | N/A | The website had theme-specific cat designs — use as concept art |

**Recommendation:** Start with a free low-poly cat from Quaternius or Sketchfab. If the project reaches beta, commission a custom model that matches the brand perfectly. The cat's personality comes from the **behaviour code** (already written), not the mesh quality.

---

### 5. Monster Visuals

**What you need:** Tasks that look increasingly corrupted, culminating in a roaming creature.

**Strategy: Shader-based evolution (no separate monster models needed)**

This is the cleverest shortcut. You don't need separate monster meshes. The corruption is done through **shaders and visual effects applied to the existing task objects:**

| Stage | Visual Effect | Implementation |
|-------|--------------|----------------|
| **Neglected** | Dust, desaturation | Grey-shift material, maybe a particle dust emitter |
| **Corrupting** | Dark aura, cracks, red glow | Emission shader, rim lighting, screen-space distortion |
| **Monster** | Scale up 1.5x, aggressive particles, pulsing glow | Scale transform + GPUParticles3D + OmniLight3D |

**Key insight:** The `task_object.gd` script already implements all four visual states using material overrides and particle effects. No additional 3D models needed. The "monster" is just an enlarged, glowing, particle-emitting version of the original task object.

For a more dramatic v2, you could:
- Add tentacle/shadow appendages via animated meshes
- Use Godot's visual shaders for dissolve/corruption effects
- Create a "shadow creature" mesh that wraps around the original object

But for v1, shader effects on the existing objects work brilliantly and cost nothing.

---

### 6. Furniture & Room Dressing

**What you need:** Desks, chairs, shelves, columns, torches, sundials, fountains, plants, rugs, etc.

**Strategy: Pack-based, one good pack covers multiple rooms**

| Pack | Contents | Source |
|------|----------|--------|
| Kenney Furniture Kit | Tables, chairs, shelves, cabinets | kenney.nl (free) |
| Kenney Nature Kit | Trees, rocks, plants, fountains | kenney.nl (free) |
| Quaternius Ultimate Nature Pack | Plants, flowers, vines, trees | quaternius.com (free) |
| Quaternius Medieval Interior | Beds, desks, bookshelves, candelabras | quaternius.com (free) |
| Kay Lousberg Dungeon Pack | Torches, barrels, chests, pedestals | itch.io (free) |

**Two or three free packs plus your modular room geometry covers the entire house.** You don't need to model a single piece of furniture.

---

### 7. Sounds & Music

See the Audio Strategy section in [DESIGN_NOTES.md](DESIGN_NOTES.md) for detailed sourcing.

Quick summary:
- [Freesound.org](https://freesound.org/) — ambient loops, SFX, CC-licensed
- [Sonniss GDC audio bundle](https://sonniss.com/gameaudiogdc) — massive free pack (released annually)
- [Kenney](https://kenney.nl/assets/category:Audio) — UI and interaction sounds
- AI music generation (Suno, Udio) — background ambient tracks

---

## Production Pipeline

### Phase 1: Prototype (What We Have Now)

The Godot scripts use **primitive meshes** (CylinderMesh, BoxMesh, SphereMesh) created procedurally. This is genuinely functional — you can walk around, interact with objects, and the systems work. This is the current state.

### Phase 2: Grey-Box

Replace primitives with **CSG room geometry** and basic asset pack furniture. Apply the hero texture set (marble, stone, wood, terracotta). The house starts to look like a house.

**Effort: 1-2 days per room, one person**

### Phase 3: Art Pass

- Replace CSG rooms with proper modular meshes (from Blender or higher-quality asset packs)
- Add proper task object meshes (from packs or custom-modelled)
- Add the cat model with animations
- Apply PBR materials and lighting
- Add ambient audio per room

**Effort: 1-2 weeks for all rooms, one person with asset packs**

### Phase 4: Polish

- Custom shaders for monster corruption effects
- Particle effects tuning
- Baked lighting for performance
- LOD setup for mobile
- Audio mixing and spatial audio

**Effort: 1 week**

---

## Cost Estimate

| Item | Source | Cost |
|------|--------|------|
| Room geometry | CSG + free packs | $0 |
| Textures | Poly Haven + AI generation | $0–20 (AI sub) |
| Furniture | Kenney + Quaternius | $0 |
| Task objects | Primitives → free packs | $0 |
| Cat model | Free pack or commission | $0–150 |
| Sounds | Freesound + Sonniss + Kenney | $0 |
| Music | AI-generated ambient | $0–10/month |
| **Total** | | **$0–180** |

The entire visual production can be done for under $200. Most of it for free.

---

## Tools You'll Need

| Tool | Purpose | Cost |
|------|---------|------|
| **Godot 4 Editor** | Scene building, material setup, testing | Free |
| **Blender** | Custom modelling/texturing if needed | Free |
| **GIMP / Krita** | Texture editing | Free |
| **Audacity** | Sound editing | Free |
| **Stable Diffusion** (optional) | AI texture generation | Free (local) or ~$10/month (cloud) |

---

*This document outlines the practical strategy for building MindHause's 3D assets. Updated 2026-02-15.*
