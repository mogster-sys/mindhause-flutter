"""
Mindhause Cat Pipeline for Blender 4.0+
========================================
Generates 8 themed cat GLB files for the Godot Palace game.

Two modes:
  GENERATE  -- Build a low-poly cat mesh from scratch using bmesh,
               rig it with an armature, UV-unwrap it, and texture it.
  PROCESS   -- Take an existing mesh + armature already in the scene,
               validate / rename bones, decimate if needed, and prep for export.

Both modes then duplicate the base cat for each of the 8 room themes,
apply breed-specific bone scale tweaks, generate a unique procedural
texture, bake it to an image, and export a .glb file.

Usage:
  1. Open Blender 4.0+.
  2. Switch to the Scripting workspace tab.
  3. Paste this entire script into a new text block.
  4. Edit the CONFIGURATION section below to match your paths.
  5. Click "Run Script" (or press Alt+P).

Author: Mindhause pipeline tooling
"""

import bpy
import bmesh
import math
import os
import sys
import traceback
from mathutils import Vector, Matrix, Euler

# ============================================================================
# CONFIGURATION
# ============================================================================

MODE = "GENERATE"  # "GENERATE" or "PROCESS"

# Output directory -- edit to match your machine.
# The script tries the first path that exists; you can set both.
OUTPUT_CANDIDATES = [
    r"\\wsl$\Ubuntu\home\mogie\projects\mindhause\godot_palace\models\cats",
    r"\\wsl.localhost\Ubuntu\home\mogie\projects\mindhause\godot_palace\models\cats",
    r"C:\Users\mogie\Downloads\cat_glbs",
    r"C:\Users\mogie\projects\mindhause\godot_palace\models\cats",
    "/home/mogie/projects/mindhause/godot_palace/models/cats",
]

TEXTURE_SIZE = 512       # Pixels per side for baked textures
TARGET_TRIS = 3000       # Maximum triangle count per cat
DECIMATE_THRESHOLD = 5000  # Decimate only if above this (PROCESS mode)

# Blender-to-Godot orientation: cat faces -Y in Blender => -Z in Godot.
# The export plugin handles axis conversion automatically.
CAT_FORWARD = Vector((0, -1, 0))


# ============================================================================
# THEME / SKIN DATA  (mirrors cat_skin.gd exactly)
# ============================================================================

SKINS = {
    "greco_roman": {
        "breed": "Turkish Angora",
        "base": (0.95, 0.95, 0.93, 1.0),
        "accent": (0.88, 0.88, 0.85, 1.0),
        "eye": (0.75, 0.6, 0.15, 1.0),
        "nose": (0.9, 0.7, 0.7, 1.0),
        "ear_inner": (0.95, 0.8, 0.78, 1.0),
        "scale_tweaks": {"ear": 1.0, "tail": 1.3, "body": 1.0},
    },
    "victorian": {
        "breed": "British Shorthair",
        "base": (0.55, 0.58, 0.65, 1.0),
        "accent": (0.45, 0.48, 0.55, 1.0),
        "eye": (0.75, 0.5, 0.2, 1.0),
        "nose": (0.6, 0.45, 0.45, 1.0),
        "ear_inner": (0.7, 0.6, 0.6, 1.0),
        "scale_tweaks": {"ear": 0.85, "tail": 0.9, "body": 1.15},
    },
    "ryokan": {
        "breed": "Japanese Bobtail",
        "base": (0.95, 0.92, 0.88, 1.0),
        "accent": (0.85, 0.5, 0.2, 1.0),
        "eye": (0.8, 0.6, 0.2, 1.0),
        "nose": (0.9, 0.65, 0.6, 1.0),
        "ear_inner": (0.95, 0.8, 0.75, 1.0),
        "scale_tweaks": {"ear": 1.0, "tail": 0.4, "body": 0.95},
    },
    "cottage": {
        "breed": "Ginger Tabby",
        "base": (0.9, 0.6, 0.2, 1.0),
        "accent": (0.75, 0.45, 0.15, 1.0),
        "eye": (0.3, 0.6, 0.2, 1.0),
        "nose": (0.85, 0.55, 0.5, 1.0),
        "ear_inner": (0.95, 0.75, 0.65, 1.0),
        "scale_tweaks": {"ear": 1.0, "tail": 1.0, "body": 1.05},
    },
    "gothic": {
        "breed": "Black Bombay",
        "base": (0.08, 0.08, 0.1, 1.0),
        "accent": (0.05, 0.05, 0.07, 1.0),
        "eye": (0.8, 0.65, 0.1, 1.0),
        "nose": (0.15, 0.12, 0.12, 1.0),
        "ear_inner": (0.2, 0.18, 0.18, 1.0),
        "scale_tweaks": {"ear": 1.05, "tail": 1.1, "body": 0.95},
    },
    "scifi": {
        "breed": "Sphynx",
        "base": (0.75, 0.65, 0.68, 1.0),
        "accent": (0.65, 0.55, 0.58, 1.0),
        "eye": (0.4, 0.6, 0.9, 1.0),
        "nose": (0.8, 0.6, 0.6, 1.0),
        "ear_inner": (0.85, 0.7, 0.72, 1.0),
        "scale_tweaks": {"ear": 1.4, "tail": 1.1, "body": 0.9},
    },
    "fallout": {
        "breed": "Scruffy Survivor",
        "base": (0.55, 0.45, 0.35, 1.0),
        "accent": (0.4, 0.32, 0.25, 1.0),
        "eye": (0.8, 0.7, 0.2, 1.0),
        "nose": (0.6, 0.45, 0.4, 1.0),
        "ear_inner": (0.65, 0.5, 0.45, 1.0),
        "scale_tweaks": {"ear": 0.9, "tail": 0.95, "body": 1.0},
    },
    "modern_loft": {
        "breed": "Russian Blue",
        "base": (0.6, 0.65, 0.72, 1.0),
        "accent": (0.5, 0.55, 0.62, 1.0),
        "eye": (0.3, 0.7, 0.3, 1.0),
        "nose": (0.55, 0.5, 0.55, 1.0),
        "ear_inner": (0.7, 0.68, 0.72, 1.0),
        "scale_tweaks": {"ear": 1.0, "tail": 1.05, "body": 0.95},
    },
}

# Expected bone names for our rig.
EXPECTED_BONES = [
    "Root",
    "Spine", "Chest", "Neck", "Head", "EarL", "EarR",
    "TailBase", "TailMid", "TailTip",
    "ScapulaL", "FrontLegL", "FrontKneeL", "FrontPawL",
    "ScapulaR", "FrontLegR", "FrontKneeR", "FrontPawR",
    "HipL", "BackLegL", "BackKneeL", "BackPawL",
    "HipR", "BackLegR", "BackKneeR", "BackPawR",
]


# ============================================================================
# UTILITY HELPERS
# ============================================================================

def resolve_output_dir():
    """Return the first output path candidate that exists (or can be created)."""
    for path in OUTPUT_CANDIDATES:
        expanded = os.path.expanduser(path)
        if os.path.isdir(expanded):
            return expanded
        # Try to create it.
        try:
            os.makedirs(expanded, exist_ok=True)
            return expanded
        except OSError:
            continue
    # Fallback: next to the .blend file, or temp.
    blend_dir = bpy.path.abspath("//")
    if blend_dir:
        out = os.path.join(blend_dir, "cat_exports")
        os.makedirs(out, exist_ok=True)
        return out
    out = os.path.join(os.path.expanduser("~"), "mindhause_cat_exports")
    os.makedirs(out, exist_ok=True)
    return out


def deselect_all():
    bpy.ops.object.select_all(action='DESELECT')


def select_only(obj):
    deselect_all()
    obj.select_set(True)
    bpy.context.view_layer.objects.active = obj


def apply_all_transforms(obj):
    """Apply location, rotation, and scale on the given object."""
    select_only(obj)
    bpy.ops.object.transform_apply(location=True, rotation=True, scale=True)


def delete_object(obj):
    """Remove an object and its data from the scene."""
    bpy.data.objects.remove(obj, do_unlink=True)


def log(msg):
    """Print a timestamped pipeline message."""
    print(f"[CatPipeline] {msg}")


# ============================================================================
# BMESH CAT GENERATOR  (Mode: GENERATE)
# ============================================================================

def _add_ellipsoid(bm, center, radii, segments_h=12, segments_v=8):
    """Add an ellipsoid to a bmesh.  Returns the list of verts created."""
    rx, ry, rz = radii
    cx, cy, cz = center
    verts = []

    # Top pole
    top = bm.verts.new((cx, cy, cz + rz))
    verts.append(top)

    # Middle rings
    rings = []
    for i in range(1, segments_v):
        phi = math.pi * i / segments_v
        ring = []
        for j in range(segments_h):
            theta = 2 * math.pi * j / segments_h
            x = cx + rx * math.sin(phi) * math.cos(theta)
            y = cy + ry * math.sin(phi) * math.sin(theta)
            z = cz + rz * math.cos(phi)
            v = bm.verts.new((x, y, z))
            ring.append(v)
            verts.append(v)
        rings.append(ring)

    # Bottom pole
    bottom = bm.verts.new((cx, cy, cz - rz))
    verts.append(bottom)

    # Faces: top cap
    for j in range(segments_h):
        j_next = (j + 1) % segments_h
        bm.faces.new([top, rings[0][j], rings[0][j_next]])

    # Faces: middle bands
    for i in range(len(rings) - 1):
        for j in range(segments_h):
            j_next = (j + 1) % segments_h
            bm.faces.new([
                rings[i][j], rings[i + 1][j],
                rings[i + 1][j_next], rings[i][j_next]
            ])

    # Faces: bottom cap
    last = rings[-1]
    for j in range(segments_h):
        j_next = (j + 1) % segments_h
        bm.faces.new([bottom, last[j_next], last[j]])

    return verts


def _add_cylinder(bm, base_center, top_center, radius_bottom, radius_top,
                  segments=8):
    """Add a tapered cylinder between two points. Returns verts."""
    bc = Vector(base_center)
    tc = Vector(top_center)
    direction = (tc - bc).normalized()

    # Build a local coordinate frame
    if abs(direction.dot(Vector((0, 0, 1)))) < 0.99:
        perp = direction.cross(Vector((0, 0, 1))).normalized()
    else:
        perp = direction.cross(Vector((1, 0, 0))).normalized()
    perp2 = direction.cross(perp).normalized()

    verts = []
    bottom_ring = []
    top_ring = []

    for i in range(segments):
        angle = 2 * math.pi * i / segments
        offset = perp * math.cos(angle) + perp2 * math.sin(angle)
        bv = bm.verts.new(bc + offset * radius_bottom)
        tv = bm.verts.new(tc + offset * radius_top)
        bottom_ring.append(bv)
        top_ring.append(tv)
        verts.extend([bv, tv])

    # Side faces
    for i in range(segments):
        i_next = (i + 1) % segments
        bm.faces.new([
            bottom_ring[i], bottom_ring[i_next],
            top_ring[i_next], top_ring[i]
        ])

    # Cap faces
    if radius_bottom > 0.001:
        bm.faces.new(list(reversed(bottom_ring)))
    if radius_top > 0.001:
        bm.faces.new(top_ring)

    return verts


def _add_cone(bm, base_center, tip, radius, segments=8):
    """Add a cone. Returns verts."""
    bc = Vector(base_center)
    tp = Vector(tip)
    direction = (tp - bc).normalized()

    if abs(direction.dot(Vector((0, 0, 1)))) < 0.99:
        perp = direction.cross(Vector((0, 0, 1))).normalized()
    else:
        perp = direction.cross(Vector((1, 0, 0))).normalized()
    perp2 = direction.cross(perp).normalized()

    verts = []
    ring = []
    tip_v = bm.verts.new(tp)
    verts.append(tip_v)

    for i in range(segments):
        angle = 2 * math.pi * i / segments
        offset = perp * math.cos(angle) + perp2 * math.sin(angle)
        v = bm.verts.new(bc + offset * radius)
        ring.append(v)
        verts.append(v)

    # Side faces
    for i in range(segments):
        i_next = (i + 1) % segments
        bm.faces.new([ring[i], ring[i_next], tip_v])

    # Base cap
    bm.faces.new(list(reversed(ring)))

    return verts


def generate_cat_mesh():
    """
    Build a low-poly cat mesh entirely from bmesh primitives.
    The cat faces -Y (nose pointing toward -Y in Blender).
    Returns the created mesh object.
    """
    log("Generating cat mesh with bmesh...")
    bm = bmesh.new()

    # All dimensions are in Blender metres. The cat is roughly 0.35m long,
    # 0.25m tall at the back -- matching the Godot primitive cat scale.

    # ---- Body (elongated ellipsoid) ----
    body_verts = _add_ellipsoid(
        bm,
        center=(0, 0, 0.15),
        radii=(0.08, 0.16, 0.09),
        segments_h=14, segments_v=10
    )

    # ---- Head (sphere, offset forward = -Y) ----
    head_verts = _add_ellipsoid(
        bm,
        center=(0, -0.22, 0.22),
        radii=(0.09, 0.08, 0.08),
        segments_h=14, segments_v=10
    )

    # ---- Muzzle (small ellipsoid protruding from head) ----
    muzzle_verts = _add_ellipsoid(
        bm,
        center=(0, -0.30, 0.19),
        radii=(0.04, 0.03, 0.03),
        segments_h=10, segments_v=6
    )

    # ---- Ears (cones) ----
    ear_l_verts = _add_cone(
        bm,
        base_center=(-0.045, -0.20, 0.30),
        tip=(-0.05, -0.18, 0.37),
        radius=0.025,
        segments=8
    )

    ear_r_verts = _add_cone(
        bm,
        base_center=(0.045, -0.20, 0.30),
        tip=(0.05, -0.18, 0.37),
        radius=0.025,
        segments=8
    )

    # ---- Tail (3 tapered cylinders curving upward) ----
    tail_base_verts = _add_cylinder(
        bm,
        base_center=(0, 0.16, 0.15),
        top_center=(0, 0.24, 0.20),
        radius_bottom=0.018, radius_top=0.015,
        segments=6
    )

    tail_mid_verts = _add_cylinder(
        bm,
        base_center=(0, 0.24, 0.20),
        top_center=(0, 0.30, 0.28),
        radius_bottom=0.015, radius_top=0.012,
        segments=6
    )

    tail_tip_verts = _add_cylinder(
        bm,
        base_center=(0, 0.30, 0.28),
        top_center=(0, 0.33, 0.34),
        radius_bottom=0.012, radius_top=0.005,
        segments=6
    )

    # ---- Front legs ----
    fl_l_verts = _add_cylinder(
        bm,
        base_center=(-0.055, -0.10, 0.0),
        top_center=(-0.055, -0.10, 0.10),
        radius_bottom=0.018, radius_top=0.022,
        segments=6
    )

    fl_r_verts = _add_cylinder(
        bm,
        base_center=(0.055, -0.10, 0.0),
        top_center=(0.055, -0.10, 0.10),
        radius_bottom=0.018, radius_top=0.022,
        segments=6
    )

    # ---- Back legs (slightly thicker) ----
    bl_l_verts = _add_cylinder(
        bm,
        base_center=(-0.06, 0.10, 0.0),
        top_center=(-0.06, 0.10, 0.12),
        radius_bottom=0.020, radius_top=0.026,
        segments=6
    )

    bl_r_verts = _add_cylinder(
        bm,
        base_center=(0.06, 0.10, 0.0),
        top_center=(0.06, 0.10, 0.12),
        radius_bottom=0.020, radius_top=0.026,
        segments=6
    )

    # ---- Paws (flattened ellipsoids at foot of each leg) ----
    paw_fl_l = _add_ellipsoid(bm, center=(-0.055, -0.10, 0.0),
                               radii=(0.022, 0.025, 0.01),
                               segments_h=8, segments_v=4)
    paw_fl_r = _add_ellipsoid(bm, center=(0.055, -0.10, 0.0),
                               radii=(0.022, 0.025, 0.01),
                               segments_h=8, segments_v=4)
    paw_bl_l = _add_ellipsoid(bm, center=(-0.06, 0.10, 0.0),
                               radii=(0.024, 0.028, 0.012),
                               segments_h=8, segments_v=4)
    paw_bl_r = _add_ellipsoid(bm, center=(0.06, 0.10, 0.0),
                               radii=(0.024, 0.028, 0.012),
                               segments_h=8, segments_v=4)

    # ---- Eyes (small spheres) ----
    eye_l_verts = _add_ellipsoid(bm, center=(-0.035, -0.285, 0.24),
                                  radii=(0.014, 0.010, 0.012),
                                  segments_h=8, segments_v=6)
    eye_r_verts = _add_ellipsoid(bm, center=(0.035, -0.285, 0.24),
                                  radii=(0.014, 0.010, 0.012),
                                  segments_h=8, segments_v=6)

    # ---- Nose (tiny sphere) ----
    nose_verts = _add_ellipsoid(bm, center=(0, -0.325, 0.20),
                                 radii=(0.010, 0.006, 0.008),
                                 segments_h=6, segments_v=4)

    # ---- Merge very close verts to seal gaps ----
    bmesh.ops.remove_doubles(bm, verts=bm.verts[:], dist=0.003)

    # ---- Recalculate normals ----
    bmesh.ops.recalc_face_normals(bm, faces=bm.faces[:])

    # Create mesh data and object
    mesh_data = bpy.data.meshes.new("CatMesh")
    bm.to_mesh(mesh_data)
    bm.free()

    cat_obj = bpy.data.objects.new("Cat_Base", mesh_data)
    bpy.context.collection.objects.link(cat_obj)
    select_only(cat_obj)

    # Smooth shading
    bpy.ops.object.shade_smooth()

    # Check tri count and decimate if over budget
    tri_count = sum(len(p.vertices) - 2 for p in mesh_data.polygons)
    log(f"  Raw mesh: {tri_count} tris, {len(mesh_data.vertices)} verts")
    if tri_count > TARGET_TRIS:
        ratio = TARGET_TRIS / tri_count
        log(f"  Decimating to ~{TARGET_TRIS} tris (ratio={ratio:.3f})...")
        mod = cat_obj.modifiers.new("Decimate", 'DECIMATE')
        mod.ratio = ratio
        bpy.ops.object.modifier_apply(modifier=mod.name)
        tri_count = sum(len(p.vertices) - 2 for p in cat_obj.data.polygons)
        log(f"  After decimate: {tri_count} tris")

    # Smart UV project
    log("  UV unwrapping (Smart UV Project)...")
    bpy.ops.object.mode_set(mode='EDIT')
    bpy.ops.mesh.select_all(action='SELECT')
    bpy.ops.uv.smart_project(angle_limit=66.0, island_margin=0.02)
    bpy.ops.object.mode_set(mode='OBJECT')

    # Create a base material
    mat = bpy.data.materials.new("CatBaseMat")
    mat.use_nodes = True
    cat_obj.data.materials.append(mat)

    log(f"  Cat mesh generated: {len(cat_obj.data.vertices)} verts, "
        f"{tri_count} tris")
    return cat_obj


# ============================================================================
# VERTEX GROUP ASSIGNMENT HELPERS
# ============================================================================

def _assign_verts_by_region(cat_obj, armature_obj):
    """
    Assign vertices to vertex groups based on their position relative to
    the bone rest positions.  This supplements automatic weights with
    more precise control over the extremities (ears, paws, tail tip).
    """
    mesh = cat_obj.data

    # We will use the bone head/tail positions from the armature in rest pose.
    bones = armature_obj.data.bones

    # Build a mapping: vertex group name -> list of vert indices
    # For the initial pass we rely on automatic weights (parent with
    # automatic weights).  This function is called AFTER auto-weighting
    # to clean up any stray assignments.
    pass  # Auto weights handle the bulk; see create_armature().


# ============================================================================
# ARMATURE CREATION
# ============================================================================

def create_armature(cat_obj):
    """
    Create a full armature matching the expected bone hierarchy:
        Root
        +-- Spine -> Chest -> Neck -> Head -> EarL, EarR
        +-- Spine -> TailBase -> TailMid -> TailTip
        +-- Chest -> ScapulaL -> FrontLegL -> FrontKneeL -> FrontPawL
        +-- Chest -> ScapulaR -> FrontLegR -> FrontKneeR -> FrontPawR
        +-- Spine -> HipL -> BackLegL -> BackKneeL -> BackPawL
        +-- Spine -> HipR -> BackLegR -> BackKneeR -> BackPawR

    Returns the armature object.
    """
    log("Creating armature...")
    arm_data = bpy.data.armatures.new("CatArmature")
    arm_obj = bpy.data.objects.new("Cat_Armature", arm_data)
    bpy.context.collection.objects.link(arm_obj)

    # Position armature at the same location as the mesh
    arm_obj.location = cat_obj.location

    select_only(arm_obj)
    bpy.ops.object.mode_set(mode='EDIT')

    edit_bones = arm_data.edit_bones

    # Helper to add a bone.
    def add_bone(name, head, tail, parent_name=None, connect=False):
        b = edit_bones.new(name)
        b.head = Vector(head)
        b.tail = Vector(tail)
        if parent_name:
            b.parent = edit_bones[parent_name]
        b.use_connect = connect
        return b

    # ---- Root ----
    add_bone("Root",     (0, 0, 0.15),    (0, 0, 0.16))

    # ---- Spine chain ----
    add_bone("Spine",    (0, 0, 0.15),    (0, -0.06, 0.16),  "Root", connect=True)
    add_bone("Chest",    (0, -0.06, 0.16),(0, -0.14, 0.18),  "Spine", connect=True)
    add_bone("Neck",     (0, -0.14, 0.18),(0, -0.19, 0.22),  "Chest", connect=True)
    add_bone("Head",     (0, -0.19, 0.22),(0, -0.28, 0.24),  "Neck", connect=True)

    # ---- Ears (from Head) ----
    add_bone("EarL",     (-0.045, -0.20, 0.30), (-0.05, -0.18, 0.37), "Head")
    add_bone("EarR",     (0.045, -0.20, 0.30),  (0.05, -0.18, 0.37),  "Head")

    # ---- Tail (from Spine) ----
    add_bone("TailBase", (0, 0.16, 0.15), (0, 0.24, 0.20),  "Spine")
    add_bone("TailMid",  (0, 0.24, 0.20), (0, 0.30, 0.28),  "TailBase", connect=True)
    add_bone("TailTip",  (0, 0.30, 0.28), (0, 0.33, 0.34),  "TailMid", connect=True)

    # ---- Front legs (from Chest) ----
    add_bone("ScapulaL",  (-0.04, -0.10, 0.14), (-0.055, -0.10, 0.10), "Chest")
    add_bone("FrontLegL", (-0.055, -0.10, 0.10),(-0.055, -0.10, 0.05), "ScapulaL", connect=True)
    add_bone("FrontKneeL",(-0.055, -0.10, 0.05),(-0.055, -0.10, 0.02), "FrontLegL", connect=True)
    add_bone("FrontPawL", (-0.055, -0.10, 0.02),(-0.055, -0.10, 0.0),  "FrontKneeL", connect=True)

    add_bone("ScapulaR",  (0.04, -0.10, 0.14), (0.055, -0.10, 0.10), "Chest")
    add_bone("FrontLegR", (0.055, -0.10, 0.10),(0.055, -0.10, 0.05), "ScapulaR", connect=True)
    add_bone("FrontKneeR",(0.055, -0.10, 0.05),(0.055, -0.10, 0.02), "FrontLegR", connect=True)
    add_bone("FrontPawR", (0.055, -0.10, 0.02),(0.055, -0.10, 0.0),  "FrontKneeR", connect=True)

    # ---- Back legs (from Spine) ----
    add_bone("HipL",      (-0.04, 0.08, 0.14), (-0.06, 0.10, 0.12), "Spine")
    add_bone("BackLegL",  (-0.06, 0.10, 0.12), (-0.06, 0.10, 0.06), "HipL", connect=True)
    add_bone("BackKneeL", (-0.06, 0.10, 0.06), (-0.06, 0.10, 0.02), "BackLegL", connect=True)
    add_bone("BackPawL",  (-0.06, 0.10, 0.02), (-0.06, 0.10, 0.0),  "BackKneeL", connect=True)

    add_bone("HipR",      (0.04, 0.08, 0.14), (0.06, 0.10, 0.12), "Spine")
    add_bone("BackLegR",  (0.06, 0.10, 0.12), (0.06, 0.10, 0.06), "HipR", connect=True)
    add_bone("BackKneeR", (0.06, 0.10, 0.06), (0.06, 0.10, 0.02), "BackLegR", connect=True)
    add_bone("BackPawR",  (0.06, 0.10, 0.02), (0.06, 0.10, 0.0),  "BackKneeR", connect=True)

    bpy.ops.object.mode_set(mode='OBJECT')

    # ---- Parent mesh to armature with automatic weights ----
    log("  Parenting mesh to armature with automatic weights...")
    deselect_all()
    cat_obj.select_set(True)
    arm_obj.select_set(True)
    bpy.context.view_layer.objects.active = arm_obj
    try:
        bpy.ops.object.parent_set(type='ARMATURE_AUTO')
        log("  Automatic weights applied successfully.")
    except RuntimeError as e:
        log(f"  WARNING: Automatic weights failed ({e}). "
            f"Falling back to envelope weights...")
        try:
            bpy.ops.object.parent_set(type='ARMATURE_ENVELOPE')
            log("  Envelope weights applied as fallback.")
        except RuntimeError as e2:
            log(f"  WARNING: Envelope weights also failed ({e2}). "
                f"Using empty vertex groups.")
            bpy.ops.object.parent_set(type='ARMATURE_NAME')

    bone_count = len(arm_data.bones)
    log(f"  Armature created: {bone_count} bones")
    return arm_obj


# ============================================================================
# PROCESS MODE -- Validate and prep an existing mesh + armature
# ============================================================================

def find_existing_mesh_armature():
    """
    Find an existing mesh object and its armature in the scene.
    Returns (mesh_obj, armature_obj) or (None, None).
    """
    mesh_obj = None
    armature_obj = None

    for obj in bpy.context.scene.objects:
        if obj.type == 'MESH' and mesh_obj is None:
            mesh_obj = obj
        elif obj.type == 'ARMATURE' and armature_obj is None:
            armature_obj = obj

    # If mesh has an armature modifier, use that armature.
    if mesh_obj:
        for mod in mesh_obj.modifiers:
            if mod.type == 'ARMATURE' and mod.object:
                armature_obj = mod.object
                break

    return mesh_obj, armature_obj


def report_bones(armature_obj):
    """Print all bone names in the armature."""
    log("Existing bone names:")
    for bone in armature_obj.data.bones:
        parent_name = bone.parent.name if bone.parent else "(root)"
        log(f"  {bone.name}  (parent: {parent_name})")


def rename_bones_to_convention(armature_obj):
    """
    Attempt to rename bones from common naming conventions to our expected
    names.  Handles mixamo, Rigify, and some common patterns.
    """
    log("Attempting bone rename to match project convention...")
    rename_map = {
        # Mixamo-style
        "mixamorig:Hips": "Root",
        "mixamorig:Spine": "Spine",
        "mixamorig:Spine1": "Chest",
        "mixamorig:Neck": "Neck",
        "mixamorig:Head": "Head",
        # Generic humanoid-ish mapped to quadruped
        "hips": "Root",
        "spine": "Spine",
        "spine.001": "Chest",
        "chest": "Chest",
        "neck": "Neck",
        "head": "Head",
        "tail.001": "TailBase",
        "tail.002": "TailMid",
        "tail.003": "TailTip",
        "tail_base": "TailBase",
        "tail_mid": "TailMid",
        "tail_tip": "TailTip",
        "ear.L": "EarL",
        "ear.R": "EarR",
        "ear_l": "EarL",
        "ear_r": "EarR",
        # Front legs
        "front_leg.L": "FrontLegL",
        "front_leg.R": "FrontLegR",
        "front_knee.L": "FrontKneeL",
        "front_knee.R": "FrontKneeR",
        "front_paw.L": "FrontPawL",
        "front_paw.R": "FrontPawR",
        "f_leg.L": "FrontLegL",
        "f_leg.R": "FrontLegR",
        "shoulder.L": "ScapulaL",
        "shoulder.R": "ScapulaR",
        # Back legs
        "back_leg.L": "BackLegL",
        "back_leg.R": "BackLegR",
        "back_knee.L": "BackKneeL",
        "back_knee.R": "BackKneeR",
        "back_paw.L": "BackPawL",
        "back_paw.R": "BackPawR",
        "b_leg.L": "BackLegL",
        "b_leg.R": "BackLegR",
        "hip.L": "HipL",
        "hip.R": "HipR",
    }

    select_only(armature_obj)
    bpy.ops.object.mode_set(mode='EDIT')

    renamed_count = 0
    for ebone in armature_obj.data.edit_bones:
        lower = ebone.name.lower()
        # Check exact match first
        if ebone.name in rename_map:
            new_name = rename_map[ebone.name]
            log(f"  Renaming '{ebone.name}' -> '{new_name}'")
            ebone.name = new_name
            renamed_count += 1
        elif lower in rename_map:
            new_name = rename_map[lower]
            log(f"  Renaming '{ebone.name}' -> '{new_name}'")
            ebone.name = new_name
            renamed_count += 1

    bpy.ops.object.mode_set(mode='OBJECT')
    log(f"  Renamed {renamed_count} bones.")

    # Report missing expected bones
    existing = {b.name for b in armature_obj.data.bones}
    missing = [b for b in EXPECTED_BONES if b not in existing]
    if missing:
        log(f"  WARNING: Missing expected bones: {missing}")
        log("  The rig may not deform correctly for all themes.")
    else:
        log("  All expected bones present.")


def process_existing_model():
    """
    PROCESS mode: find existing mesh + armature, validate, fix, and
    return (mesh_obj, armature_obj) ready for theming.
    """
    log("=== PROCESS MODE ===")
    mesh_obj, armature_obj = find_existing_mesh_armature()

    if not mesh_obj:
        log("ERROR: No mesh object found in the scene.")
        log("  Import or create a cat mesh before running in PROCESS mode.")
        return None, None

    log(f"Found mesh: '{mesh_obj.name}'")

    if not armature_obj:
        log("WARNING: No armature found. The export will have no skeleton.")
        log("  The cat will be a static mesh (no bone-driven animation).")
    else:
        log(f"Found armature: '{armature_obj.name}'")
        report_bones(armature_obj)
        rename_bones_to_convention(armature_obj)

    # Apply all transforms
    log("Applying transforms on mesh...")
    apply_all_transforms(mesh_obj)
    if armature_obj:
        log("Applying transforms on armature...")
        apply_all_transforms(armature_obj)

    # Check UV map
    if not mesh_obj.data.uv_layers:
        log("No UV map found. Running Smart UV Project...")
        select_only(mesh_obj)
        bpy.ops.object.mode_set(mode='EDIT')
        bpy.ops.mesh.select_all(action='SELECT')
        bpy.ops.uv.smart_project(angle_limit=66.0, island_margin=0.02)
        bpy.ops.object.mode_set(mode='OBJECT')
        log("  UV map created.")
    else:
        log(f"UV map present: '{mesh_obj.data.uv_layers[0].name}'")

    # Tri count check
    tri_count = sum(len(p.vertices) - 2 for p in mesh_obj.data.polygons)
    log(f"Triangle count: {tri_count}")
    if tri_count > DECIMATE_THRESHOLD:
        ratio = TARGET_TRIS / tri_count
        log(f"  Over threshold ({DECIMATE_THRESHOLD}). Decimating "
            f"(ratio={ratio:.3f})...")
        select_only(mesh_obj)
        mod = mesh_obj.modifiers.new("Decimate", 'DECIMATE')
        mod.ratio = max(ratio, 0.1)
        bpy.ops.object.modifier_apply(modifier=mod.name)
        new_count = sum(len(p.vertices) - 2 for p in mesh_obj.data.polygons)
        log(f"  After decimate: {new_count} tris")

    # Ensure at least one material slot
    if not mesh_obj.data.materials:
        mat = bpy.data.materials.new("CatBaseMat")
        mat.use_nodes = True
        mesh_obj.data.materials.append(mat)
        log("  Created default material slot.")

    return mesh_obj, armature_obj


# ============================================================================
# PROCEDURAL TEXTURE GENERATION
# ============================================================================

def create_themed_material(theme_id, skin_data, tex_size=512):
    """
    Build a procedural node-tree material for the given theme.
    The material uses a mix of solid colours and procedural patterns,
    then we bake it all to a single image texture for GLB export.

    Returns (material, baked_image).
    """
    sd = skin_data
    mat_name = f"CatMat_{theme_id}"
    mat = bpy.data.materials.new(mat_name)
    mat.use_nodes = True
    tree = mat.node_tree
    nodes = tree.nodes
    links = tree.links

    # Clear default nodes
    for n in nodes:
        nodes.remove(n)

    # === Output ===
    output_node = nodes.new('ShaderNodeOutputMaterial')
    output_node.location = (800, 0)

    # === Principled BSDF ===
    bsdf = nodes.new('ShaderNodeBsdfPrincipled')
    bsdf.location = (500, 0)
    bsdf.inputs['Roughness'].default_value = 0.75
    bsdf.inputs['Specular IOR Level'].default_value = 0.3
    links.new(bsdf.outputs['BSDF'], output_node.inputs['Surface'])

    # === Base colour via Geometry + procedural patterns ===

    # We layer: base fill -> accent on extremities -> pattern overlay

    # -- Texture Coordinate & Mapping --
    tex_coord = nodes.new('ShaderNodeTexCoord')
    tex_coord.location = (-1200, 0)

    mapping = nodes.new('ShaderNodeMapping')
    mapping.location = (-1000, 0)
    links.new(tex_coord.outputs['UV'], mapping.inputs['Vector'])

    # -- Base Colour --
    base_rgb = nodes.new('ShaderNodeRGB')
    base_rgb.location = (-400, 300)
    base_rgb.outputs[0].default_value = sd["base"]
    base_rgb.label = "Base"

    # -- Accent Colour --
    accent_rgb = nodes.new('ShaderNodeRGB')
    accent_rgb.location = (-400, 100)
    accent_rgb.outputs[0].default_value = sd["accent"]
    accent_rgb.label = "Accent"

    # -- Gradient for accent areas (extremities) --
    # Use object-space Z coordinate to blend accent onto legs and lower body.
    separate = nodes.new('ShaderNodeSeparateXYZ')
    separate.location = (-800, -200)
    links.new(tex_coord.outputs['Object'], separate.inputs['Vector'])

    # Map the Z value: below ~0.1 (legs) => accent, above => base
    # Use a Math node to create a mask
    math_gt = nodes.new('ShaderNodeMath')
    math_gt.location = (-600, -200)
    math_gt.operation = 'GREATER_THAN'
    math_gt.inputs[1].default_value = 0.12  # Threshold for leg area
    links.new(separate.outputs['Z'], math_gt.inputs[0])

    # Also create a mask from Y for tail area (positive Y = tail region)
    math_gt_y = nodes.new('ShaderNodeMath')
    math_gt_y.location = (-600, -400)
    math_gt_y.operation = 'GREATER_THAN'
    math_gt_y.inputs[1].default_value = 0.25  # tail end
    links.new(separate.outputs['Y'], math_gt_y.inputs[0])

    # Combine: areas that are NOT leg AND NOT tail tip => base colour
    math_or = nodes.new('ShaderNodeMath')
    math_or.location = (-400, -300)
    math_or.operation = 'MINIMUM'
    links.new(math_gt.outputs[0], math_or.inputs[0])
    # Invert the tail mask: tail tip gets accent
    math_inv = nodes.new('ShaderNodeMath')
    math_inv.location = (-500, -400)
    math_inv.operation = 'SUBTRACT'
    math_inv.inputs[0].default_value = 1.0
    links.new(math_gt_y.outputs[0], math_inv.inputs[1])

    math_combine = nodes.new('ShaderNodeMath')
    math_combine.location = (-300, -300)
    math_combine.operation = 'MULTIPLY'
    links.new(math_or.outputs[0], math_combine.inputs[0])
    links.new(math_inv.outputs[0], math_combine.inputs[1])

    # Mix base and accent
    mix_base_accent = nodes.new('ShaderNodeMix')
    mix_base_accent.location = (-100, 200)
    mix_base_accent.data_type = 'RGBA'
    mix_base_accent.blend_type = 'MIX'
    links.new(math_combine.outputs[0], mix_base_accent.inputs['Factor'])
    links.new(accent_rgb.outputs[0], mix_base_accent.inputs[6])  # A (factor=0)
    links.new(base_rgb.outputs[0], mix_base_accent.inputs[7])    # B (factor=1)

    # Start with base+accent as our working colour
    current_color_output = mix_base_accent.outputs[2]  # Result

    # === Theme-specific pattern overlays ===

    if theme_id == "cottage":
        # Tabby stripes using wave texture
        wave = nodes.new('ShaderNodeTexWave')
        wave.location = (-600, 500)
        wave.wave_type = 'BANDS'
        wave.bands_direction = 'Y'
        wave.inputs['Scale'].default_value = 8.0
        wave.inputs['Distortion'].default_value = 2.5
        wave.inputs['Detail'].default_value = 3.0
        wave.inputs['Detail Scale'].default_value = 1.0
        links.new(mapping.outputs['Vector'], wave.inputs['Vector'])

        # Use the wave fac as a stripe mask
        stripe_ramp = nodes.new('ShaderNodeValToRGB')
        stripe_ramp.location = (-300, 500)
        stripe_ramp.color_ramp.elements[0].position = 0.4
        stripe_ramp.color_ramp.elements[0].color = (0, 0, 0, 1)
        stripe_ramp.color_ramp.elements[1].position = 0.6
        stripe_ramp.color_ramp.elements[1].color = (1, 1, 1, 1)
        links.new(wave.outputs['Fac'], stripe_ramp.inputs['Fac'])

        # Darker stripe colour
        stripe_color = nodes.new('ShaderNodeRGB')
        stripe_color.location = (-300, 650)
        # Darker version of the base
        stripe_color.outputs[0].default_value = (
            sd["base"][0] * 0.6,
            sd["base"][1] * 0.6,
            sd["base"][2] * 0.6,
            1.0
        )

        mix_stripes = nodes.new('ShaderNodeMix')
        mix_stripes.location = (100, 400)
        mix_stripes.data_type = 'RGBA'
        mix_stripes.blend_type = 'MIX'
        links.new(stripe_ramp.outputs['Color'], mix_stripes.inputs['Factor'])
        links.new(current_color_output, mix_stripes.inputs[6])
        links.new(stripe_color.outputs[0], mix_stripes.inputs[7])
        current_color_output = mix_stripes.outputs[2]

    elif theme_id == "ryokan":
        # Calico patches using Voronoi texture
        voronoi = nodes.new('ShaderNodeTexVoronoi')
        voronoi.location = (-600, 500)
        voronoi.inputs['Scale'].default_value = 4.0
        voronoi.inputs['Randomness'].default_value = 1.0
        links.new(mapping.outputs['Vector'], voronoi.inputs['Vector'])

        # Threshold the distance to create patches
        patch_ramp = nodes.new('ShaderNodeValToRGB')
        patch_ramp.location = (-300, 500)
        patch_ramp.color_ramp.elements[0].position = 0.3
        patch_ramp.color_ramp.elements[0].color = (0, 0, 0, 1)
        patch_ramp.color_ramp.elements[1].position = 0.5
        patch_ramp.color_ramp.elements[1].color = (1, 1, 1, 1)
        links.new(voronoi.outputs['Distance'], patch_ramp.inputs['Fac'])

        # Patch colour = accent (orange)
        mix_patches = nodes.new('ShaderNodeMix')
        mix_patches.location = (100, 400)
        mix_patches.data_type = 'RGBA'
        mix_patches.blend_type = 'MIX'
        links.new(patch_ramp.outputs['Color'], mix_patches.inputs['Factor'])
        links.new(current_color_output, mix_patches.inputs[6])
        links.new(accent_rgb.outputs[0], mix_patches.inputs[7])
        current_color_output = mix_patches.outputs[2]

    elif theme_id == "fallout":
        # Dirt/noise overlay
        noise = nodes.new('ShaderNodeTexNoise')
        noise.location = (-600, 500)
        noise.inputs['Scale'].default_value = 12.0
        noise.inputs['Detail'].default_value = 6.0
        noise.inputs['Roughness'].default_value = 0.7
        links.new(mapping.outputs['Vector'], noise.inputs['Vector'])

        # Map noise to dark smudges
        dirt_ramp = nodes.new('ShaderNodeValToRGB')
        dirt_ramp.location = (-300, 500)
        dirt_ramp.color_ramp.elements[0].position = 0.3
        dirt_ramp.color_ramp.elements[0].color = (0, 0, 0, 1)
        dirt_ramp.color_ramp.elements[1].position = 0.7
        dirt_ramp.color_ramp.elements[1].color = (1, 1, 1, 1)
        links.new(noise.outputs['Fac'], dirt_ramp.inputs['Fac'])

        dirt_color = nodes.new('ShaderNodeRGB')
        dirt_color.location = (-300, 650)
        dirt_color.outputs[0].default_value = (
            sd["base"][0] * 0.5,
            sd["base"][1] * 0.5,
            sd["base"][2] * 0.4,
            1.0
        )

        mix_dirt = nodes.new('ShaderNodeMix')
        mix_dirt.location = (100, 400)
        mix_dirt.data_type = 'RGBA'
        mix_dirt.blend_type = 'MIX'
        mix_dirt.inputs['Factor'].default_value = 0.4  # Subtle
        links.new(dirt_ramp.outputs['Color'], mix_dirt.inputs['Factor'])
        links.new(current_color_output, mix_dirt.inputs[6])
        links.new(dirt_color.outputs[0], mix_dirt.inputs[7])
        current_color_output = mix_dirt.outputs[2]

    elif theme_id == "scifi":
        # Subtle skin wrinkle pattern (Sphynx cat)
        noise = nodes.new('ShaderNodeTexNoise')
        noise.location = (-600, 500)
        noise.inputs['Scale'].default_value = 25.0
        noise.inputs['Detail'].default_value = 8.0
        noise.inputs['Roughness'].default_value = 0.5
        links.new(mapping.outputs['Vector'], noise.inputs['Vector'])

        wrinkle_ramp = nodes.new('ShaderNodeValToRGB')
        wrinkle_ramp.location = (-300, 500)
        wrinkle_ramp.color_ramp.elements[0].position = 0.45
        wrinkle_ramp.color_ramp.elements[0].color = (0, 0, 0, 1)
        wrinkle_ramp.color_ramp.elements[1].position = 0.55
        wrinkle_ramp.color_ramp.elements[1].color = (1, 1, 1, 1)
        links.new(noise.outputs['Fac'], wrinkle_ramp.inputs['Fac'])

        wrinkle_color = nodes.new('ShaderNodeRGB')
        wrinkle_color.location = (-300, 650)
        wrinkle_color.outputs[0].default_value = (
            sd["base"][0] * 0.85,
            sd["base"][1] * 0.80,
            sd["base"][2] * 0.82,
            1.0
        )

        mix_wrinkle = nodes.new('ShaderNodeMix')
        mix_wrinkle.location = (100, 400)
        mix_wrinkle.data_type = 'RGBA'
        mix_wrinkle.blend_type = 'MIX'
        mix_wrinkle.inputs['Factor'].default_value = 0.3
        links.new(wrinkle_ramp.outputs['Color'], mix_wrinkle.inputs['Factor'])
        links.new(current_color_output, mix_wrinkle.inputs[6])
        links.new(wrinkle_color.outputs[0], mix_wrinkle.inputs[7])
        current_color_output = mix_wrinkle.outputs[2]

    elif theme_id == "gothic":
        # Very subtle dark sheen variation for black cat
        noise = nodes.new('ShaderNodeTexNoise')
        noise.location = (-600, 500)
        noise.inputs['Scale'].default_value = 15.0
        noise.inputs['Detail'].default_value = 4.0
        noise.inputs['Roughness'].default_value = 0.6
        links.new(mapping.outputs['Vector'], noise.inputs['Vector'])

        sheen_color = nodes.new('ShaderNodeRGB')
        sheen_color.location = (-300, 650)
        # Very slightly lighter black with a blue tint
        sheen_color.outputs[0].default_value = (0.06, 0.06, 0.10, 1.0)

        mix_sheen = nodes.new('ShaderNodeMix')
        mix_sheen.location = (100, 400)
        mix_sheen.data_type = 'RGBA'
        mix_sheen.blend_type = 'MIX'
        links.new(noise.outputs['Fac'], mix_sheen.inputs['Factor'])
        links.new(current_color_output, mix_sheen.inputs[6])
        links.new(sheen_color.outputs[0], mix_sheen.inputs[7])
        current_color_output = mix_sheen.outputs[2]

        # Lower roughness for sleek look
        bsdf.inputs['Roughness'].default_value = 0.5

    # Connect final colour to BSDF
    links.new(current_color_output, bsdf.inputs['Base Color'])

    # ---- Create the bake target image ----
    img_name = f"cat_tex_{theme_id}"
    if img_name in bpy.data.images:
        bpy.data.images.remove(bpy.data.images[img_name])
    img = bpy.data.images.new(img_name, tex_size, tex_size, alpha=False)
    img.generated_color = sd["base"]

    # Add an Image Texture node for baking target (must be selected/active
    # in the node tree during bake)
    img_tex_node = nodes.new('ShaderNodeTexImage')
    img_tex_node.location = (200, -300)
    img_tex_node.image = img
    img_tex_node.label = "BakeTarget"
    # Make it the active node (required for bake target selection)
    nodes.active = img_tex_node

    return mat, img


def bake_texture(cat_obj, mat, img, theme_id):
    """
    Bake the procedural material to the image texture.
    Replaces the procedural nodes with the baked image for GLB export.
    """
    log(f"  Baking texture for '{theme_id}'...")

    # Set render engine to Cycles for baking
    original_engine = bpy.context.scene.render.engine
    bpy.context.scene.render.engine = 'CYCLES'
    bpy.context.scene.cycles.device = 'CPU'
    bpy.context.scene.cycles.samples = 4  # Low samples for baking (no noise needed)
    bpy.context.scene.cycles.use_denoising = False

    select_only(cat_obj)

    # Ensure the material is assigned
    if cat_obj.data.materials:
        cat_obj.data.materials[0] = mat
    else:
        cat_obj.data.materials.append(mat)

    # Ensure the bake target image node is active
    tree = mat.node_tree
    for node in tree.nodes:
        if node.type == 'TEX_IMAGE' and node.label == "BakeTarget":
            tree.nodes.active = node
            break

    # Bake
    try:
        bpy.ops.object.bake(
            type='DIFFUSE',
            pass_filter={'COLOR'},
            margin=4,
            margin_type='EXTEND',
            use_clear=True,
        )
        log(f"  Bake successful for '{theme_id}'.")
    except RuntimeError as e:
        log(f"  WARNING: Bake failed ({e}). Using solid colour fallback.")
        # Fill image with base colour as fallback
        sd = SKINS[theme_id]
        pixels = list(sd["base"][:3]) + [1.0]
        flat = pixels * (TEXTURE_SIZE * TEXTURE_SIZE)
        img.pixels.foreach_set(flat)
        img.update()

    # Restore render engine
    bpy.context.scene.render.engine = original_engine

    # Now replace the procedural nodes with the baked image.
    _replace_procedural_with_baked(mat, img)

    return img


def _replace_procedural_with_baked(mat, img):
    """
    Strip the procedural node tree and replace it with a simple
    Image Texture -> Principled BSDF setup for clean GLB export.
    """
    tree = mat.node_tree
    nodes = tree.nodes
    links = tree.links

    # Find the output and BSDF nodes
    output_node = None
    bsdf_node = None
    for n in nodes:
        if n.type == 'OUTPUT_MATERIAL':
            output_node = n
        elif n.type == 'BSDF_PRINCIPLED':
            bsdf_node = n

    # Remove everything except output
    nodes_to_keep = set()
    if output_node:
        nodes_to_keep.add(output_node.name)

    for n in list(nodes):
        if n.name not in nodes_to_keep:
            nodes.remove(n)

    # Recreate a clean Principled BSDF
    bsdf = nodes.new('ShaderNodeBsdfPrincipled')
    bsdf.location = (300, 0)
    bsdf.inputs['Roughness'].default_value = 0.7
    bsdf.inputs['Specular IOR Level'].default_value = 0.3

    # Image texture
    img_node = nodes.new('ShaderNodeTexImage')
    img_node.location = (0, 0)
    img_node.image = img

    links.new(img_node.outputs['Color'], bsdf.inputs['Base Color'])
    if output_node:
        links.new(bsdf.outputs['BSDF'], output_node.inputs['Surface'])


# ============================================================================
# BONE SCALE TWEAKS
# ============================================================================

def apply_bone_scale_tweaks(armature_obj, tweaks):
    """
    Apply breed-specific scale tweaks to bones in pose mode.
    tweaks = {"ear": float, "tail": float, "body": float}
    """
    if not armature_obj:
        return

    select_only(armature_obj)
    bpy.ops.object.mode_set(mode='POSE')

    pose_bones = armature_obj.pose.bones

    ear_scale = tweaks.get("ear", 1.0)
    tail_scale = tweaks.get("tail", 1.0)
    body_scale = tweaks.get("body", 1.0)

    # Ear bones
    for name in ["EarL", "EarR"]:
        if name in pose_bones:
            pb = pose_bones[name]
            pb.scale = (ear_scale, ear_scale, ear_scale)

    # Tail bones: scale along the bone's Y axis (length)
    for name in ["TailBase", "TailMid", "TailTip"]:
        if name in pose_bones:
            pb = pose_bones[name]
            pb.scale = (1.0, tail_scale, 1.0)

    # Body: scale the Spine and Chest for width/bulk
    for name in ["Spine", "Chest"]:
        if name in pose_bones:
            pb = pose_bones[name]
            pb.scale = (body_scale, 1.0, body_scale)

    # Apply pose as rest pose so the tweaks are baked in
    bpy.ops.pose.select_all(action='SELECT')
    bpy.ops.pose.armature_apply()

    bpy.ops.object.mode_set(mode='OBJECT')


# ============================================================================
# DUPLICATION AND EXPORT
# ============================================================================

def duplicate_base(cat_obj, armature_obj, suffix):
    """
    Duplicate the base cat mesh (and its armature if present).
    Returns (new_mesh_obj, new_armature_obj).
    """
    deselect_all()

    # Select mesh
    cat_obj.select_set(True)
    if armature_obj:
        armature_obj.select_set(True)
    bpy.context.view_layer.objects.active = cat_obj

    bpy.ops.object.duplicate()

    new_mesh = None
    new_arm = None
    for obj in bpy.context.selected_objects:
        if obj.type == 'MESH':
            new_mesh = obj
            new_mesh.name = f"Cat_{suffix}"
        elif obj.type == 'ARMATURE':
            new_arm = obj
            new_arm.name = f"CatArm_{suffix}"

    # Update armature modifier reference if both exist
    if new_mesh and new_arm:
        for mod in new_mesh.modifiers:
            if mod.type == 'ARMATURE':
                mod.object = new_arm
                break

    return new_mesh, new_arm


def export_cat_glb(cat_obj, armature_obj, output_dir, theme_id):
    """
    Export a single cat as a GLB file.
    """
    filename = f"cat_{theme_id}.glb"
    filepath = os.path.join(output_dir, filename)

    deselect_all()
    cat_obj.select_set(True)
    if armature_obj:
        armature_obj.select_set(True)

    bpy.context.view_layer.objects.active = cat_obj

    # Apply transforms before export
    for obj in bpy.context.selected_objects:
        bpy.context.view_layer.objects.active = obj
        bpy.ops.object.transform_apply(location=True, rotation=True, scale=True)

    # Re-select for export
    deselect_all()
    cat_obj.select_set(True)
    if armature_obj:
        armature_obj.select_set(True)
    bpy.context.view_layer.objects.active = cat_obj

    log(f"  Exporting: {filepath}")

    try:
        bpy.ops.export_scene.gltf(
            filepath=filepath,
            export_format='GLB',
            use_selection=True,
            export_apply=True,
            export_animations=True,
            export_skins=True,
            export_image_format='JPEG',
            export_yup=True,  # Godot expects Y-up
        )
        log(f"  Exported successfully: {filename}")
        return True
    except Exception as e:
        log(f"  ERROR exporting {filename}: {e}")
        traceback.print_exc()
        return False


def cleanup_themed_cat(cat_obj, armature_obj):
    """Remove the duplicated themed cat objects from the scene."""
    if cat_obj:
        bpy.data.objects.remove(cat_obj, do_unlink=True)
    if armature_obj:
        bpy.data.objects.remove(armature_obj, do_unlink=True)


# ============================================================================
# MAIN PIPELINE
# ============================================================================

def run_pipeline():
    """Main entry point. Runs either GENERATE or PROCESS, then themes + exports."""
    log("=" * 60)
    log("  Mindhause Cat Pipeline")
    log(f"  Mode: {MODE}")
    log("=" * 60)

    # Resolve output directory
    output_dir = resolve_output_dir()
    log(f"Output directory: {output_dir}")

    # Make sure we are in object mode
    if bpy.context.mode != 'OBJECT':
        bpy.ops.object.mode_set(mode='OBJECT')

    # ---- Step 1: Get or create the base cat ----
    if MODE == "GENERATE":
        # Clear the scene first
        log("Clearing existing scene objects...")
        bpy.ops.object.select_all(action='SELECT')
        bpy.ops.object.delete(use_global=False)

        # Generate mesh
        cat_obj = generate_cat_mesh()

        # Create and attach armature
        armature_obj = create_armature(cat_obj)

    elif MODE == "PROCESS":
        cat_obj, armature_obj = process_existing_model()
        if not cat_obj:
            log("ABORTING: No valid mesh found for processing.")
            return

    else:
        log(f"ERROR: Unknown mode '{MODE}'. Use 'GENERATE' or 'PROCESS'.")
        return

    log("")
    log("=" * 60)
    log("  Generating themed variants...")
    log("=" * 60)

    # ---- Step 2: For each theme, duplicate, texture, tweak, export ----
    success_count = 0
    fail_count = 0

    for theme_id, skin_data in SKINS.items():
        log("")
        log(f"--- Theme: {theme_id} ({skin_data['breed']}) ---")

        # Duplicate
        themed_mesh, themed_arm = duplicate_base(cat_obj, armature_obj, theme_id)
        if not themed_mesh:
            log(f"  ERROR: Failed to duplicate for theme '{theme_id}'")
            fail_count += 1
            continue

        # Apply bone scale tweaks
        tweaks = skin_data.get("scale_tweaks", {})
        if themed_arm and tweaks:
            log(f"  Applying scale tweaks: {tweaks}")
            apply_bone_scale_tweaks(themed_arm, tweaks)

        # Create procedural material
        mat, img = create_themed_material(theme_id, skin_data, TEXTURE_SIZE)

        # Assign material to mesh
        if themed_mesh.data.materials:
            themed_mesh.data.materials[0] = mat
        else:
            themed_mesh.data.materials.append(mat)

        # Bake texture
        bake_texture(themed_mesh, mat, img, theme_id)

        # Save baked image (for debugging / reuse)
        img_path = os.path.join(output_dir, f"cat_tex_{theme_id}.jpg")
        img.filepath_raw = img_path
        img.file_format = 'JPEG'
        try:
            img.save()
            log(f"  Saved texture: cat_tex_{theme_id}.jpg")
        except Exception as e:
            log(f"  WARNING: Could not save texture image ({e})")

        # Export GLB
        if export_cat_glb(themed_mesh, themed_arm, output_dir, theme_id):
            success_count += 1
        else:
            fail_count += 1

        # Cleanup the duplicate
        cleanup_themed_cat(themed_mesh, themed_arm)

        # Clean up material and image from memory to avoid bloat
        if mat and mat.users == 0:
            bpy.data.materials.remove(mat)
        if img and img.users == 0:
            bpy.data.images.remove(img)

    # ---- Step 3: Final cleanup ----
    log("")
    log("=" * 60)
    log("  Cleaning up base cat...")
    log("=" * 60)

    # Optionally keep the base cat in the scene for inspection.
    # Uncomment the next two lines to remove it:
    # cleanup_themed_cat(cat_obj, armature_obj)
    # log("  Base cat removed.")
    log("  Base cat kept in scene for inspection.")
    log("  (Delete it manually or uncomment cleanup in the script.)")

    # ---- Done ----
    log("")
    log("=" * 60)
    log(f"  PIPELINE COMPLETE")
    log(f"  Exported: {success_count}/{len(SKINS)} themes")
    if fail_count > 0:
        log(f"  Failed:   {fail_count}/{len(SKINS)} themes")
    log(f"  Output:   {output_dir}")
    log("=" * 60)

    # Report files
    log("")
    log("Generated files:")
    for theme_id in SKINS:
        glb = os.path.join(output_dir, f"cat_{theme_id}.glb")
        tex = os.path.join(output_dir, f"cat_tex_{theme_id}.jpg")
        exists_glb = "OK" if os.path.isfile(glb) else "MISSING"
        exists_tex = "OK" if os.path.isfile(tex) else "MISSING"
        log(f"  [{exists_glb}] {glb}")
        log(f"  [{exists_tex}] {tex}")


# ============================================================================
# ENTRY POINT
# ============================================================================

if __name__ == "__main__":
    try:
        run_pipeline()
    except Exception as e:
        log(f"FATAL ERROR: {e}")
        traceback.print_exc()
        log("Pipeline aborted. Check the console for details.")
