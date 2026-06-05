# Blender CLI hero-piece pipeline

End-to-end procedural-asset workflow using the HKUDS/CLI-Anything Blender harness, installed at `~/development/CLI-Anything/blender/agent-harness/`.

**Pipeline shape:**

1. **Build scene JSON via the CLI** — `cli-anything-blender scene new …`, then `object add`, `material create`, `material assign`, `camera add`, `light add`. Each command mutates a single `<scene>.blend-cli.json` file.
2. **Generate the bpy script** — `cli-anything-blender --project <scene>.json render script <render_output.png>` PRINTS the Python script to stdout (capture with `> script.py`). The positional arg is the render output path the SCRIPT will write to, not the script file location.
3. **Patch the tail** — replace the auto-generated render block with a GLB export call (and optionally a preview render). See `column_ionic_build.py` for the template.
4. **Run Blender headless** — `blender --background --python <patched_script>.py`. Produces a GLB at the path you chose plus an optional PNG preview.

**Critical gotchas learned 2026-06-05 (Blender 4.5):**
- **Blender is Z-up.** The CLI's `-l "x,y,z"` passes (x,y,z) directly to Blender's `location`. If you mistakenly use the second coordinate for height, your asset will lie flat on the ground. All heroes built going forward should be specced with Z as height.
- **`object add` mesh params** go through `-p key=value`, NOT `--radius/--depth/etc`. Cylinder uses `-p radius=0.4 -p depth=3.4`; torus uses `-p major_radius=0.55 -p minor_radius=0.08`.
- **`material assign` takes positional args**, not flags: `material assign <material_index> <object_index>`.
- **`light add` takes a positional sub-type**: `light add sun -n key -l "x,y,z" -w 4` (NOT `--type sun`).
- **`render script` positional arg is the render output path**, not the script file path. The script itself goes to stdout — capture with `> file.py`.

## Available pieces (and the next ones to build)

| Piece | Path | Status |
|---|---|---|
| Ionic column | `godot_palace/models/furniture/column_ionic.glb` | ✅ Built 2026-06-05 — see `column_ionic_build.py` |
| Sundial | `godot_palace/models/timepieces/sundial.glb` | 🔵 Next candidate — disc + gnomon + hour markers |
| Astronomical clock face | `godot_palace/models/timepieces/astronomical_clock.glb` | 🔵 Tractable — concentric rings + zodiac plate |
| Clepsydra (water clock) | `godot_palace/models/timepieces/clepsydra.glb` | 🔵 Tractable — vase + tube + basin |
| Hourglass | `godot_palace/models/timepieces/hourglass.glb` | 🔵 Easy — two cones in a wooden frame |

**Not tractable via this pipeline** (need sculpting / texture painting):
- Incense clock (carved wood relief)
- Pillar clock (Edo-period intricate detail)
- Cuckoo clock (decorative cottage carving)

## Building a new piece

Copy `column_ionic_build.py` as a starting template. Each script has three sections:
1. Scene assembly (CLI invocations)
2. Patch the bpy script (Python that strips the render tail and adds GLB export)
3. Run Blender (`blender --background --python …`)

For hero pieces that need fine control of geometry beyond primitives + modifiers, drop down to hand-written bpy code in the patched script — the CLI is best for the standard repetitive setup (camera/light/material/primitive placement), not for unique geometry.
