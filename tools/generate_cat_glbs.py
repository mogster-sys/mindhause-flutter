#!/usr/bin/env python3
"""Generate 8 rigged, textured cat GLB files for Godot 4.3.

Each GLB contains a low-poly cat mesh (~800-1500 triangles) with:
- A 20-bone skeleton (armature)
- Proper skinning with smooth vertex weights
- A 512x512 albedo texture per theme
- Breed-specific proportion tweaks

Run with:
    /home/mogie/projects/mindhause/.venv/bin/python tools/generate_cat_glbs.py
"""

import io
import math
import os
import struct
import sys
from pathlib import Path

import numpy as np
from PIL import Image as PILImage, ImageDraw, ImageFilter

import pygltflib
from pygltflib import (
    GLTF2, Asset, Scene, Node, Mesh, Primitive, Attributes,
    Accessor, BufferView, Buffer, Skin, Material, PbrMetallicRoughness,
    TextureInfo, Texture, Sampler, Image as GLTFImage,
    FLOAT, UNSIGNED_SHORT, UNSIGNED_INT, VEC2, VEC3, VEC4, MAT4, SCALAR,
    ARRAY_BUFFER, ELEMENT_ARRAY_BUFFER, TRIANGLES,
    LINEAR, LINEAR_MIPMAP_LINEAR, CLAMP_TO_EDGE,
    IMAGEPNG,
)

# ---------------------------------------------------------------------------
# Data: skin colours and breed tweaks
# ---------------------------------------------------------------------------

SKINS = {
    "greco_roman": {
        "breed": "Turkish Angora",
        "base": (242, 242, 237),
        "accent": (224, 224, 217),
        "eye": (191, 153, 38),
        "nose": (230, 179, 179),
        "ear_inner": (242, 204, 199),
    },
    "victorian": {
        "breed": "British Shorthair",
        "base": (140, 148, 166),
        "accent": (115, 122, 140),
        "eye": (191, 128, 51),
        "nose": (153, 115, 115),
        "ear_inner": (179, 153, 153),
    },
    "ryokan": {
        "breed": "Japanese Bobtail",
        "base": (242, 235, 224),
        "accent": (217, 128, 51),
        "eye": (204, 153, 51),
        "nose": (230, 166, 153),
        "ear_inner": (242, 204, 191),
    },
    "cottage": {
        "breed": "Ginger Tabby",
        "base": (230, 153, 51),
        "accent": (191, 115, 38),
        "eye": (77, 153, 51),
        "nose": (217, 140, 128),
        "ear_inner": (242, 191, 166),
    },
    "gothic": {
        "breed": "Black Bombay",
        "base": (20, 20, 26),
        "accent": (13, 13, 18),
        "eye": (204, 166, 26),
        "nose": (38, 31, 31),
        "ear_inner": (51, 46, 46),
    },
    "scifi": {
        "breed": "Sphynx",
        "base": (191, 166, 173),
        "accent": (166, 140, 148),
        "eye": (102, 153, 230),
        "nose": (204, 153, 153),
        "ear_inner": (217, 179, 184),
    },
    "fallout": {
        "breed": "Scruffy Survivor",
        "base": (140, 115, 89),
        "accent": (102, 82, 64),
        "eye": (204, 179, 51),
        "nose": (153, 115, 102),
        "ear_inner": (166, 128, 115),
    },
    "modern_loft": {
        "breed": "Russian Blue",
        "base": (153, 166, 184),
        "accent": (128, 140, 158),
        "eye": (77, 179, 77),
        "nose": (140, 128, 140),
        "ear_inner": (179, 173, 184),
    },
}

SCALE_TWEAKS = {
    "greco_roman": {"ear": 1.0, "tail": 1.3, "body": 1.0},
    "victorian": {"ear": 0.85, "tail": 0.9, "body": 1.15},
    "ryokan": {"ear": 1.0, "tail": 0.4, "body": 0.95},
    "cottage": {"ear": 1.0, "tail": 1.0, "body": 1.05},
    "gothic": {"ear": 1.05, "tail": 1.1, "body": 0.95},
    "scifi": {"ear": 1.4, "tail": 1.1, "body": 0.9},
    "fallout": {"ear": 0.9, "tail": 0.95, "body": 1.0},
    "modern_loft": {"ear": 1.0, "tail": 1.05, "body": 0.95},
}

# ---------------------------------------------------------------------------
# Bone definitions
# ---------------------------------------------------------------------------

# Bone hierarchy: (name, parent_index_or_None)
# We list them in a topological order so parent always comes before child.
BONE_DEFS = [
    # idx  name            parent_idx
    (0,  "Root",           None),
    (1,  "Spine",          0),
    (2,  "Chest",          1),
    (3,  "Neck",           2),
    (4,  "Head",           3),
    (5,  "EarL",           4),
    (6,  "EarR",           4),
    (7,  "FrontLegL",      2),
    (8,  "FrontKneeL",     7),
    (9,  "FrontPawL",      8),
    (10, "FrontLegR",      2),
    (11, "FrontKneeR",     10),
    (12, "FrontPawR",      11),
    (13, "TailBase",       1),
    (14, "TailMid",        13),
    (15, "TailTip",        14),
    (16, "BackLegL",       1),
    (17, "BackKneeL",      16),
    (18, "BackPawL",       17),
    (19, "BackLegR",       1),
    (20, "BackKneeR",      19),
    (21, "BackPawR",       20),
]

NUM_BONES = len(BONE_DEFS)  # 22


def get_bone_rest_positions(tweaks):
    """Return world-space rest positions for each bone, accounting for breed tweaks."""
    body_s = tweaks.get("body", 1.0)
    tail_s = tweaks.get("tail", 1.0)
    ear_s = tweaks.get("ear", 1.0)

    # Cat dimensions: ~0.45m long, 0.25m tall at shoulder, facing -Z
    # Body center at origin, y=0.15 (shoulder height ~ 0.25, belly ~ 0.08)
    shoulder_y = 0.18
    hip_y = 0.16
    knee_y = 0.08
    paw_y = 0.0
    body_center_z = 0.0
    chest_z = -0.10 * body_s
    hip_z = 0.10 * body_s
    head_z = -0.22 * body_s
    neck_z = -0.17 * body_s
    nose_z = -0.28 * body_s

    # Leg X offsets (from center)
    leg_x = 0.06

    # Tail
    tail_base_z = 0.18 * body_s
    tail_mid_z = tail_base_z + 0.10 * tail_s
    tail_tip_z = tail_base_z + 0.20 * tail_s
    tail_base_y = hip_y + 0.02
    tail_mid_y = tail_base_y + 0.03 * tail_s
    tail_tip_y = tail_base_y + 0.06 * tail_s

    # Ears
    ear_y = shoulder_y + 0.12
    ear_x = 0.035 * ear_s
    ear_z = head_z + 0.02

    positions = {
        "Root":         np.array([0.0, shoulder_y, body_center_z]),
        "Spine":        np.array([0.0, shoulder_y, body_center_z]),
        "Chest":        np.array([0.0, shoulder_y, chest_z]),
        "Neck":         np.array([0.0, shoulder_y + 0.03, neck_z]),
        "Head":         np.array([0.0, shoulder_y + 0.06, head_z]),
        "EarL":         np.array([-ear_x, ear_y, ear_z]),
        "EarR":         np.array([ear_x, ear_y, ear_z]),
        "FrontLegL":    np.array([-leg_x, shoulder_y, chest_z]),
        "FrontKneeL":   np.array([-leg_x, knee_y, chest_z - 0.01]),
        "FrontPawL":    np.array([-leg_x, paw_y, chest_z - 0.02]),
        "FrontLegR":    np.array([leg_x, shoulder_y, chest_z]),
        "FrontKneeR":   np.array([leg_x, knee_y, chest_z - 0.01]),
        "FrontPawR":    np.array([leg_x, paw_y, chest_z - 0.02]),
        "TailBase":     np.array([0.0, tail_base_y, tail_base_z]),
        "TailMid":      np.array([0.0, tail_mid_y, tail_mid_z]),
        "TailTip":      np.array([0.0, tail_tip_y, tail_tip_z]),
        "BackLegL":     np.array([-leg_x, hip_y, hip_z]),
        "BackKneeL":    np.array([-leg_x, knee_y, hip_z + 0.01]),
        "BackPawL":     np.array([-leg_x, paw_y, hip_z + 0.02]),
        "BackLegR":     np.array([leg_x, hip_y, hip_z]),
        "BackKneeR":    np.array([leg_x, knee_y, hip_z + 0.01]),
        "BackPawR":     np.array([leg_x, paw_y, hip_z + 0.02]),
    }

    return positions


# ---------------------------------------------------------------------------
# Mesh generation helpers
# ---------------------------------------------------------------------------

def make_ellipsoid(cx, cy, cz, rx, ry, rz, lat_steps=8, lon_steps=12):
    """Generate ellipsoid vertices, normals, and triangle indices.

    Returns (verts Nx3, normals Nx3, indices Mx3).
    """
    verts = []
    norms = []
    for i in range(lat_steps + 1):
        theta = math.pi * i / lat_steps
        st = math.sin(theta)
        ct = math.cos(theta)
        for j in range(lon_steps + 1):
            phi = 2 * math.pi * j / lon_steps
            sp = math.sin(phi)
            cp = math.cos(phi)
            nx, ny, nz = st * cp, ct, st * sp
            verts.append([cx + rx * nx, cy + ry * ny, cz + rz * nz])
            norms.append([nx, ny, nz])

    tris = []
    for i in range(lat_steps):
        for j in range(lon_steps):
            a = i * (lon_steps + 1) + j
            b = a + lon_steps + 1
            tris.append([a, b, a + 1])
            tris.append([a + 1, b, b + 1])

    return np.array(verts, dtype=np.float32), np.array(norms, dtype=np.float32), np.array(tris, dtype=np.uint32)


def make_tapered_cylinder(p0, p1, r0, r1, segments=8):
    """Generate a tapered cylinder from p0 to p1 with radii r0 and r1.

    Returns (verts Nx3, normals Nx3, indices Mx3).
    """
    p0 = np.array(p0, dtype=np.float32)
    p1 = np.array(p1, dtype=np.float32)
    axis = p1 - p0
    length = np.linalg.norm(axis)
    if length < 1e-8:
        axis = np.array([0, 1, 0], dtype=np.float32)
        length = 1.0
    axis = axis / length

    # Build orthonormal basis
    if abs(axis[1]) < 0.99:
        perp = np.cross(axis, np.array([0, 1, 0], dtype=np.float32))
    else:
        perp = np.cross(axis, np.array([1, 0, 0], dtype=np.float32))
    perp = perp / np.linalg.norm(perp)
    perp2 = np.cross(axis, perp)
    perp2 = perp2 / np.linalg.norm(perp2)

    rings = 2  # bottom and top
    verts = []
    norms = []
    for ring in range(rings):
        t = ring / (rings - 1)
        center = p0 + axis * length * t
        r = r0 + (r1 - r0) * t
        for s in range(segments + 1):
            angle = 2 * math.pi * s / segments
            ca = math.cos(angle)
            sa = math.sin(angle)
            offset = perp * ca + perp2 * sa
            verts.append(center + r * offset)
            # Normal points outward (approximate for taper)
            n = offset.copy()
            n = n / (np.linalg.norm(n) + 1e-8)
            norms.append(n)

    verts = np.array(verts, dtype=np.float32)
    norms = np.array(norms, dtype=np.float32)

    tris = []
    for ring in range(rings - 1):
        for s in range(segments):
            a = ring * (segments + 1) + s
            b = a + segments + 1
            tris.append([a, b, a + 1])
            tris.append([a + 1, b, b + 1])

    # Cap top and bottom
    # bottom center
    bc_idx = len(verts)
    verts = np.vstack([verts, p0.reshape(1, 3)])
    norms = np.vstack([norms, (-axis).reshape(1, 3)])
    for s in range(segments):
        tris.append([bc_idx, s + 1, s])

    # top center
    tc_idx = len(verts)
    verts = np.vstack([verts, p1.reshape(1, 3)])
    norms = np.vstack([norms, axis.reshape(1, 3)])
    top_start = (rings - 1) * (segments + 1)
    for s in range(segments):
        tris.append([tc_idx, top_start + s, top_start + s + 1])

    return verts, norms, np.array(tris, dtype=np.uint32)


def make_cone(base_center, tip, radius, segments=6):
    """Generate a cone (for ears). Returns (verts, normals, indices)."""
    bc = np.array(base_center, dtype=np.float32)
    tp = np.array(tip, dtype=np.float32)
    axis = tp - bc
    length = np.linalg.norm(axis)
    if length < 1e-8:
        return np.zeros((0, 3), dtype=np.float32), np.zeros((0, 3), dtype=np.float32), np.zeros((0, 3), dtype=np.uint32)
    axis_n = axis / length

    if abs(axis_n[1]) < 0.99:
        perp = np.cross(axis_n, np.array([0, 1, 0], dtype=np.float32))
    else:
        perp = np.cross(axis_n, np.array([1, 0, 0], dtype=np.float32))
    perp = perp / np.linalg.norm(perp)
    perp2 = np.cross(axis_n, perp)
    perp2 = perp2 / np.linalg.norm(perp2)

    verts = []
    norms = []
    # Base ring
    for s in range(segments + 1):
        angle = 2 * math.pi * s / segments
        ca = math.cos(angle)
        sa = math.sin(angle)
        offset = perp * ca + perp2 * sa
        verts.append(bc + radius * offset)
        # Cone normal: outward + slightly up
        n = offset + axis_n * (radius / length)
        n = n / (np.linalg.norm(n) + 1e-8)
        norms.append(n)

    # Tip vertex
    tip_idx = len(verts)
    verts.append(tp)
    norms.append(axis_n)

    # Base center
    base_idx = len(verts)
    verts.append(bc)
    norms.append(-axis_n)

    tris = []
    # Side triangles
    for s in range(segments):
        tris.append([s, s + 1, tip_idx])
    # Base cap
    for s in range(segments):
        tris.append([base_idx, s + 1, s])

    return np.array(verts, dtype=np.float32), np.array(norms, dtype=np.float32), np.array(tris, dtype=np.uint32)


def merge_meshes(mesh_list):
    """Merge list of (verts, normals, indices) into single arrays."""
    all_verts = []
    all_norms = []
    all_tris = []
    offset = 0
    for v, n, t in mesh_list:
        if len(v) == 0:
            continue
        all_verts.append(v)
        all_norms.append(n)
        all_tris.append(t + offset)
        offset += len(v)
    if not all_verts:
        return np.zeros((0, 3), dtype=np.float32), np.zeros((0, 3), dtype=np.float32), np.zeros((0, 3), dtype=np.uint32)
    return (
        np.vstack(all_verts).astype(np.float32),
        np.vstack(all_norms).astype(np.float32),
        np.vstack(all_tris).astype(np.uint32),
    )


# Body part tag constants for UV mapping and weight assignment
TAG_BODY = 0
TAG_HEAD = 1
TAG_EAR_L = 2
TAG_EAR_R = 3
TAG_LEG_FL = 4
TAG_LEG_FR = 5
TAG_LEG_BL = 6
TAG_LEG_BR = 7
TAG_TAIL = 8
TAG_NOSE = 9


def build_cat_mesh(tweaks):
    """Build complete cat mesh. Returns (verts, normals, indices, tags_per_vertex).

    tags_per_vertex assigns each vertex a body-part tag for UV/weight mapping.
    """
    body_s = tweaks.get("body", 1.0)
    tail_s = tweaks.get("tail", 1.0)
    ear_s = tweaks.get("ear", 1.0)

    parts = []  # list of (verts, normals, indices, tag)

    # --- Body (torso) ---
    # Elongated ellipsoid centered at (0, 0.15, 0), long axis along Z
    body_rx = 0.07 * body_s
    body_ry = 0.06 * body_s
    body_rz = 0.15 * body_s
    bv, bn, bi = make_ellipsoid(0, 0.15, 0, body_rx, body_ry, body_rz, lat_steps=8, lon_steps=14)
    parts.append((bv, bn, bi, TAG_BODY))

    # --- Head ---
    head_z = -0.22 * body_s
    head_y = 0.24
    head_rx = 0.055
    head_ry = 0.05
    head_rz = 0.055
    hv, hn, hi = make_ellipsoid(0, head_y, head_z, head_rx, head_ry, head_rz, lat_steps=8, lon_steps=12)
    parts.append((hv, hn, hi, TAG_HEAD))

    # --- Nose bump ---
    nose_z = head_z - 0.05
    nose_y = head_y - 0.01
    nv, nn, ni = make_ellipsoid(0, nose_y, nose_z, 0.015, 0.012, 0.015, lat_steps=5, lon_steps=6)
    parts.append((nv, nn, ni, TAG_NOSE))

    # --- Ears ---
    ear_base_y = head_y + 0.04
    ear_tip_y = ear_base_y + 0.06 * ear_s
    ear_base_z = head_z + 0.01
    ear_radius = 0.022 * ear_s

    # Left ear
    elv, eln, eli = make_cone(
        [-0.03 * ear_s, ear_base_y, ear_base_z],
        [-0.03 * ear_s, ear_tip_y, ear_base_z - 0.01],
        ear_radius, segments=6
    )
    parts.append((elv, eln, eli, TAG_EAR_L))

    # Right ear
    erv, ern, eri = make_cone(
        [0.03 * ear_s, ear_base_y, ear_base_z],
        [0.03 * ear_s, ear_tip_y, ear_base_z - 0.01],
        ear_radius, segments=6
    )
    parts.append((erv, ern, eri, TAG_EAR_R))

    # --- Legs ---
    leg_x = 0.06
    shoulder_y = 0.18
    hip_y = 0.16
    knee_y = 0.08
    paw_y = 0.0
    chest_z = -0.10 * body_s
    hip_z = 0.10 * body_s
    leg_r_top = 0.022
    leg_r_bot = 0.018

    # Front left leg
    fl_parts = []
    fl_parts.append(make_tapered_cylinder(
        [-leg_x, shoulder_y, chest_z], [-leg_x, knee_y, chest_z - 0.01],
        leg_r_top, leg_r_top * 0.9, segments=7
    ))
    fl_parts.append(make_tapered_cylinder(
        [-leg_x, knee_y, chest_z - 0.01], [-leg_x, paw_y, chest_z - 0.02],
        leg_r_top * 0.9, leg_r_bot, segments=7
    ))
    flv, fln, fli = merge_meshes(fl_parts)
    parts.append((flv, fln, fli, TAG_LEG_FL))

    # Front right leg
    fr_parts = []
    fr_parts.append(make_tapered_cylinder(
        [leg_x, shoulder_y, chest_z], [leg_x, knee_y, chest_z - 0.01],
        leg_r_top, leg_r_top * 0.9, segments=7
    ))
    fr_parts.append(make_tapered_cylinder(
        [leg_x, knee_y, chest_z - 0.01], [leg_x, paw_y, chest_z - 0.02],
        leg_r_top * 0.9, leg_r_bot, segments=7
    ))
    frv, frn, fri = merge_meshes(fr_parts)
    parts.append((frv, frn, fri, TAG_LEG_FR))

    # Back left leg
    bl_parts = []
    bl_parts.append(make_tapered_cylinder(
        [-leg_x, hip_y, hip_z], [-leg_x, knee_y, hip_z + 0.01],
        leg_r_top * 1.1, leg_r_top * 0.95, segments=7
    ))
    bl_parts.append(make_tapered_cylinder(
        [-leg_x, knee_y, hip_z + 0.01], [-leg_x, paw_y, hip_z + 0.02],
        leg_r_top * 0.95, leg_r_bot, segments=7
    ))
    blv, bln, bli = merge_meshes(bl_parts)
    parts.append((blv, bln, bli, TAG_LEG_BL))

    # Back right leg
    br_parts = []
    br_parts.append(make_tapered_cylinder(
        [leg_x, hip_y, hip_z], [leg_x, knee_y, hip_z + 0.01],
        leg_r_top * 1.1, leg_r_top * 0.95, segments=7
    ))
    br_parts.append(make_tapered_cylinder(
        [leg_x, knee_y, hip_z + 0.01], [leg_x, paw_y, hip_z + 0.02],
        leg_r_top * 0.95, leg_r_bot, segments=7
    ))
    brv, brn, bri = merge_meshes(br_parts)
    parts.append((brv, brn, bri, TAG_LEG_BR))

    # --- Tail ---
    tail_base_z = 0.18 * body_s
    tail_base_y = hip_y + 0.02
    tail_mid_z = tail_base_z + 0.10 * tail_s
    tail_mid_y = tail_base_y + 0.03 * tail_s
    tail_tip_z = tail_base_z + 0.20 * tail_s
    tail_tip_y = tail_base_y + 0.06 * tail_s
    tail_r = 0.015

    tail_parts = []
    tail_parts.append(make_tapered_cylinder(
        [0, tail_base_y, tail_base_z], [0, tail_mid_y, tail_mid_z],
        tail_r, tail_r * 0.8, segments=7
    ))
    tail_parts.append(make_tapered_cylinder(
        [0, tail_mid_y, tail_mid_z], [0, tail_tip_y, tail_tip_z],
        tail_r * 0.8, tail_r * 0.3, segments=7
    ))
    tv, tn, ti = merge_meshes(tail_parts)
    parts.append((tv, tn, ti, TAG_TAIL))

    # --- Merge all parts ---
    all_verts = []
    all_norms = []
    all_tris = []
    all_tags = []
    offset = 0
    for v, n, t, tag in parts:
        if len(v) == 0:
            continue
        all_verts.append(v)
        all_norms.append(n)
        all_tris.append(t + offset)
        all_tags.extend([tag] * len(v))
        offset += len(v)

    verts = np.vstack(all_verts).astype(np.float32)
    norms = np.vstack(all_norms).astype(np.float32)
    tris = np.vstack(all_tris).astype(np.uint32)
    tags = np.array(all_tags, dtype=np.int32)

    return verts, norms, tris, tags


# ---------------------------------------------------------------------------
# UV coordinate generation
# ---------------------------------------------------------------------------

def generate_uvs(verts, tags):
    """Generate UV coordinates that map body parts to specific texture regions.

    Texture layout (512x512):
      Top-left quadrant (0,0)-(0.5,0.5): Body/base colour
      Top-right quadrant (0.5,0)-(1,0.5): Head
      Bottom-left quadrant (0,0.5)-(0.5,1): Legs/accent
      Bottom-right (0.5,0.5)-(0.75,0.75): Ears
      Bottom-right (0.75,0.5)-(1,0.75): Nose
      Bottom-right (0.5,0.75)-(1,1): Tail (uses base colour too)
    """
    uvs = np.zeros((len(verts), 2), dtype=np.float32)

    for i in range(len(verts)):
        tag = tags[i]
        v = verts[i]
        if tag == TAG_BODY:
            # Map body to top-left quadrant
            u = 0.05 + 0.4 * ((v[0] + 0.15) / 0.3)
            vv = 0.05 + 0.4 * ((v[2] + 0.2) / 0.4)
            uvs[i] = [np.clip(u, 0.02, 0.48), np.clip(vv, 0.02, 0.48)]
        elif tag == TAG_HEAD:
            u = 0.55 + 0.35 * ((v[0] + 0.06) / 0.12)
            vv = 0.05 + 0.35 * ((v[1] - 0.15) / 0.15)
            uvs[i] = [np.clip(u, 0.52, 0.98), np.clip(vv, 0.02, 0.48)]
        elif tag == TAG_NOSE:
            u = 0.8 + 0.15 * ((v[0] + 0.02) / 0.04)
            vv = 0.55 + 0.15 * ((v[1] - 0.2) / 0.06)
            uvs[i] = [np.clip(u, 0.76, 0.98), np.clip(vv, 0.52, 0.73)]
        elif tag == TAG_EAR_L:
            u = 0.52 + 0.1 * ((v[0] + 0.06) / 0.06)
            vv = 0.55 + 0.15 * ((v[1] - 0.25) / 0.1)
            uvs[i] = [np.clip(u, 0.52, 0.73), np.clip(vv, 0.52, 0.73)]
        elif tag == TAG_EAR_R:
            u = 0.62 + 0.1 * ((v[0]) / 0.06)
            vv = 0.55 + 0.15 * ((v[1] - 0.25) / 0.1)
            uvs[i] = [np.clip(u, 0.52, 0.73), np.clip(vv, 0.52, 0.73)]
        elif tag in (TAG_LEG_FL, TAG_LEG_FR, TAG_LEG_BL, TAG_LEG_BR):
            # Map legs to bottom-left quadrant
            u = 0.05 + 0.4 * ((v[0] + 0.1) / 0.2)
            vv = 0.55 + 0.4 * (v[1] / 0.25)
            uvs[i] = [np.clip(u, 0.02, 0.48), np.clip(vv, 0.52, 0.98)]
        elif tag == TAG_TAIL:
            u = 0.55 + 0.4 * ((v[2] - 0.1) / 0.3)
            vv = 0.78 + 0.18 * ((v[1] - 0.1) / 0.15)
            uvs[i] = [np.clip(u, 0.52, 0.98), np.clip(vv, 0.76, 0.98)]
        else:
            uvs[i] = [0.25, 0.25]

    return uvs


# ---------------------------------------------------------------------------
# Skinning weights
# ---------------------------------------------------------------------------

def compute_skin_weights(verts, tags, bone_positions, tweaks):
    """Compute per-vertex joint indices and weights (max 4 per vertex).

    Returns (joints Nx4 uint16, weights Nx4 float32).
    """
    num_verts = len(verts)
    joints = np.zeros((num_verts, 4), dtype=np.uint16)
    weights = np.zeros((num_verts, 4), dtype=np.float32)

    bone_names = [b[1] for b in BONE_DEFS]
    bone_idx = {name: i for i, name in enumerate(bone_names)}

    # Precompute bone world positions as array
    bone_pos = np.zeros((NUM_BONES, 3), dtype=np.float32)
    for name, pos in bone_positions.items():
        bone_pos[bone_idx[name]] = pos

    for i in range(num_verts):
        v = verts[i]
        tag = tags[i]

        if tag == TAG_BODY:
            # Blend between Spine and Chest based on Z
            spine_idx = bone_idx["Spine"]
            chest_idx = bone_idx["Chest"]
            # How far forward (negative Z = forward/chest)
            z_val = v[2]
            t = np.clip((-z_val + 0.05) / 0.2, 0.0, 1.0)  # 0=spine, 1=chest
            joints[i] = [spine_idx, chest_idx, 0, 0]
            weights[i] = [1.0 - t, t, 0, 0]

        elif tag == TAG_HEAD:
            head_idx = bone_idx["Head"]
            neck_idx = bone_idx["Neck"]
            # Blend near connection to neck
            head_pos = bone_pos[head_idx]
            neck_pos = bone_pos[neck_idx]
            d_head = np.linalg.norm(v - head_pos)
            d_neck = np.linalg.norm(v - neck_pos)
            total = d_head + d_neck + 1e-8
            w_head = 1.0 - (d_head / total)
            w_neck = 1.0 - (d_neck / total)
            # Normalize
            s = w_head + w_neck
            joints[i] = [head_idx, neck_idx, 0, 0]
            weights[i] = [w_head / s, w_neck / s, 0, 0]

        elif tag == TAG_NOSE:
            head_idx = bone_idx["Head"]
            joints[i] = [head_idx, 0, 0, 0]
            weights[i] = [1.0, 0, 0, 0]

        elif tag == TAG_EAR_L:
            ear_idx = bone_idx["EarL"]
            head_idx = bone_idx["Head"]
            joints[i] = [ear_idx, head_idx, 0, 0]
            weights[i] = [0.8, 0.2, 0, 0]

        elif tag == TAG_EAR_R:
            ear_idx = bone_idx["EarR"]
            head_idx = bone_idx["Head"]
            joints[i] = [ear_idx, head_idx, 0, 0]
            weights[i] = [0.8, 0.2, 0, 0]

        elif tag == TAG_LEG_FL:
            _assign_leg_weights(v, i, joints, weights, bone_idx, bone_pos,
                                "FrontLegL", "FrontKneeL", "FrontPawL")

        elif tag == TAG_LEG_FR:
            _assign_leg_weights(v, i, joints, weights, bone_idx, bone_pos,
                                "FrontLegR", "FrontKneeR", "FrontPawR")

        elif tag == TAG_LEG_BL:
            _assign_leg_weights(v, i, joints, weights, bone_idx, bone_pos,
                                "BackLegL", "BackKneeL", "BackPawL")

        elif tag == TAG_LEG_BR:
            _assign_leg_weights(v, i, joints, weights, bone_idx, bone_pos,
                                "BackLegR", "BackKneeR", "BackPawR")

        elif tag == TAG_TAIL:
            _assign_tail_weights(v, i, joints, weights, bone_idx, bone_pos, tweaks)

    # Normalize weights so they sum to 1.0
    w_sums = weights.sum(axis=1, keepdims=True)
    w_sums = np.maximum(w_sums, 1e-8)
    weights = weights / w_sums

    return joints, weights


def _assign_leg_weights(v, i, joints, weights, bone_idx, bone_pos,
                        upper_name, knee_name, paw_name):
    """Assign blended weights along a leg chain based on Y position."""
    upper_idx = bone_idx[upper_name]
    knee_idx = bone_idx[knee_name]
    paw_idx = bone_idx[paw_name]

    upper_y = bone_pos[upper_idx][1]
    knee_y = bone_pos[knee_idx][1]
    paw_y = bone_pos[paw_idx][1]

    y = v[1]

    if y >= knee_y:
        # Upper portion: blend upper and knee
        t = np.clip((upper_y - y) / (upper_y - knee_y + 1e-8), 0, 1)
        joints[i] = [upper_idx, knee_idx, 0, 0]
        weights[i] = [1.0 - t, t, 0, 0]
    else:
        # Lower portion: blend knee and paw
        t = np.clip((knee_y - y) / (knee_y - paw_y + 1e-8), 0, 1)
        joints[i] = [knee_idx, paw_idx, 0, 0]
        weights[i] = [1.0 - t, t, 0, 0]


def _assign_tail_weights(v, i, joints, weights, bone_idx, bone_pos, tweaks):
    """Assign blended weights along the tail chain based on Z position."""
    base_idx = bone_idx["TailBase"]
    mid_idx = bone_idx["TailMid"]
    tip_idx = bone_idx["TailTip"]

    base_z = bone_pos[base_idx][2]
    mid_z = bone_pos[mid_idx][2]
    tip_z = bone_pos[tip_idx][2]

    z = v[2]

    if z <= mid_z:
        # Base to mid
        t = np.clip((z - base_z) / (mid_z - base_z + 1e-8), 0, 1)
        joints[i] = [base_idx, mid_idx, 0, 0]
        weights[i] = [1.0 - t, t, 0, 0]
    else:
        # Mid to tip
        t = np.clip((z - mid_z) / (tip_z - mid_z + 1e-8), 0, 1)
        joints[i] = [mid_idx, tip_idx, 0, 0]
        weights[i] = [1.0 - t, t, 0, 0]


# ---------------------------------------------------------------------------
# Texture generation
# ---------------------------------------------------------------------------

def generate_texture(theme_id, skin_data):
    """Generate a 512x512 albedo texture for the given theme. Returns PNG bytes."""
    size = 512
    img = PILImage.new("RGB", (size, size), skin_data["base"])
    draw = ImageDraw.Draw(img)

    base = skin_data["base"]
    accent = skin_data["accent"]
    nose = skin_data["nose"]
    ear_inner = skin_data["ear_inner"]
    eye = skin_data["eye"]

    # Top-left quadrant (body) - base colour with slight gradient
    for y in range(0, size // 2):
        blend = y / (size // 2)
        r = int(base[0] * (1 - blend * 0.05) + accent[0] * blend * 0.05)
        g = int(base[1] * (1 - blend * 0.05) + accent[1] * blend * 0.05)
        b = int(base[2] * (1 - blend * 0.05) + accent[2] * blend * 0.05)
        draw.line([(0, y), (size // 2, y)], fill=(r, g, b))

    # Top-right quadrant (head) - base colour, slightly lighter
    head_col = tuple(min(255, c + 5) for c in base)
    draw.rectangle([size // 2, 0, size, size // 2], fill=head_col)

    # Small eye dots in head region
    eye_y = size // 4
    draw.ellipse([size * 3 // 4 - 15, eye_y - 8, size * 3 // 4 - 5, eye_y + 2], fill=eye)
    draw.ellipse([size * 3 // 4 + 5, eye_y - 8, size * 3 // 4 + 15, eye_y + 2], fill=eye)

    # Bottom-left quadrant (legs) - accent colour
    draw.rectangle([0, size // 2, size // 2, size], fill=accent)

    # Bottom-right: ear region (0.5-0.75, 0.5-0.75)
    draw.rectangle([size // 2, size // 2, size * 3 // 4, size * 3 // 4], fill=ear_inner)

    # Bottom-right: nose region (0.75-1.0, 0.5-0.75)
    draw.rectangle([size * 3 // 4, size // 2, size, size * 3 // 4], fill=nose)

    # Bottom-right: tail region (0.5-1.0, 0.75-1.0)
    draw.rectangle([size // 2, size * 3 // 4, size, size], fill=base)

    # Theme-specific patterns
    if theme_id == "cottage":
        # Tabby stripes on body region
        stripe_col = accent
        for sy in range(0, size // 2, 18):
            for sx in range(0, size // 2, 3):
                wave = int(8 * math.sin(sx * 0.05 + sy * 0.1))
                y1 = sy + wave
                y2 = sy + 5 + wave
                if 0 <= y1 < size // 2 and 0 <= y2 < size // 2:
                    draw.rectangle([sx, y1, sx + 2, y2], fill=stripe_col)

    elif theme_id == "ryokan":
        # Calico patches on body
        np_rng = np.random.RandomState(42)
        for _ in range(12):
            px = np_rng.randint(10, size // 2 - 30)
            py = np_rng.randint(10, size // 2 - 30)
            pw = np_rng.randint(15, 40)
            ph = np_rng.randint(15, 40)
            draw.ellipse([px, py, px + pw, py + ph], fill=accent)
        # Some dark patches
        dark_patch = (51, 38, 26)
        for _ in range(5):
            px = np_rng.randint(10, size // 2 - 30)
            py = np_rng.randint(10, size // 2 - 30)
            pw = np_rng.randint(10, 30)
            ph = np_rng.randint(10, 30)
            draw.ellipse([px, py, px + pw, py + ph], fill=dark_patch)

    elif theme_id == "fallout":
        # Dirt/noise texture overlay
        np_rng = np.random.RandomState(123)
        pixels = np.array(img)
        noise = np_rng.randint(-20, 20, size=pixels.shape, dtype=np.int16)
        pixels = np.clip(pixels.astype(np.int16) + noise, 0, 255).astype(np.uint8)
        img = PILImage.fromarray(pixels)
        # Add some scratches
        draw = ImageDraw.Draw(img)
        for _ in range(20):
            x1 = np_rng.randint(0, size)
            y1 = np_rng.randint(0, size)
            x2 = x1 + np_rng.randint(-30, 30)
            y2 = y1 + np_rng.randint(-30, 30)
            scratch_col = tuple(max(0, c - 30) for c in accent)
            draw.line([(x1, y1), (x2, y2)], fill=scratch_col, width=1)

    # Slight blur for smoothness
    img = img.filter(ImageFilter.GaussianBlur(radius=1))

    # Save to bytes
    buf = io.BytesIO()
    img.save(buf, format="PNG")
    return buf.getvalue()


# ---------------------------------------------------------------------------
# Inverse bind matrix computation
# ---------------------------------------------------------------------------

def compute_inverse_bind_matrices(bone_positions):
    """Compute inverse bind matrices for each bone.

    The bind matrix for a bone is a translation to the bone's world position.
    The inverse bind matrix transforms vertices from model space to bone-local space.

    Returns list of 4x4 matrices (column-major flat list of 16 floats each).
    """
    bone_names = [b[1] for b in BONE_DEFS]
    matrices = []
    for name in bone_names:
        pos = bone_positions[name]
        # The bind matrix is T(pos), so inverse is T(-pos)
        # glTF stores matrices in column-major order
        inv_bind = np.eye(4, dtype=np.float32)
        inv_bind[0, 3] = -pos[0]
        inv_bind[1, 3] = -pos[1]
        inv_bind[2, 3] = -pos[2]
        # Convert to column-major flat array
        matrices.append(inv_bind.T.flatten().tolist())
    return matrices


def compute_bone_local_translations(bone_positions):
    """Compute local translation of each bone relative to its parent.

    Returns dict: bone_name -> [tx, ty, tz].
    """
    bone_names = [b[1] for b in BONE_DEFS]
    parent_map = {b[1]: b[2] for b in BONE_DEFS}
    parent_idx_map = {}
    for idx, name, parent_idx in BONE_DEFS:
        parent_idx_map[name] = parent_idx

    local_translations = {}
    for idx, name, parent_idx in BONE_DEFS:
        if parent_idx is None:
            local_translations[name] = bone_positions[name].tolist()
        else:
            parent_name = bone_names[parent_idx]
            parent_pos = bone_positions[parent_name]
            local_translations[name] = (bone_positions[name] - parent_pos).tolist()

    return local_translations


# ---------------------------------------------------------------------------
# GLTF assembly
# ---------------------------------------------------------------------------

def pad_to_4(data):
    """Pad bytes to 4-byte alignment."""
    remainder = len(data) % 4
    if remainder:
        data += b'\x00' * (4 - remainder)
    return data


def build_glb(theme_id, skin_data, tweaks):
    """Build a complete GLB file for one cat theme. Returns the file path."""

    bone_positions = get_bone_rest_positions(tweaks)

    # Build mesh
    verts, normals, indices, tags = build_cat_mesh(tweaks)
    uvs = generate_uvs(verts, tags)
    joint_indices, joint_weights = compute_skin_weights(
        verts, tags, bone_positions, tweaks
    )

    num_verts = len(verts)
    num_tris = len(indices)
    num_indices = num_tris * 3

    print(f"  {theme_id}: {num_verts} vertices, {num_tris} triangles, {NUM_BONES} bones")

    # Flatten indices to 1D
    indices_flat = indices.flatten().astype(np.uint32)

    # Generate texture
    tex_data = generate_texture(theme_id, skin_data)

    # Compute inverse bind matrices
    ibm_list = compute_inverse_bind_matrices(bone_positions)
    ibm_flat = np.array([v for m in ibm_list for v in m], dtype=np.float32)

    # Compute local translations
    local_trans = compute_bone_local_translations(bone_positions)

    # -----------------------------------------------------------------------
    # Pack binary buffer
    # -----------------------------------------------------------------------
    buffer_data = bytearray()

    def add_data(data_bytes):
        """Add data to buffer, return (offset, length). Pads to 4 bytes."""
        nonlocal buffer_data
        offset = len(buffer_data)
        buffer_data.extend(data_bytes)
        # Pad to 4-byte alignment
        remainder = len(buffer_data) % 4
        if remainder:
            buffer_data.extend(b'\x00' * (4 - remainder))
        return offset, len(data_bytes)

    # 0: Vertex positions (VEC3 FLOAT)
    pos_bytes = verts.tobytes()
    pos_offset, pos_len = add_data(pos_bytes)

    # 1: Vertex normals (VEC3 FLOAT)
    norm_bytes = normals.tobytes()
    norm_offset, norm_len = add_data(norm_bytes)

    # 2: Texture coordinates (VEC2 FLOAT)
    uv_bytes = uvs.tobytes()
    uv_offset, uv_len = add_data(uv_bytes)

    # 3: Joint indices (VEC4 UNSIGNED_SHORT)
    joint_bytes = joint_indices.astype(np.uint16).tobytes()
    joint_offset, joint_len = add_data(joint_bytes)

    # 4: Joint weights (VEC4 FLOAT)
    weight_bytes = joint_weights.astype(np.float32).tobytes()
    weight_offset, weight_len = add_data(weight_bytes)

    # 5: Triangle indices (SCALAR UNSIGNED_INT)
    idx_bytes = indices_flat.tobytes()
    idx_offset, idx_len = add_data(idx_bytes)

    # 6: Inverse bind matrices (MAT4 FLOAT)
    ibm_bytes = ibm_flat.tobytes()
    ibm_offset, ibm_len = add_data(ibm_bytes)

    # 7: Texture image (PNG)
    tex_offset, tex_len = add_data(tex_data)

    # -----------------------------------------------------------------------
    # Build GLTF2 object
    # -----------------------------------------------------------------------
    gltf = GLTF2()
    gltf.asset = Asset(generator="mindhause-cat-generator")

    # Buffer
    gltf.buffers = [
        Buffer(byteLength=len(buffer_data))
    ]

    # BufferViews
    # 0: positions
    gltf.bufferViews.append(BufferView(
        buffer=0, byteOffset=pos_offset, byteLength=pos_len,
        target=ARRAY_BUFFER,
    ))
    # 1: normals
    gltf.bufferViews.append(BufferView(
        buffer=0, byteOffset=norm_offset, byteLength=norm_len,
        target=ARRAY_BUFFER,
    ))
    # 2: texcoords
    gltf.bufferViews.append(BufferView(
        buffer=0, byteOffset=uv_offset, byteLength=uv_len,
        target=ARRAY_BUFFER,
    ))
    # 3: joints
    gltf.bufferViews.append(BufferView(
        buffer=0, byteOffset=joint_offset, byteLength=joint_len,
        target=ARRAY_BUFFER,
    ))
    # 4: weights
    gltf.bufferViews.append(BufferView(
        buffer=0, byteOffset=weight_offset, byteLength=weight_len,
        target=ARRAY_BUFFER,
    ))
    # 5: indices
    gltf.bufferViews.append(BufferView(
        buffer=0, byteOffset=idx_offset, byteLength=idx_len,
        target=ELEMENT_ARRAY_BUFFER,
    ))
    # 6: inverse bind matrices
    gltf.bufferViews.append(BufferView(
        buffer=0, byteOffset=ibm_offset, byteLength=ibm_len,
    ))
    # 7: texture image
    gltf.bufferViews.append(BufferView(
        buffer=0, byteOffset=tex_offset, byteLength=tex_len,
    ))

    # Accessors
    # Compute min/max for positions
    pos_min = verts.min(axis=0).tolist()
    pos_max = verts.max(axis=0).tolist()

    # 0: positions
    gltf.accessors.append(Accessor(
        bufferView=0, byteOffset=0,
        componentType=FLOAT, count=num_verts, type=VEC3,
        max=pos_max, min=pos_min,
    ))
    # 1: normals
    gltf.accessors.append(Accessor(
        bufferView=1, byteOffset=0,
        componentType=FLOAT, count=num_verts, type=VEC3,
    ))
    # 2: texcoords
    gltf.accessors.append(Accessor(
        bufferView=2, byteOffset=0,
        componentType=FLOAT, count=num_verts, type=VEC2,
    ))
    # 3: joints
    gltf.accessors.append(Accessor(
        bufferView=3, byteOffset=0,
        componentType=UNSIGNED_SHORT, count=num_verts, type=VEC4,
    ))
    # 4: weights
    gltf.accessors.append(Accessor(
        bufferView=4, byteOffset=0,
        componentType=FLOAT, count=num_verts, type=VEC4,
    ))
    # 5: indices
    gltf.accessors.append(Accessor(
        bufferView=5, byteOffset=0,
        componentType=UNSIGNED_INT, count=num_indices, type=SCALAR,
        max=[int(indices_flat.max())], min=[int(indices_flat.min())],
    ))
    # 6: inverse bind matrices
    gltf.accessors.append(Accessor(
        bufferView=6, byteOffset=0,
        componentType=FLOAT, count=NUM_BONES, type=MAT4,
    ))

    # Image (embedded in buffer)
    gltf.images = [
        GLTFImage(
            bufferView=7,
            mimeType=IMAGEPNG,
            name=f"cat_{theme_id}_albedo",
        )
    ]

    # Sampler
    gltf.samplers = [
        Sampler(
            magFilter=LINEAR,
            minFilter=LINEAR_MIPMAP_LINEAR,
            wrapS=CLAMP_TO_EDGE,
            wrapT=CLAMP_TO_EDGE,
        )
    ]

    # Texture
    gltf.textures = [
        Texture(sampler=0, source=0, name=f"cat_{theme_id}_texture")
    ]

    # Material
    gltf.materials = [
        Material(
            name=f"cat_{theme_id}_material",
            pbrMetallicRoughness=PbrMetallicRoughness(
                baseColorTexture=TextureInfo(index=0),
                metallicFactor=0.0,
                roughnessFactor=0.9,
            ),
            doubleSided=True,
        )
    ]

    # Mesh
    gltf.meshes = [
        Mesh(
            name=f"cat_{theme_id}_mesh",
            primitives=[
                Primitive(
                    attributes=Attributes(
                        POSITION=0,
                        NORMAL=1,
                        TEXCOORD_0=2,
                        JOINTS_0=3,
                        WEIGHTS_0=4,
                    ),
                    indices=5,
                    material=0,
                    mode=TRIANGLES,
                )
            ]
        )
    ]

    # -----------------------------------------------------------------------
    # Build node hierarchy (skeleton)
    # -----------------------------------------------------------------------
    # Node layout:
    #   Node 0: Root scene node (mesh + skin reference)
    #   Nodes 1..NUM_BONES: Joint nodes (one per bone)

    bone_names = [b[1] for b in BONE_DEFS]

    # Create joint nodes (indices 1 to NUM_BONES)
    joint_node_indices = list(range(1, NUM_BONES + 1))  # node indices for joints

    # Build nodes list
    nodes = []

    # Node 0: Mesh root node
    mesh_node = Node(
        name=f"cat_{theme_id}",
        mesh=0,
        skin=0,
        children=[1],  # Root bone is node 1
    )
    nodes.append(mesh_node)

    # Nodes 1..NUM_BONES: Joint nodes
    for bone_idx, bone_name, parent_bone_idx in BONE_DEFS:
        trans = local_trans[bone_name]

        # Collect children bone indices for this bone
        child_bone_indices = []
        for ci, cn, cp in BONE_DEFS:
            if cp == bone_idx:
                child_bone_indices.append(ci + 1)  # +1 because node 0 is mesh node

        joint_node = Node(
            name=bone_name,
            translation=trans,
            children=child_bone_indices if child_bone_indices else [],
        )
        nodes.append(joint_node)

    gltf.nodes = nodes

    # Skin
    gltf.skins = [
        Skin(
            name=f"cat_{theme_id}_skeleton",
            inverseBindMatrices=6,  # accessor index for IBM
            joints=joint_node_indices,
            skeleton=1,  # Root bone node
        )
    ]

    # Scene
    gltf.scenes = [
        Scene(name=f"cat_{theme_id}_scene", nodes=[0])
    ]
    gltf.scene = 0

    # Set binary blob
    gltf.set_binary_blob(bytes(buffer_data))

    return gltf


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main():
    project_root = Path(__file__).resolve().parent.parent
    output_dir = project_root / "godot_palace" / "models" / "cats"
    output_dir.mkdir(parents=True, exist_ok=True)

    print(f"Generating cat GLB files in: {output_dir}")
    print(f"Number of themes: {len(SKINS)}")
    print()

    for theme_id, skin_data in SKINS.items():
        tweaks = SCALE_TWEAKS[theme_id]
        print(f"Building cat_{theme_id}.glb ({skin_data['breed']})...")

        gltf = build_glb(theme_id, skin_data, tweaks)

        output_path = output_dir / f"cat_{theme_id}.glb"
        gltf.save_binary(str(output_path))
        file_size = output_path.stat().st_size
        print(f"  Saved: {output_path} ({file_size:,} bytes)")
        print()

    print("Done! All 8 cat GLB files generated.")


if __name__ == "__main__":
    main()
