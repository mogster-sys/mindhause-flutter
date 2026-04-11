## CatSkin — theme-based reskinning for the cat companion
## Swaps colours/materials per theme. Falls back to primitive mesh with colour swap
## when no GLB model exists. Drops in real models when available.
extends Node

# Theme-to-breed skin data
# base_color: main fur colour
# accent_color: darker fur areas (legs, ears)
# eye_color: eye spheres
# nose_color: nose
# ear_inner_color: inner ear
# scale_tweaks: breed proportion hints {ear_scale, tail_scale, body_scale}
var skin_data: Dictionary = {
	"greco_roman": {
		"breed": "Turkish Angora",
		"base_color": Color(0.95, 0.95, 0.93),   # White
		"accent_color": Color(0.88, 0.88, 0.85),
		"eye_color": Color(0.75, 0.6, 0.15),       # Gold
		"nose_color": Color(0.9, 0.7, 0.7),
		"ear_inner_color": Color(0.95, 0.8, 0.78),
		"scale_tweaks": {"ear": 1.0, "tail": 1.3, "body": 1.0},  # Fluffy tail
	},
	"victorian": {
		"breed": "British Shorthair",
		"base_color": Color(0.55, 0.58, 0.65),    # Blue-grey
		"accent_color": Color(0.45, 0.48, 0.55),
		"eye_color": Color(0.75, 0.5, 0.2),        # Copper
		"nose_color": Color(0.6, 0.45, 0.45),
		"ear_inner_color": Color(0.7, 0.6, 0.6),
		"scale_tweaks": {"ear": 0.85, "tail": 0.9, "body": 1.15},  # Stocky
	},
	"ryokan": {
		"breed": "Japanese Bobtail",
		"base_color": Color(0.95, 0.92, 0.88),    # White with patches
		"accent_color": Color(0.85, 0.5, 0.2),     # Orange patches
		"eye_color": Color(0.8, 0.6, 0.2),         # Amber
		"nose_color": Color(0.9, 0.65, 0.6),
		"ear_inner_color": Color(0.95, 0.8, 0.75),
		"scale_tweaks": {"ear": 1.0, "tail": 0.4, "body": 0.95},  # Stubby tail
	},
	"cottage": {
		"breed": "Ginger Tabby",
		"base_color": Color(0.9, 0.6, 0.2),       # Orange
		"accent_color": Color(0.75, 0.45, 0.15),   # Darker orange
		"eye_color": Color(0.3, 0.6, 0.2),         # Green
		"nose_color": Color(0.85, 0.55, 0.5),
		"ear_inner_color": Color(0.95, 0.75, 0.65),
		"scale_tweaks": {"ear": 1.0, "tail": 1.0, "body": 1.05},
	},
	"gothic": {
		"breed": "Black Bombay",
		"base_color": Color(0.08, 0.08, 0.1),     # Black
		"accent_color": Color(0.05, 0.05, 0.07),
		"eye_color": Color(0.8, 0.65, 0.1),        # Gold
		"nose_color": Color(0.15, 0.12, 0.12),
		"ear_inner_color": Color(0.2, 0.18, 0.18),
		"scale_tweaks": {"ear": 1.05, "tail": 1.1, "body": 0.95},  # Sleek
	},
	"scifi": {
		"breed": "Sphynx",
		"base_color": Color(0.75, 0.65, 0.68),    # Pink-grey
		"accent_color": Color(0.65, 0.55, 0.58),
		"eye_color": Color(0.4, 0.6, 0.9),         # Blue
		"nose_color": Color(0.8, 0.6, 0.6),
		"ear_inner_color": Color(0.85, 0.7, 0.72),
		"scale_tweaks": {"ear": 1.4, "tail": 1.1, "body": 0.9},  # Large ears, thin
	},
	"fallout": {
		"breed": "Scruffy Survivor",
		"base_color": Color(0.55, 0.45, 0.35),    # Mottled brown
		"accent_color": Color(0.4, 0.32, 0.25),
		"eye_color": Color(0.8, 0.7, 0.2),         # Yellow
		"nose_color": Color(0.6, 0.45, 0.4),
		"ear_inner_color": Color(0.65, 0.5, 0.45),
		"scale_tweaks": {"ear": 0.9, "tail": 0.95, "body": 1.0},  # Rough
	},
	"modern_loft": {
		"breed": "Russian Blue",
		"base_color": Color(0.6, 0.65, 0.72),     # Silver-blue
		"accent_color": Color(0.5, 0.55, 0.62),
		"eye_color": Color(0.3, 0.7, 0.3),         # Green
		"nose_color": Color(0.55, 0.5, 0.55),
		"ear_inner_color": Color(0.7, 0.68, 0.72),
		"scale_tweaks": {"ear": 1.0, "tail": 1.05, "body": 0.95},  # Sleek
	},
}

var _cat_mesh: Node3D = null
var _glb_instance: Node3D = null  # Holds loaded GLB model when available
var _glb_skeleton: Skeleton3D = null  # Skeleton3D found inside the GLB
var _glb_mesh_instances: Array[MeshInstance3D] = []  # MeshInstance3D nodes in the GLB


func setup(cat_mesh: Node3D) -> void:
	_cat_mesh = cat_mesh
	ThemeManager.theme_changed.connect(_on_theme_changed)
	# Apply current theme immediately
	apply_skin(ThemeManager.current_theme)


func _on_theme_changed(theme_id: String) -> void:
	apply_skin(theme_id)


func apply_skin(theme_id: String) -> void:
	if not _cat_mesh:
		return

	# First, try to load GLB model for this theme
	var theme_data: Dictionary = ThemeManager.get_theme_data(theme_id)
	var glb_path: String = theme_data.get("cat_model", "")

	if glb_path != "":
		var exists_rl: bool = ResourceLoader.exists(glb_path)
		var exists_fa: bool = FileAccess.file_exists(glb_path)
		print("[CatSkin] GLB path: ", glb_path, " | ResourceLoader: ", exists_rl, " | FileAccess: ", exists_fa)
		if exists_rl:
			var loaded: bool = _load_glb_model(glb_path)
			if loaded:
				return
			print("[CatSkin] GLB load failed, falling back to primitives")

	# No GLB — apply colour swap to primitive mesh
	_remove_glb_model()
	_cat_mesh.visible = true

	var data: Dictionary = skin_data.get(theme_id, skin_data["greco_roman"])
	_apply_colours(data)
	_apply_scale_tweaks(data.get("scale_tweaks", {}))


func _apply_colours(data: Dictionary) -> void:
	var base: Color = data.get("base_color", Color(0.85, 0.55, 0.25))
	var accent: Color = data.get("accent_color", Color(0.75, 0.45, 0.2))
	var eye: Color = data.get("eye_color", Color(0.15, 0.15, 0.1))
	var nose: Color = data.get("nose_color", Color(0.85, 0.55, 0.5))
	var ear_inner: Color = data.get("ear_inner_color", Color(0.95, 0.7, 0.65))

	# Body, head, tail — base colour
	_set_mesh_color("Body", base)
	_set_mesh_color("Head/HeadMesh", base)
	_set_mesh_color("TailBase/TailBaseMesh", base)
	_set_mesh_color("TailBase/TailMid/TailMidMesh", base)
	_set_mesh_color("TailBase/TailMid/TailTip/TailTipMesh", base)

	# Legs, ears — accent colour
	_set_mesh_color("LegFL", accent)
	_set_mesh_color("LegFR", accent)
	_set_mesh_color("LegBL", accent)
	_set_mesh_color("LegBR", accent)
	_set_mesh_color("Head/EarL/EarMesh", accent)
	_set_mesh_color("Head/EarR/EarMesh", accent)

	# Eyes
	_set_mesh_color("Head/EyeL", eye)
	_set_mesh_color("Head/EyeR", eye)

	# Nose
	_set_mesh_color("Head/Nose", nose)


func _set_mesh_color(path: String, color: Color) -> void:
	var mesh_node = _cat_mesh.get_node_or_null(path)
	if mesh_node and mesh_node is MeshInstance3D:
		var mat = mesh_node.get_surface_override_material(0)
		if mat and mat is StandardMaterial3D:
			mat.albedo_color = color


func _apply_scale_tweaks(tweaks: Dictionary) -> void:
	if tweaks.size() == 0:
		return

	# Ear scale
	var ear_scale: float = tweaks.get("ear", 1.0)
	var ear_l = _cat_mesh.get_node_or_null("Head/EarL")
	var ear_r = _cat_mesh.get_node_or_null("Head/EarR")
	if ear_l:
		ear_l.scale = Vector3.ONE * ear_scale
	if ear_r:
		ear_r.scale = Vector3.ONE * ear_scale

	# Tail scale (affects all segments)
	var tail_scale: float = tweaks.get("tail", 1.0)
	var tail = _cat_mesh.get_node_or_null("TailBase")
	if tail:
		tail.scale = Vector3(1, tail_scale, 1)

	# Body scale
	var body_scale: float = tweaks.get("body", 1.0)
	var body = _cat_mesh.get_node_or_null("Body")
	if body:
		body.scale.x = 1.8 * body_scale  # Preserve the original stretch
		body.scale.z = body_scale


# --- GLB model loading ---

func _load_glb_model(path: String) -> bool:
	var res = load(path)
	print("[CatSkin] load() returned: ", typeof(res), " / ", res)
	var scene = res as PackedScene
	if not scene:
		print("[CatSkin] Failed to cast to PackedScene")
		return false

	_remove_glb_model()

	# Hide primitive mesh
	_cat_mesh.visible = false

	# Instance the GLB model
	_glb_instance = scene.instantiate()
	_cat_mesh.get_parent().add_child(_glb_instance)
	_glb_instance.position = _cat_mesh.position
	print("[CatSkin] GLB instanced, child count: ", _glb_instance.get_child_count())

	# Search the GLB scene tree for a Skeleton3D and MeshInstance3D nodes
	_glb_skeleton = _find_node_by_type(_glb_instance, "Skeleton3D") as Skeleton3D
	_glb_mesh_instances.clear()
	_collect_mesh_instances(_glb_instance, _glb_mesh_instances)

	if _glb_skeleton:
		print("CatSkin: Found Skeleton3D in GLB model — enabling skeleton animation mode")

		# Try to find eye meshes for blink support in skeleton mode
		var eye_l: MeshInstance3D = null
		var eye_r: MeshInstance3D = null
		for mesh_inst in _glb_mesh_instances:
			var mesh_name = mesh_inst.name.to_lower()
			if "eye" in mesh_name:
				if "left" in mesh_name or "_l" in mesh_name or ".l" in mesh_name or "eye_l" in mesh_name:
					eye_l = mesh_inst
				elif "right" in mesh_name or "_r" in mesh_name or ".r" in mesh_name or "eye_r" in mesh_name:
					eye_r = mesh_inst

		# Hand over the skeleton to CatProcedural for bone-based animation
		var procedural = get_parent().get_node_or_null("CatProcedural")
		if procedural and procedural.has_method("setup_skeleton"):
			procedural.setup_skeleton(_glb_skeleton, eye_l, eye_r)
	else:
		print("CatSkin: No Skeleton3D in GLB model — skeleton animation not available")

	# Apply theme material to the GLB model's mesh instances
	_apply_glb_material()
	return true


func _remove_glb_model() -> void:
	if _glb_instance and is_instance_valid(_glb_instance):
		_glb_instance.queue_free()
		_glb_instance = null

	_glb_skeleton = null
	_glb_mesh_instances.clear()

	# Switch CatProcedural back to primitive mode
	if _cat_mesh:
		var procedural = get_parent().get_node_or_null("CatProcedural")
		if procedural and procedural.has_method("setup"):
			procedural.setup(_cat_mesh)


## Apply the current theme's texture/colour to GLB mesh materials.
## For GLB models we swap the albedo_texture on existing materials if the
## theme provides a texture, otherwise we tint the albedo_color.
func _apply_glb_material() -> void:
	if _glb_mesh_instances.size() == 0:
		return

	var theme_data: Dictionary = ThemeManager.get_theme_data(ThemeManager.current_theme)
	var texture_path: String = theme_data.get("cat_texture", "")
	var texture: Texture2D = null
	if texture_path != "" and ResourceLoader.exists(texture_path):
		texture = load(texture_path) as Texture2D

	for mesh_inst in _glb_mesh_instances:
		for surface_idx in range(mesh_inst.get_surface_override_material_count()):
			var mat = mesh_inst.get_surface_override_material(surface_idx)
			if not mat:
				# Try the mesh resource's own material
				var mesh_res = mesh_inst.mesh
				if mesh_res and surface_idx < mesh_res.get_surface_count():
					mat = mesh_res.surface_get_material(surface_idx)

			if mat and mat is StandardMaterial3D:
				# Duplicate so we don't modify shared resources
				var mat_copy = mat.duplicate() as StandardMaterial3D
				if texture:
					mat_copy.albedo_texture = texture
				mesh_inst.set_surface_override_material(surface_idx, mat_copy)


## Recursively find the first node of a given type name in the scene tree
func _find_node_by_type(root: Node, type_name: String) -> Node:
	if root.get_class() == type_name:
		return root
	for child in root.get_children():
		var found = _find_node_by_type(child, type_name)
		if found:
			return found
	return null


## Recursively collect all MeshInstance3D nodes under a root
func _collect_mesh_instances(root: Node, result: Array[MeshInstance3D]) -> void:
	if root is MeshInstance3D:
		result.append(root as MeshInstance3D)
	for child in root.get_children():
		_collect_mesh_instances(child, result)
