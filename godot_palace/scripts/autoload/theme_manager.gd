## ThemeManager — swaps room materials, lighting, and cat model per theme
## Each theme is a dictionary of colors, textures, and settings.
## Call ThemeManager.apply_theme("gothic") to switch everything.
extends Node

signal theme_changed(theme_id: String)

var current_theme: String = "greco_roman"
var _texture_cache: Dictionary = {}

# Theme definitions — colors as fallback, textures applied when available
var themes: Dictionary = {
	"greco_roman": {
		"display_name": "Greco-Roman Classic",
		"floor_color": Color(0.92, 0.88, 0.82),
		"wall_color": Color(0.95, 0.92, 0.87),
		"ceiling_color": Color(0.93, 0.9, 0.86),
		"accent_color": Color(0.85, 0.72, 0.35),
		"light_color": Color(1.0, 0.95, 0.85),
		"light_energy": 1.0,
		"ambient_color": Color(1.0, 0.97, 0.92),
		"ambient_energy": 0.5,
		"cat_model": "res://models/cats/cat_greco_roman.glb",
		"floor_texture": "res://textures/greco_roman/marble_floor.png",
		"wall_texture": "res://textures/greco_roman/wall_panels.png",
		"ceiling_texture": "res://textures/greco_roman/parchment.png",
		"accent_texture": "res://textures/greco_roman/wall_trim.png",
	},
	"modern_loft": {
		"display_name": "Modern Loft",
		"floor_color": Color(0.45, 0.45, 0.45),
		"wall_color": Color(0.3, 0.3, 0.32),
		"ceiling_color": Color(0.35, 0.35, 0.37),
		"accent_color": Color(0.2, 0.6, 1.0),
		"light_color": Color(0.9, 0.92, 1.0),
		"light_energy": 1.0,
		"ambient_color": Color(0.9, 0.92, 1.0),
		"ambient_energy": 0.55,
		"cat_model": "res://models/cats/cat_modern_loft.glb",
		"floor_texture": "res://textures/modern_loft/concrete_floor.png",
		"wall_texture": "res://textures/modern_loft/smooth_wall.png",
		"ceiling_texture": "res://textures/modern_loft/smooth_wall.png",
		"accent_texture": "res://textures/modern_loft/brushed_metal.png",
	},
	"victorian": {
		"display_name": "Victorian Scholar",
		"floor_color": Color(0.35, 0.25, 0.15),
		"wall_color": Color(0.2, 0.35, 0.2),
		"ceiling_color": Color(0.4, 0.35, 0.28),
		"accent_color": Color(0.7, 0.55, 0.25),
		"light_color": Color(1.0, 0.8, 0.5),
		"light_energy": 0.8,
		"ambient_color": Color(1.0, 0.92, 0.8),
		"ambient_energy": 0.25,
		"cat_model": "res://models/cats/cat_victorian.glb",
		"floor_texture": "res://textures/victorian/dark_wood.png",
		"wall_texture": "res://textures/victorian/damask_wallpaper.png",
		"ceiling_texture": "res://textures/victorian/aged_surface.png",
		"accent_texture": "res://textures/victorian/leather.png",
	},
	"scifi": {
		"display_name": "Sci-Fi Minimal",
		"floor_color": Color(0.95, 0.95, 0.97),
		"wall_color": Color(0.92, 0.92, 0.95),
		"ceiling_color": Color(0.93, 0.93, 0.96),
		"accent_color": Color(0.0, 0.9, 1.0),
		"light_color": Color(0.95, 0.97, 1.0),
		"light_energy": 1.2,
		"ambient_color": Color(0.95, 0.97, 1.0),
		"ambient_energy": 0.8,
		"cat_model": "res://models/cats/cat_scifi.glb",
		"floor_texture": "res://textures/scifi/hex_floor.png",
		"wall_texture": "res://textures/scifi/panel_wall.png",
		"ceiling_texture": "res://textures/scifi/panel_wall.png",
		"accent_texture": "res://textures/scifi/holographic.png",
	},
	"gothic": {
		"display_name": "Gothic Cathedral",
		"floor_color": Color(0.3, 0.28, 0.25),
		"wall_color": Color(0.4, 0.38, 0.35),
		"ceiling_color": Color(0.35, 0.32, 0.3),
		"accent_color": Color(0.5, 0.3, 0.6),
		"light_color": Color(1.0, 0.75, 0.4),
		"light_energy": 0.6,
		"ambient_color": Color(0.3, 0.2, 0.4),
		"ambient_energy": 0.15,
		"cat_model": "res://models/cats/cat_gothic.glb",
		"floor_texture": "res://textures/gothic/stone_floor.png",
		"wall_texture": "res://textures/gothic/dark_brick.png",
		"ceiling_texture": "res://textures/gothic/dark_brick.png",
		"accent_texture": "res://textures/gothic/purple_damask.png",
	},
	"ryokan": {
		"display_name": "Japanese Ryokan",
		"floor_color": Color(0.72, 0.65, 0.45),
		"wall_color": Color(0.9, 0.87, 0.8),
		"ceiling_color": Color(0.85, 0.8, 0.72),
		"accent_color": Color(0.85, 0.5, 0.55),
		"light_color": Color(1.0, 0.9, 0.7),
		"light_energy": 0.7,
		"ambient_color": Color(1.0, 0.95, 0.88),
		"ambient_energy": 0.45,
		"cat_model": "res://models/cats/cat_ryokan.glb",
		"floor_texture": "res://textures/ryokan/tatami.png",
		"wall_texture": "res://textures/ryokan/shoji_screen.png",
		"ceiling_texture": "res://textures/ryokan/warm_wood.png",
		"accent_texture": "res://textures/ryokan/cherry_blossom.png",
	},
	"cottage": {
		"display_name": "Countryside Cottage",
		"floor_color": Color(0.6, 0.48, 0.32),
		"wall_color": Color(0.92, 0.88, 0.82),
		"ceiling_color": Color(0.85, 0.78, 0.65),
		"accent_color": Color(0.55, 0.7, 0.45),
		"light_color": Color(1.0, 0.85, 0.6),
		"light_energy": 0.9,
		"ambient_color": Color(1.0, 0.95, 0.9),
		"ambient_energy": 0.4,
		"cat_model": "res://models/cats/cat_cottage.glb",
		"floor_texture": "res://textures/cottage/wood_planks.png",
		"wall_texture": "res://textures/cottage/plaster_wall.png",
		"ceiling_texture": "res://textures/cottage/plaster_wall.png",
		"accent_texture": "res://textures/cottage/timber_frame.png",
	},
	"fallout": {
		"display_name": "Fallout Bunker",
		"floor_color": Color(0.35, 0.33, 0.3),
		"wall_color": Color(0.5, 0.4, 0.32),
		"ceiling_color": Color(0.38, 0.35, 0.3),
		"accent_color": Color(0.9, 0.65, 0.15),
		"light_color": Color(0.8, 0.95, 0.75),
		"light_energy": 0.7,
		"ambient_color": Color(0.6, 0.7, 0.55),
		"ambient_energy": 0.2,
		"cat_model": "res://models/cats/cat_fallout.glb",
		"floor_texture": "res://textures/fallout/cracked_concrete.png",
		"wall_texture": "res://textures/fallout/dirty_wall.png",
		"ceiling_texture": "res://textures/fallout/riveted_steel.png",
		"accent_texture": "res://textures/fallout/rust_patina.png",
	},
}


func _ready() -> void:
	var saved = DatabaseBridge.get_setting("theme")
	if saved != "" and themes.has(saved):
		current_theme = saved


## Switch to a new theme. Applies to current room immediately.
func apply_theme(theme_id: String) -> void:
	if not themes.has(theme_id):
		push_warning("ThemeManager: Unknown theme: " + theme_id)
		return

	current_theme = theme_id
	DatabaseBridge.set_setting("theme", theme_id)
	theme_changed.emit(theme_id)

	_apply_to_scene_tree()
	AudioManager.play_music(theme_id)


## Get the active theme data
func get_theme() -> Dictionary:
	return themes[current_theme]


## Get a specific theme's data
func get_theme_data(theme_id: String) -> Dictionary:
	return themes.get(theme_id, themes["greco_roman"])


## Get list of all available theme IDs
func get_available_themes() -> Array[String]:
	var result: Array[String] = []
	for key in themes.keys():
		result.append(key)
	return result


## Public entry point — apply current theme to the loaded room
func refresh_room() -> void:
	_apply_to_scene_tree()


## Apply current theme to all CSG materials and lights in the scene tree
func _apply_to_scene_tree() -> void:
	var theme_data = get_theme()

	var csg_nodes = get_tree().get_nodes_in_group("themed_geometry")
	if csg_nodes.size() == 0:
		# Fallback: walk the tree if no groups assigned
		_apply_to_node(get_tree().root, theme_data)
		return

	for node in csg_nodes:
		_apply_material_to_csg(node, theme_data)

	for light in get_tree().get_nodes_in_group("themed_lights"):
		if light is Light3D:
			light.light_color = theme_data["light_color"]
			light.light_energy = theme_data["light_energy"]

	var env_node = get_tree().get_first_node_in_group("room_environment")
	if env_node and env_node is WorldEnvironment and env_node.environment:
		env_node.environment.ambient_light_color = theme_data["ambient_color"]
		env_node.environment.ambient_light_energy = theme_data["ambient_energy"]


## Walk the tree and apply theme to CSG + light nodes (fallback path)
func _apply_to_node(node: Node, theme_data: Dictionary) -> void:
	if node is CSGBox3D and node.material:
		_apply_material_to_csg(node, theme_data)
	elif node is OmniLight3D or node is SpotLight3D:
		node.light_color = theme_data["light_color"]
	elif node is DirectionalLight3D:
		node.light_color = theme_data["light_color"]
	elif node is WorldEnvironment and node.environment:
		node.environment.ambient_light_color = theme_data["ambient_color"]
		node.environment.ambient_light_energy = theme_data["ambient_energy"]

	for child in node.get_children():
		_apply_to_node(child, theme_data)


## Apply texture + color to a CSG node based on its name
func _apply_material_to_csg(node: CSGBox3D, theme_data: Dictionary) -> void:
	if not node.material or not node.material is StandardMaterial3D:
		return

	var mat: StandardMaterial3D = node.material
	var node_name: String = node.name.to_lower()

	# Determine surface category from node name
	var color_key: String = "accent_color"
	var texture_key: String = "accent_texture"

	if "floor" in node_name or "ground" in node_name or "path" in node_name:
		color_key = "floor_color"
		texture_key = "floor_texture"
	elif "ceiling" in node_name:
		color_key = "ceiling_color"
		texture_key = "ceiling_texture"
	elif "wall" in node_name:
		color_key = "wall_color"
		texture_key = "wall_texture"
	elif "trim" in node_name or "gold" in node_name:
		color_key = "accent_color"
		texture_key = "accent_texture"

	# Try to apply texture first
	if theme_data.has(texture_key):
		var tex = _load_texture(theme_data[texture_key])
		if tex:
			mat.albedo_texture = tex
			mat.albedo_color = Color.WHITE  # Don't tint the texture
			mat.uv1_triplanar = true
			mat.uv1_scale = Vector3(0.5, 0.5, 0.5)  # 1 tile per 2m
			mat.metallic = 0.0
			return

	# Fallback to flat color
	mat.albedo_texture = null
	mat.uv1_triplanar = false
	if theme_data.has(color_key):
		mat.albedo_color = theme_data[color_key]


## Load and cache a texture from disk
func _load_texture(path: String) -> Texture2D:
	if _texture_cache.has(path):
		return _texture_cache[path]
	if not ResourceLoader.exists(path):
		return null
	var tex = load(path) as Texture2D
	if tex:
		_texture_cache[path] = tex
	return tex
