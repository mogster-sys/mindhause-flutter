## Bridge to shared SQLite database
## Reads/writes the same mindhause.sqlite that Flutter uses
## Uses godot-sqlite plugin (GDExtension) when available,
## falls back to in-memory Dictionary for development without the plugin.
extends Node

# Path to the shared database file
var db_path: String = ""
var db = null  # SQLite instance when plugin is available, null otherwise
var _use_memory: bool = false
var _initialized: bool = false
var _memory_settings: Dictionary = {}
var _memory_items: Array[Dictionary] = []
var _memory_rooms: Array[Dictionary] = []


func _ready() -> void:
	_ensure_initialized()


func _ensure_initialized() -> void:
	if _initialized:
		return
	_initialized = true
	# On Android/iOS the database lives in the app's documents directory
	# Flutter and Godot share this path
	if OS.has_feature("android"):
		db_path = OS.get_data_dir() + "/mindhause.sqlite"
	elif OS.has_feature("ios"):
		db_path = OS.get_data_dir() + "/mindhause.sqlite"
	else:
		# Desktop fallback for development
		db_path = "user://mindhause.sqlite"

	# Try to use SQLite plugin if available
	if ClassDB.class_exists("SQLite"):
		db = ClassDB.instantiate("SQLite")
		db.path = db_path
		db.open_db()
		_use_memory = false
		print("[DatabaseBridge] Opened SQLite database at: ", db_path)
	else:
		_use_memory = true
		_init_memory_store()
		print("[DatabaseBridge] SQLite plugin not found — using in-memory fallback")


func _init_memory_store() -> void:
	# Seed with default settings
	_memory_settings = {
		"theme": "greco_roman",
		"monsters_enabled": "true",
		"monster_chasing": "true",
		"monster_sensitivity": "normal",
		"cat_enabled": "true",
		"focus_duration": "25",
		"painterly_enabled": "true",
		"painterly_strength": "0.85",
	}
	# Seed default rooms
	_memory_rooms = [
		{"id": "foyer", "name": "Foyer", "sort_order": 0},
		{"id": "study", "name": "Study", "sort_order": 1},
		{"id": "library", "name": "Library", "sort_order": 2},
		{"id": "kitchen", "name": "Kitchen", "sort_order": 3},
		{"id": "workshop", "name": "Workshop", "sort_order": 4},
		{"id": "garden", "name": "Garden", "sort_order": 5},
		{"id": "bedroom", "name": "Bedroom", "sort_order": 6},
		{"id": "gymnasium", "name": "Gymnasium", "sort_order": 7},
		{"id": "treasury", "name": "Treasury", "sort_order": 8},
		{"id": "cellar", "name": "Cellar", "sort_order": 9},
	]
	_memory_items = []


# --- Settings ---

func get_setting(key: String) -> String:
	_ensure_initialized()
	if _use_memory:
		return _memory_settings.get(key, "")
	db.query_with_bindings("SELECT value FROM settings WHERE key = ?", [key])
	if db.query_result.size() > 0:
		return str(db.query_result[0]["value"])
	return ""


func set_setting(key: String, value: String) -> void:
	_ensure_initialized()
	if _use_memory:
		_memory_settings[key] = value
		return
	db.query_with_bindings(
		"INSERT OR REPLACE INTO settings (key, value) VALUES (?, ?)",
		[key, value]
	)


# --- Tasks / Items ---

func get_tasks_for_room(room_id: String) -> Array[Dictionary]:
	_ensure_initialized()
	if _use_memory:
		var result: Array[Dictionary] = []
		for item in _memory_items:
			if item.get("room", "") == room_id and item.get("status", "") != "archived":
				result.append(item)
		return result
	db.query_with_bindings(
		"SELECT * FROM items WHERE room = ? AND status != 'archived' ORDER BY priority DESC, due_date ASC",
		[room_id]
	)
	var result: Array[Dictionary] = []
	for row in db.query_result:
		result.append(row)
	return result


func get_task_by_id(task_id: String) -> Dictionary:
	_ensure_initialized()
	if _use_memory:
		for item in _memory_items:
			if item.get("id", "") == task_id:
				return item
		return {}
	db.query_with_bindings("SELECT * FROM items WHERE id = ?", [task_id])
	if db.query_result.size() > 0:
		return db.query_result[0]
	return {}


func update_task_interaction(task_id: String) -> void:
	_ensure_initialized()
	var now = Time.get_unix_time_from_system()
	if _use_memory:
		for item in _memory_items:
			if item.get("id", "") == task_id:
				item["last_interaction"] = now
				item["updated_at"] = now
		return
	db.query_with_bindings(
		"UPDATE items SET last_interaction = ?, updated_at = ? WHERE id = ?",
		[now, now, task_id]
	)


func update_task_position(task_id: String, pos: Vector3) -> void:
	_ensure_initialized()
	if _use_memory:
		for item in _memory_items:
			if item.get("id", "") == task_id:
				item["position_x"] = pos.x
				item["position_y"] = pos.y
				item["position_z"] = pos.z
		return
	db.query_with_bindings(
		"UPDATE items SET position_x = ?, position_y = ?, position_z = ? WHERE id = ?",
		[pos.x, pos.y, pos.z, task_id]
	)


func update_monster_state(task_id: String, state: String) -> void:
	_ensure_initialized()
	var now = Time.get_unix_time_from_system()
	if _use_memory:
		for item in _memory_items:
			if item.get("id", "") == task_id:
				item["monster_state"] = state
				item["monster_evolved_at"] = now
				item["updated_at"] = now
		return
	db.query_with_bindings(
		"UPDATE items SET monster_state = ?, monster_evolved_at = ?, updated_at = ? WHERE id = ?",
		[state, now, now, task_id]
	)


func complete_task(task_id: String) -> void:
	_ensure_initialized()
	var now = Time.get_unix_time_from_system()
	if _use_memory:
		for item in _memory_items:
			if item.get("id", "") == task_id:
				item["status"] = "done"
				item["completed_at"] = now
				item["updated_at"] = now
				item["monster_state"] = "none"
		return
	db.query_with_bindings(
		"UPDATE items SET status = 'done', completed_at = ?, updated_at = ?, monster_state = 'none' WHERE id = ?",
		[now, now, task_id]
	)


func create_task(title: String, room_id: String, object_type: String, pos: Vector3) -> String:
	_ensure_initialized()
	var id = _generate_uuid()
	var now = Time.get_unix_time_from_system()
	if _use_memory:
		_memory_items.append({
			"id": id, "title": title, "description": "", "type": "task",
			"priority": "normal", "status": "todo",
			"created_at": now, "updated_at": now, "last_interaction": now,
			"room": room_id, "object_type": object_type,
			"position_x": pos.x, "position_y": pos.y, "position_z": pos.z,
			"monster_state": "none", "notes": "",
		})
		return id
	db.query_with_bindings(
		"""INSERT INTO items (id, title, description, type, priority, status,
		   created_at, updated_at, last_interaction, room, object_type,
		   position_x, position_y, position_z, monster_state, notes)
		   VALUES (?, ?, '', 'task', 'normal', 'todo', ?, ?, ?, ?, ?, ?, ?, ?, 'none', '')""",
		[id, title, now, now, now, room_id, object_type, pos.x, pos.y, pos.z]
	)
	return id


# --- Rooms ---

func get_all_rooms() -> Array[Dictionary]:
	_ensure_initialized()
	if _use_memory:
		return _memory_rooms.duplicate()
	db.query("SELECT * FROM rooms ORDER BY sort_order ASC")
	var result: Array[Dictionary] = []
	for row in db.query_result:
		result.append(row)
	return result


func get_all_active_tasks() -> Array[Dictionary]:
	_ensure_initialized()
	if _use_memory:
		var result: Array[Dictionary] = []
		for item in _memory_items:
			if item.get("status", "") != "done" and item.get("status", "") != "archived":
				result.append(item)
		return result
	db.query("SELECT * FROM items WHERE status NOT IN ('done', 'archived') ORDER BY room ASC")
	var result: Array[Dictionary] = []
	for row in db.query_result:
		result.append(row)
	return result


# --- Monster queries ---

func get_monster_tasks() -> Array[Dictionary]:
	_ensure_initialized()
	if _use_memory:
		var result: Array[Dictionary] = []
		for item in _memory_items:
			if item.get("monster_state", "none") != "none" and item.get("status", "") != "done" and item.get("status", "") != "archived":
				result.append(item)
		return result
	db.query("SELECT * FROM items WHERE monster_state != 'none' AND status != 'done' AND status != 'archived'")
	var result: Array[Dictionary] = []
	for row in db.query_result:
		result.append(row)
	return result


func get_neglectable_tasks() -> Array[Dictionary]:
	_ensure_initialized()
	if _use_memory:
		var result: Array[Dictionary] = []
		for item in _memory_items:
			if item.get("type", "") == "task" and item.get("status", "") != "done" and item.get("status", "") != "archived" and item.get("monster_state", "none") == "none":
				result.append(item)
		return result
	# Tasks that haven't been interacted with recently
	db.query(
		"SELECT * FROM items WHERE type = 'task' AND status NOT IN ('done', 'archived') AND monster_state = 'none'"
	)
	var result: Array[Dictionary] = []
	for row in db.query_result:
		result.append(row)
	return result


# --- Utility ---

func _generate_uuid() -> String:
	var bytes = PackedByteArray()
	for i in range(16):
		bytes.append(randi() % 256)
	# Set version 4 and variant bits
	bytes[6] = (bytes[6] & 0x0f) | 0x40
	bytes[8] = (bytes[8] & 0x3f) | 0x80
	return "%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02x%02x%02x%02x" % [
		bytes[0], bytes[1], bytes[2], bytes[3],
		bytes[4], bytes[5], bytes[6], bytes[7],
		bytes[8], bytes[9], bytes[10], bytes[11],
		bytes[12], bytes[13], bytes[14], bytes[15],
	]
