## Global game state — singleton autoload
## Tracks current room, player status, settings, and palace-wide data
extends Node

signal room_changed(from_room: String, to_room: String)
signal task_interacted(task_id: String)
signal monster_spawned(task_id: String, room_id: String)
signal cat_alert(message: String)
signal settings_changed(key: String, value: String)
signal task_placed(room_name: String, surface_name: String, slot_number: int)
signal morning_walk_requested()

# Current state
var current_room: String = "foyer"
var previous_room: String = ""
var player_position: Vector3 = Vector3.ZERO
var door_cooldown: float = 0.0

# Settings (synced from SQLite)
var monsters_enabled: bool = true
var monster_chasing: bool = true
var monster_sensitivity: String = "normal"  # gentle, normal, strict
var cat_enabled: bool = true
var focus_duration: int = 25

# Active data caches (populated from DB)
var tasks_in_room: Array[Dictionary] = []
var all_rooms: Array[Dictionary] = []
var active_monsters: Array[Dictionary] = []

# Monster evolution thresholds (in hours)
var monster_thresholds: Dictionary = {
	"gentle": { "neglected": 168, "corrupting": 336, "monster": 672 },
	"normal": { "neglected": 72, "corrupting": 168, "monster": 336 },
	"strict": { "neglected": 24, "corrupting": 72, "monster": 168 },
}


func _ready() -> void:
	_load_settings()


func _process(delta: float) -> void:
	if door_cooldown > 0.0:
		door_cooldown -= delta


func _load_settings() -> void:
	var db = DatabaseBridge
	monsters_enabled = db.get_setting("monsters_enabled") == "true"
	monster_chasing = db.get_setting("monster_chasing") == "true"
	monster_sensitivity = db.get_setting("monster_sensitivity")
	cat_enabled = db.get_setting("cat_enabled") == "true"
	focus_duration = int(db.get_setting("focus_duration"))


func change_room(new_room: String) -> void:
	previous_room = current_room
	current_room = new_room
	_refresh_room_tasks()
	room_changed.emit(previous_room, new_room)


func _refresh_room_tasks() -> void:
	tasks_in_room = DatabaseBridge.get_tasks_for_room(current_room)


func get_monster_threshold(stage: String) -> int:
	var thresholds: Dictionary = monster_thresholds.get(monster_sensitivity, monster_thresholds["normal"])
	return thresholds.get(stage, 72)


func update_setting(key: String, value: String) -> void:
	DatabaseBridge.set_setting(key, value)
	_load_settings()
	settings_changed.emit(key, value)
