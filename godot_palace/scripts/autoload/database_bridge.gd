## Bridge to shared SQLite database
## Reads/writes the same mindhause.sqlite that Flutter uses
## Uses godot-sqlite plugin (GDExtension)
extends Node

# Path to the shared database file
var db_path: String = ""
var db: SQLite = null


func _ready() -> void:
	# On Android/iOS the database lives in the app's documents directory
	# Flutter and Godot share this path
	if OS.has_feature("android"):
		db_path = OS.get_data_dir() + "/mindhause.sqlite"
	elif OS.has_feature("ios"):
		db_path = OS.get_data_dir() + "/mindhause.sqlite"
	else:
		# Desktop fallback for development
		db_path = "user://mindhause.sqlite"

	db = SQLite.new()
	db.path = db_path
	db.open_db()
	print("[DatabaseBridge] Opened database at: ", db_path)


# --- Settings ---

func get_setting(key: String) -> String:
	db.query_with_bindings("SELECT value FROM settings WHERE key = ?", [key])
	if db.query_result.size() > 0:
		return str(db.query_result[0]["value"])
	return ""


func set_setting(key: String, value: String) -> void:
	db.query_with_bindings(
		"INSERT OR REPLACE INTO settings (key, value) VALUES (?, ?)",
		[key, value]
	)


# --- Tasks / Items ---

func get_tasks_for_room(room_id: String) -> Array[Dictionary]:
	db.query_with_bindings(
		"SELECT * FROM items WHERE room = ? AND status != 'archived' ORDER BY priority DESC, due_date ASC",
		[room_id]
	)
	var result: Array[Dictionary] = []
	for row in db.query_result:
		result.append(row)
	return result


func get_task_by_id(task_id: String) -> Dictionary:
	db.query_with_bindings("SELECT * FROM items WHERE id = ?", [task_id])
	if db.query_result.size() > 0:
		return db.query_result[0]
	return {}


func update_task_interaction(task_id: String) -> void:
	var now := Time.get_unix_time_from_system()
	db.query_with_bindings(
		"UPDATE items SET last_interaction = ?, updated_at = ? WHERE id = ?",
		[now, now, task_id]
	)


func update_task_position(task_id: String, pos: Vector3) -> void:
	db.query_with_bindings(
		"UPDATE items SET position_x = ?, position_y = ?, position_z = ? WHERE id = ?",
		[pos.x, pos.y, pos.z, task_id]
	)


func update_monster_state(task_id: String, state: String) -> void:
	var now := Time.get_unix_time_from_system()
	db.query_with_bindings(
		"UPDATE items SET monster_state = ?, monster_evolved_at = ?, updated_at = ? WHERE id = ?",
		[state, now, now, task_id]
	)


func complete_task(task_id: String) -> void:
	var now := Time.get_unix_time_from_system()
	db.query_with_bindings(
		"UPDATE items SET status = 'done', completed_at = ?, updated_at = ?, monster_state = 'none' WHERE id = ?",
		[now, now, task_id]
	)


func create_task(title: String, room_id: String, object_type: String, pos: Vector3) -> String:
	var id := _generate_uuid()
	var now := Time.get_unix_time_from_system()
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
	db.query("SELECT * FROM rooms ORDER BY sort_order ASC")
	var result: Array[Dictionary] = []
	for row in db.query_result:
		result.append(row)
	return result


# --- Monster queries ---

func get_monster_tasks() -> Array[Dictionary]:
	db.query("SELECT * FROM items WHERE monster_state != 'none' AND status != 'done' AND status != 'archived'")
	var result: Array[Dictionary] = []
	for row in db.query_result:
		result.append(row)
	return result


func get_neglectable_tasks() -> Array[Dictionary]:
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
	var bytes := PackedByteArray()
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
