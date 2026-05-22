#!/usr/bin/env python3
"""
Phase 3 — place vendor assets at canonical project paths and author Poly Haven materials.

What this does:
  1. Copies Kenney .glb files to godot_palace/models/furniture/<canonical>.glb
  2. Copies Quaternius .gltf+.bin pairs (with URI patching) to canonical paths
  3. Authors StandardMaterial3D .tres files for the 10 Poly Haven materials

What this does NOT do:
  - AmbientCG materials (already ship .tres files, use them in-place)
  - Custom Blender pieces (out of scope — user/manual work)

Idempotent: re-runs cleanly, overwrites any existing canonical files.
"""
import json
import os
import shutil
import sys
from pathlib import Path

ROOT = Path("/home/mogie/projects/mindhause/godot_palace")
ASSETS = ROOT / "assets"
MODELS = ROOT / "models"

# (source_relative, dest_relative) pairs — paths under ROOT
KENNEY_FURNITURE_COPIES = [
    ("assets/models/kenney/furniture/Models/GLTF format/desk.glb",          "models/furniture/desk.glb"),
    ("assets/models/kenney/furniture/Models/GLTF format/bookcaseClosed.glb", "models/furniture/bookshelf.glb"),
    ("assets/models/kenney/furniture/Models/GLTF format/tableRound.glb",    "models/furniture/table_round.glb"),
    ("assets/models/kenney/furniture/Models/GLTF format/bedSingle.glb",     "models/furniture/bed.glb"),
    ("assets/models/kenney/furniture/Models/GLTF format/kitchenBar.glb",    "models/furniture/counter.glb"),
    # Substitute pieces (will need material override later)
    ("assets/models/kenney/furniture/Models/GLTF format/bookcaseClosedDoors.glb", "models/furniture/display_case.glb"),
]

# (source_basename, dest_basename) pairs — both reside under
# assets/models/quaternius/fantasy_props/Exports/glTF/  (source)
# and models/objects/  or  models/furniture/  (dest)
QUATERNIUS_COPIES = [
    # Task objects → models/objects/
    ("Scroll_1",                "objects/scroll"),
    ("Book_5",                  "objects/book"),
    ("Candle_1",                "objects/candle"),
    ("Dummy",                   "objects/statue"),       # substitute (no true bust in pack)
    ("Pot_1",                   "objects/jar"),
    ("Key_Gold",                "objects/key"),
    # Furniture → models/furniture/
    ("Workbench",               "furniture/workbench"),
    ("BookStand",               "furniture/pedestal"),    # substitute
    ("Bench",                   "furniture/stone_bench"), # substitute (wood — apply stone material)
    ("Table_Large",             "furniture/stone_table"), # substitute (same)
]
QUATERNIUS_SRC_DIR = ASSETS / "models/quaternius/fantasy_props/Exports/glTF"

# Poly Haven materials — each gets a .tres at the SAME path as the texture set
# Maps: diff (albedo), nor_gl (normal), arm (AO/Roughness/Metallic packed)
POLYHAVEN_MATERIALS = [
    "marble_01",
    "wood_floor",
    "dark_wood",
    "castle_brick_01",
    "painted_plaster_wall",
    "floral_jacquard",
    "brown_leather",
    "japanese_sycamore",
    "herringbone_parquet",
    "wood_floor_worn",
]
POLYHAVEN_DIR = ASSETS / "materials/polyhaven"


def copy_glb(src: Path, dest: Path):
    dest.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(src, dest)
    print(f"  GLB  {src.name} -> {dest.relative_to(ROOT)}")


def copy_gltf_with_bin(src_basename: str, src_dir: Path, dest_path: Path):
    """Copy .gltf + .bin pair, patching the buffer URI to point at the new bin name."""
    src_gltf = src_dir / f"{src_basename}.gltf"
    src_bin = src_dir / f"{src_basename}.bin"
    dest_gltf = dest_path.with_suffix(".gltf")
    dest_bin = dest_path.with_suffix(".bin")

    if not src_gltf.exists():
        print(f"  SKIP {src_basename}: source .gltf missing at {src_gltf}")
        return
    if not src_bin.exists():
        print(f"  SKIP {src_basename}: source .bin missing at {src_bin}")
        return

    dest_gltf.parent.mkdir(parents=True, exist_ok=True)

    # Load gltf, patch buffer URIs to point at new bin filename
    with src_gltf.open() as f:
        gltf = json.load(f)
    new_bin_name = dest_bin.name
    for buf in gltf.get("buffers", []):
        if "uri" in buf and buf["uri"].endswith(".bin"):
            buf["uri"] = new_bin_name

    with dest_gltf.open("w") as f:
        json.dump(gltf, f, indent="\t")
    shutil.copy2(src_bin, dest_bin)
    print(f"  gltf {src_basename} -> {dest_gltf.relative_to(ROOT)} (+ .bin)")


def write_polyhaven_tres(slug: str, mat_dir: Path):
    """Write a StandardMaterial3D .tres for a Poly Haven material assuming diff+nor_gl+arm at 4K JPG."""
    diff = f"{slug}_diff_4k.jpg"
    nor = f"{slug}_nor_gl_4k.jpg"
    arm = f"{slug}_arm_4k.jpg"

    # Some Poly Haven assets use _albedo instead of _diff (e.g. brown_leather)
    # Probe and adjust.
    if not (mat_dir / diff).exists():
        alt = f"{slug}_albedo_4k.jpg"
        if (mat_dir / alt).exists():
            diff = alt

    missing = [n for n in (diff, nor, arm) if not (mat_dir / n).exists()]
    if missing:
        print(f"  SKIP {slug}: missing maps {missing}")
        return

    tres_path = mat_dir / f"{slug}.tres"
    content = f"""[gd_resource type="StandardMaterial3D" load_steps=4 format=3]

[ext_resource type="Texture2D" path="./{diff}" id="Diffuse"]
[ext_resource type="Texture2D" path="./{nor}" id="NormalGL"]
[ext_resource type="Texture2D" path="./{arm}" id="ARM"]

[resource]
albedo_texture = ExtResource("Diffuse")
normal_enabled = true
normal_texture = ExtResource("NormalGL")
ao_enabled = true
ao_texture = ExtResource("ARM")
ao_texture_channel = 0
roughness_texture = ExtResource("ARM")
roughness_texture_channel = 1
metallic = 1.0
metallic_texture = ExtResource("ARM")
metallic_texture_channel = 2
"""
    tres_path.write_text(content)
    print(f"  tres {slug} -> {tres_path.relative_to(ROOT)}")


def main():
    print("=" * 60)
    print("PART A — Kenney furniture (single-file .glb copies)")
    print("=" * 60)
    for src_rel, dest_rel in KENNEY_FURNITURE_COPIES:
        src = ROOT / src_rel
        dest = ROOT / dest_rel
        if not src.exists():
            print(f"  SKIP: source missing {src}")
            continue
        copy_glb(src, dest)

    print()
    print("=" * 60)
    print("PART B — Quaternius .gltf + .bin pairs (with URI patching)")
    print("=" * 60)
    for src_basename, dest_rel in QUATERNIUS_COPIES:
        dest = MODELS / dest_rel  # dest_rel ends without extension; add via with_suffix
        copy_gltf_with_bin(src_basename, QUATERNIUS_SRC_DIR, dest)

    print()
    print("=" * 60)
    print("PART C — Poly Haven StandardMaterial3D .tres authoring")
    print("=" * 60)
    for slug in POLYHAVEN_MATERIALS:
        mat_dir = POLYHAVEN_DIR / slug
        if not mat_dir.exists():
            print(f"  SKIP {slug}: directory missing")
            continue
        write_polyhaven_tres(slug, mat_dir)

    print()
    print("=" * 60)
    print("Phase 3 placement complete.")
    print("=" * 60)


if __name__ == "__main__":
    main()
