## RoomManager — handles room loading, task object spawning, and transitions
## Attached to the main house scene
extends Node3D

@export var player_path: NodePath
@export var rooms_container_path: NodePath

@onready var player: CharacterBody3D = get_node(player_path)
@onready var rooms_container: Node3D = get_node(rooms_container_path)

# Preload task object scene
var task_object_scene: PackedScene = preload("res://scenes/objects/task_object.tscn")

# Room scene paths
var room_scenes: Dictionary = {
	"foyer": "res://scenes/rooms/foyer.tscn",
	"study": "res://scenes/rooms/study.tscn",
	"library": "res://scenes/rooms/library.tscn",
	"kitchen": "res://scenes/rooms/kitchen.tscn",
	"workshop": "res://scenes/rooms/workshop.tscn",
	"garden": "res://scenes/rooms/garden.tscn",
	"bedroom": "res://scenes/rooms/bedroom.tscn",
	"gymnasium": "res://scenes/rooms/gymnasium.tscn",
	"treasury": "res://scenes/rooms/treasury.tscn",
	"cellar": "res://scenes/rooms/cellar.tscn",
}

var current_room_node: Node3D = null
var _transition_tween: Tween = null


func _ready() -> void:
	GameState.room_changed.connect(_on_room_changed)
	# Load rooms data
	GameState.all_rooms = DatabaseBridge.get_all_rooms()
	# Load initial room
	_load_room(GameState.current_room)
	# Start ambient music for the active theme
	AudioManager.play_music(ThemeManager.current_theme)


func _on_room_changed(from_room: String, to_room: String) -> void:
	_transition_to_room(to_room)


func _transition_to_room(room_id: String) -> void:
	# Fade out
	if _transition_tween:
		_transition_tween.kill()
	_transition_tween = create_tween()

	# Fade screen to black (via HUD overlay)
	var fade_overlay = _get_fade_overlay()
	if fade_overlay:
		_transition_tween.tween_property(fade_overlay, "modulate:a", 1.0, 0.3)

	_transition_tween.tween_callback(func():
		_unload_current_room()
		_load_room(room_id)
	)

	# Fade in
	if fade_overlay:
		_transition_tween.tween_property(fade_overlay, "modulate:a", 0.0, 0.4)


func _load_room(room_id: String) -> void:
	if not room_scenes.has(room_id):
		push_warning("No scene for room: " + room_id)
		return

	var scene_path: String = room_scenes[room_id]
	var scene = load(scene_path) as PackedScene
	if not scene:
		push_error("Failed to load room scene: " + scene_path)
		return

	current_room_node = scene.instantiate()
	rooms_container.add_child(current_room_node)

	# Position player at room spawn point
	var spawn = current_room_node.get_node_or_null("SpawnPoint")
	if spawn:
		player.global_position = spawn.global_position
		player.rotation.y = spawn.rotation.y

	# Wire surface placement signals to GameState
	_connect_surfaces()

	# Spawn task objects for this room
	_spawn_task_objects(room_id)

	# Bake navigation mesh for cat pathfinding
	_bake_nav_mesh()

	# Reposition cat to nearest cat_spot
	_reposition_cat()

	# Apply time-of-day lighting
	_apply_lighting()

	# Apply current theme textures and colors
	ThemeManager.refresh_room()


func _unload_current_room() -> void:
	if current_room_node:
		current_room_node.queue_free()
		current_room_node = null


func _connect_surfaces() -> void:
	if not current_room_node:
		return
	var room_display: String = GameState.current_room.capitalize()
	for room in GameState.all_rooms:
		if room.get("id", "") == GameState.current_room:
			room_display = room.get("display_name", room_display)
			break
	for child in current_room_node.get_children():
		if child.is_in_group("surfaces") and child.has_signal("object_placed"):
			child.object_placed.connect(
				func(sname: String, slot: int):
					GameState.task_placed.emit(room_display, sname, slot)
			)


func _spawn_task_objects(room_id: String) -> void:
	var tasks = DatabaseBridge.get_tasks_for_room(room_id)

	for task in tasks:
		var obj: RigidBody3D = task_object_scene.instantiate()
		obj.task_id = task.get("id", "")
		obj.object_type = task.get("object_type", "scroll")

		# Position from database or find next available surface slot
		var pos_x: float = task.get("position_x", 0.0)
		var pos_y: float = task.get("position_y", 0.5)
		var pos_z: float = task.get("position_z", 0.0)

		if pos_x == 0.0 and pos_z == 0.0:
			# No saved position — find a surface slot
			var surface_pos = _find_surface_slot(room_id)
			pos_x = surface_pos.x
			pos_y = surface_pos.y
			pos_z = surface_pos.z

		obj.global_position = Vector3(pos_x, pos_y, pos_z)
		rooms_container.add_child(obj)


func _find_surface_slot(room_id: String) -> Vector3:
	# Find surfaces in the current room and pick an available slot
	if current_room_node:
		var surfaces = current_room_node.get_children().filter(
			func(n): return n.is_in_group("surfaces")
		)
		if surfaces.size() > 0:
			var surface: Node3D = surfaces[randi() % surfaces.size()]
			var offset = Vector3(randf_range(-0.3, 0.3), 0.05, randf_range(-0.3, 0.3))
			return surface.global_position + offset
	# Fallback: random position near centre
	return Vector3(randf_range(-2, 2), 0.8, randf_range(-2, 2))


func _bake_nav_mesh() -> void:
	if not current_room_node:
		return
	var nav_region = current_room_node.get_node_or_null("NavigationRegion3D")
	if nav_region and nav_region is NavigationRegion3D and nav_region.navigation_mesh:
		nav_region.bake_navigation_mesh()


func _reposition_cat() -> void:
	var cat = get_tree().get_first_node_in_group("cat")
	if not cat or not current_room_node:
		return

	# Find cat_spots in this room and pick the one nearest to spawn
	var spots = current_room_node.get_children().filter(
		func(n): return n.is_in_group("cat_spots")
	)
	if spots.size() == 0:
		# Fallback: place cat near spawn with offset
		var spawn = current_room_node.get_node_or_null("SpawnPoint")
		if spawn:
			cat.global_position = spawn.global_position + Vector3(1.5, 0, 1)
		return

	# Pick a random spot (not the one closest to the player spawn — more natural)
	var chosen: Marker3D = spots[randi() % spots.size()]
	cat.global_position = chosen.global_position

	# Wire up player ref if not already
	if cat.has_method("set_player") and player:
		cat.set_player(player)


func _apply_lighting() -> void:
	var lighting = TimeOfDay.get_current_lighting()
	# Find environment and directional light in room
	var env = current_room_node.get_node_or_null("WorldEnvironment") if current_room_node else null
	var sun = current_room_node.get_node_or_null("DirectionalLight3D") if current_room_node else null

	if env and env is WorldEnvironment and env.environment:
		env.environment.ambient_light_color = lighting.get("ambient_color", Color.WHITE)
		env.environment.ambient_light_energy = lighting.get("ambient_energy", 0.5)

	if sun and sun is DirectionalLight3D:
		sun.light_color = lighting.get("sun_color", Color.WHITE)
		sun.light_energy = lighting.get("sun_energy", 0.8)


func _get_fade_overlay() -> CanvasItem:
	# Look for FadeOverlay in the HUD
	var hud = get_tree().get_first_node_in_group("hud")
	if hud:
		return hud.get_node_or_null("FadeOverlay")
	return null
