## ThemeManager — swaps room materials, lighting, and cat model per theme
## Each theme is a dictionary of colors and settings.
## Call ThemeManager.apply_theme("gothic") to switch everything.
extends Node

signal theme_changed(theme_id: String)

var current_theme: String = "greco_roman"

# Theme definitions — colors are used to create materials at runtime
var themes: Dictionary = {
	"greco_roman": {
		"display_name": "Greco-Roman Classic",
		"floor_color": Color(0.92, 0.88, 0.82),
		"wall_color": Color(0.95, 0.92, 0.87),
		"ceiling_color": Color(0.93, 0.9, 0.86),
		"accent_color": Color(0.85, 0.72, 0.35),  # Gold
		"light_color": Color(1.0, 0.95, 0.85),
		"light_energy": 1.0,
		"ambient_color": Color(1.0, 0.97, 0.92),
		"ambient_energy": 0.5,
		"cat_model": "res://models/cats/cat_greco_roman.glb",
	},
	"modern_loft": {
		"display_name": "Modern Loft",
		"floor_color": Color(0.45, 0.45, 0.45),
		"wall_color": Color(0.3, 0.3, 0.32),
		"ceiling_color": Color(0.35, 0.35, 0.37),
		"accent_color": Color(0.2, 0.6, 1.0),  # Electric blue
		"light_color": Color(0.9, 0.92, 1.0),
		"light_energy": 1.0,
		"ambient_color": Color(0.9, 0.92, 1.0),
		"ambient_energy": 0.55,
		"cat_model": "res://models/cats/cat_modern_loft.glb",
	},
	"victorian": {
		"display_name": "Victorian Scholar",
		"floor_color": Color(0.35, 0.25, 0.15),
		"wall_color": Color(0.2, 0.35, 0.2),
		"ceiling_color": Color(0.4, 0.35, 0.28),
		"accent_color": Color(0.7, 0.55, 0.25),  # Brass
		"light_color": Color(1.0, 0.8, 0.5),
		"light_energy": 0.8,
		"ambient_color": Color(1.0, 0.92, 0.8),
		"ambient_energy": 0.25,
		"cat_model": "res://models/cats/cat_victorian.glb",
	},
	"scifi": {
		"display_name": "Sci-Fi Minimal",
		"floor_color": Color(0.95, 0.95, 0.97),
		"wall_color": Color(0.92, 0.92, 0.95),
		"ceiling_color": Color(0.93, 0.93, 0.96),
		"accent_color": Color(0.0, 0.9, 1.0),  # Cyan
		"light_color": Color(0.95, 0.97, 1.0),
		"light_energy": 1.2,
		"ambient_color": Color(0.95, 0.97, 1.0),
		"ambient_energy": 0.8,
		"cat_model": "res://models/cats/cat_scifi.glb",
	},
	"gothic": {
		"display_name": "Gothic Cathedral",
		"floor_color": Color(0.3, 0.28, 0.25),
		"wall_color": Color(0.4, 0.38, 0.35),
		"ceiling_color": Color(0.35, 0.32, 0.3),
		"accent_color": Color(0.5, 0.3, 0.6),  # Purple
		"light_color": Color(1.0, 0.75, 0.4),
		"light_energy": 0.6,
		"ambient_color": Color(0.3, 0.2, 0.4),
		"ambient_energy": 0.15,
		"cat_model": "res://models/cats/cat_gothic.glb",
	},
	"ryokan": {
		"display_name": "Japanese Ryokan",
		"floor_color": Color(0.72, 0.65, 0.45),
		"wall_color": Color(0.9, 0.87, 0.8),
		"ceiling_color": Color(0.85, 0.8, 0.72),
		"accent_color": Color(0.85, 0.5, 0.55),  # Cherry blossom
		"light_color": Color(1.0, 0.9, 0.7),
		"light_energy": 0.7,
		"ambient_color": Color(1.0, 0.95, 0.88),
		"ambient_energy": 0.45,
		"cat_model": "res://models/cats/cat_ryokan.glb",
	},
	"cottage": {
		"display_name": "Countryside Cottage",
		"floor_color": Color(0.6, 0.48, 0.32),
		"wall_color": Color(0.92, 0.88, 0.82),
		"ceiling_color": Color(0.85, 0.78, 0.65),
		"accent_color": Color(0.55, 0.7, 0.45),  # Sage green
		"light_color": Color(1.0, 0.85, 0.6),
		"light_energy": 0.9,
		"ambient_color": Color(1.0, 0.95, 0.9),
		"ambient_energy": 0.4,
		"cat_model": "res://models/cats/cat_cottage.glb",
	},
	"fallout": {
		"display_name": "Fallout Bunker",
		"floor_color": Color(0.35, 0.33, 0.3),
		"wall_color": Color(0.5, 0.4, 0.32),
		"ceiling_color": Color(0.38, 0.35, 0.3),
		"accent_color": Color(0.9, 0.65, 0.15),  # Warning orange
		"light_color": Color(0.8, 0.95, 0.75),
		"light_energy": 0.7,
		"ambient_color": Color(0.6, 0.7, 0.55),
		"ambient_energy": 0.2,
		"cat_model": "res://models/cats/cat_fallout.glb",
	},
}


func _ready() -> void:
	var saved := DatabaseBridge.get_setting("theme")
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

	# Apply to current room if one is loaded
	_apply_to_scene_tree()

	# Switch music
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


## Apply current theme to all CSG materials and lights in the scene tree
func _apply_to_scene_tree() -> void:
	var theme_data := get_theme()

	# Find all CSGBox3D nodes and update materials
	var csg_nodes := get_tree().get_nodes_in_group("themed_geometry")
	if csg_nodes.is_empty():
		# Fallback: find CSG nodes by type in the rooms container
		_apply_to_node(get_tree().root, theme_data)
		return

	for node in csg_nodes:
		_apply_material_to_csg(node, theme_data)

	# Update lights
	for light in get_tree().get_nodes_in_group("themed_lights"):
		if light is Light3D:
			light.light_color = theme_data["light_color"]
			light.light_energy = theme_data["light_energy"]

	# Update environment
	var env_node := get_tree().get_first_node_in_group("room_environment")
	if env_node and env_node is WorldEnvironment and env_node.environment:
		env_node.environment.ambient_light_color = theme_data["ambient_color"]
		env_node.environment.ambient_light_energy = theme_data["ambient_energy"]


## Walk the tree and apply theme to CSG + light nodes
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


func _apply_material_to_csg(node: CSGBox3D, theme_data: Dictionary) -> void:
	if not node.material or not node.material is StandardMaterial3D:
		return

	var mat: StandardMaterial3D = node.material
	var node_name: String = node.name.to_lower()

	# Determine which color based on the node name
	if "floor" in node_name or "ground" in node_name or "path" in node_name:
		mat.albedo_color = theme_data["floor_color"]
	elif "ceiling" in node_name:
		mat.albedo_color = theme_data["ceiling_color"]
	elif "wall" in node_name:
		mat.albedo_color = theme_data["wall_color"]
	elif "trim" in node_name or "gold" in node_name:
		mat.albedo_color = theme_data["accent_color"]
