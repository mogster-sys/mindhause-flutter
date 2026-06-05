#!/usr/bin/env python3
"""Auto-generated Blender Python script from blender-cli."""

import bpy
import math
import os

# ── Clear Default Scene ──────────────────────────────────────
bpy.ops.object.select_all(action='SELECT')
bpy.ops.object.delete(use_global=False)

# ── Scene Settings ──────────────────────────────────────────
scene = bpy.context.scene
scene.unit_settings.system = 'METRIC'
scene.unit_settings.scale_length = 1.0
scene.frame_start = 1
scene.frame_end = 250
scene.frame_current = 1
scene.render.fps = 24

# ── Render Settings ─────────────────────────────────────────
scene.render.engine = 'CYCLES'
scene.render.resolution_x = 1024
scene.render.resolution_y = 1024
scene.render.resolution_percentage = 100
scene.render.film_transparent = False
scene.cycles.samples = 32
scene.cycles.use_denoising = True

# ── World Settings ──────────────────────────────────────────
world = bpy.data.worlds.get('World')
if world is None:
    world = bpy.data.worlds.new('World')
    scene.world = world
world.use_nodes = True
bg_node = world.node_tree.nodes.get('Background')
if bg_node:
    bg_node.inputs[0].default_value = (0.65, 0.72, 0.82, 1.0)

# ── Materials ───────────────────────────────────────────────
mat_marble = bpy.data.materials.new(name='marble')
mat_marble.use_nodes = True
bsdf_marble = mat_marble.node_tree.nodes.get('Principled BSDF')
if bsdf_marble:
    bsdf_marble.inputs['Base Color'].default_value = (0.95, 0.92, 0.85, 1.0)
    bsdf_marble.inputs['Metallic'].default_value = 0.0
    bsdf_marble.inputs['Roughness'].default_value = 0.32
    bsdf_marble.inputs['Specular IOR Level'].default_value = 0.5
    bsdf_marble.inputs['Alpha'].default_value = 1.0


# ── Objects ─────────────────────────────────────────────────
# Object: plinth
bpy.ops.mesh.primitive_cube_add(size=2.0, location=(0.0, 0.0, 0.1))
obj = bpy.context.active_object
obj.name = 'plinth'
obj.rotation_euler = (math.radians(0.0), math.radians(0.0), math.radians(0.0))
obj.scale = (1.2, 1.2, 0.2)
if 'mat_marble' in dir():
    obj.data.materials.append(mat_marble)

# Object: lower_torus
bpy.ops.mesh.primitive_torus_add(major_radius=0.55, minor_radius=0.08, major_segments=48, minor_segments=12, location=(0.0, 0.0, 0.27))
obj = bpy.context.active_object
obj.name = 'lower_torus'
obj.rotation_euler = (math.radians(0.0), math.radians(0.0), math.radians(0.0))
obj.scale = (1.0, 1.0, 1.0)
if 'mat_marble' in dir():
    obj.data.materials.append(mat_marble)

# Object: shaft
bpy.ops.mesh.primitive_cylinder_add(radius=0.4, depth=3.4, vertices=32, location=(0.0, 0.0, 2.0))
obj = bpy.context.active_object
obj.name = 'shaft'
obj.rotation_euler = (math.radians(0.0), math.radians(0.0), math.radians(0.0))
obj.scale = (1.0, 1.0, 1.0)
if 'mat_marble' in dir():
    obj.data.materials.append(mat_marble)

# Object: astragal
bpy.ops.mesh.primitive_torus_add(major_radius=0.42, minor_radius=0.04, major_segments=48, minor_segments=12, location=(0.0, 0.0, 3.75))
obj = bpy.context.active_object
obj.name = 'astragal'
obj.rotation_euler = (math.radians(0.0), math.radians(0.0), math.radians(0.0))
obj.scale = (1.0, 1.0, 1.0)
if 'mat_marble' in dir():
    obj.data.materials.append(mat_marble)

# Object: echinus
bpy.ops.mesh.primitive_cylinder_add(radius=0.55, depth=0.2, vertices=32, location=(0.0, 0.0, 3.92))
obj = bpy.context.active_object
obj.name = 'echinus'
obj.rotation_euler = (math.radians(0.0), math.radians(0.0), math.radians(0.0))
obj.scale = (1.0, 1.0, 1.0)
if 'mat_marble' in dir():
    obj.data.materials.append(mat_marble)

# Object: volute_east
bpy.ops.mesh.primitive_cylinder_add(radius=0.18, depth=0.4, vertices=32, location=(0.5, 0.0, 4.0))
obj = bpy.context.active_object
obj.name = 'volute_east'
obj.rotation_euler = (math.radians(90.0), math.radians(0.0), math.radians(0.0))
obj.scale = (1.0, 1.0, 1.0)
if 'mat_marble' in dir():
    obj.data.materials.append(mat_marble)

# Object: volute_west
bpy.ops.mesh.primitive_cylinder_add(radius=0.18, depth=0.4, vertices=32, location=(-0.5, 0.0, 4.0))
obj = bpy.context.active_object
obj.name = 'volute_west'
obj.rotation_euler = (math.radians(90.0), math.radians(0.0), math.radians(0.0))
obj.scale = (1.0, 1.0, 1.0)
if 'mat_marble' in dir():
    obj.data.materials.append(mat_marble)

# Object: abacus
bpy.ops.mesh.primitive_cube_add(size=2.0, location=(0.0, 0.0, 4.18))
obj = bpy.context.active_object
obj.name = 'abacus'
obj.rotation_euler = (math.radians(0.0), math.radians(0.0), math.radians(0.0))
obj.scale = (1.0, 0.15, 1.0)
if 'mat_marble' in dir():
    obj.data.materials.append(mat_marble)

# Object: ground
bpy.ops.mesh.primitive_plane_add(size=2.0, location=(0.0, 0.0, 0.0))
obj = bpy.context.active_object
obj.name = 'ground'
obj.rotation_euler = (math.radians(0.0), math.radians(0.0), math.radians(0.0))
obj.scale = (10.0, 10.0, 1.0)


# ── Object Parenting ───────────────────────────────────────
# (none)

# ── Cameras ─────────────────────────────────────────────────
cam_data = bpy.data.cameras.new(name='hero_cam')
cam_data.type = 'PERSP'
cam_data.lens = 50.0
cam_data.sensor_width = 36.0
cam_data.clip_start = 0.1
cam_data.clip_end = 1000.0
cam_obj = bpy.data.objects.new('hero_cam', cam_data)
bpy.context.collection.objects.link(cam_obj)
cam_obj.location = (0.0, -6.0, 3.0)
cam_obj.rotation_euler = (math.radians(80.5), math.radians(0.0), math.radians(0.0))
scene.camera = cam_obj


# ── Lights ──────────────────────────────────────────────────
light_data = bpy.data.lights.new(name='key_sun', type='SUN')
light_data.energy = 4.0
light_data.color = (1.0, 1.0, 1.0)
light_data.angle = 0.00918
light_obj = bpy.data.objects.new('key_sun', light_data)
bpy.context.collection.objects.link(light_obj)
light_obj.location = (3.0, -2.0, 8.0)
light_obj.rotation_euler = (math.radians(30.0), math.radians(0.0), math.radians(20.0))


# ── Keyframes ───────────────────────────────────────────────
# (none)


import bpy
bpy.ops.object.select_all(action='DESELECT')
for obj in bpy.data.objects:
    if obj.type == 'MESH' and obj.name != 'ground':
        obj.select_set(True)
bpy.context.view_layer.objects.active = bpy.data.objects.get('shaft')
out_glb = "/home/mogie/projects/mindhause/godot_palace/models/furniture/column_ionic.glb"
bpy.ops.export_scene.gltf(filepath=out_glb, export_format='GLB', use_selection=True, export_apply=True, export_materials='EXPORT', export_cameras=False, export_lights=False)
print(f'GLB: {out_glb}')
scene.render.image_settings.file_format = 'PNG'
scene.render.filepath = '/tmp/column_render.png'
scene.frame_set(1)
bpy.ops.render.render(write_still=True)
print('Preview: /tmp/column_render.png')
