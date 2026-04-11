## CatMemory — tracks favourite rooms, perch preferences, and session persistence
## Feeds back to CatBrain for decision-making, saved between sessions via DatabaseBridge
extends Node

# Room visit counts (room_id -> visit_count)
var room_visits: Dictionary = {}

# Perch use counts (perch_name -> use_count)
var perch_visits: Dictionary = {}

# Player interaction tracking
var player_affinity: float = 0.5  # 0=avoidant, 1=clingy
var tasks_completed_nearby: int = 0

# Session stats
var favourite_room: String = ""
var favourite_perch: String = ""
var total_session_time: float = 0.0


func _ready() -> void:
	_load_from_db()


func _process(delta: float) -> void:
	total_session_time += delta


func record_room_visit(room_id: String) -> void:
	room_visits[room_id] = room_visits.get(room_id, 0) + 1
	_update_favourite_room()
	_save_to_db()


func record_perch_use(perch_name: String) -> void:
	perch_visits[perch_name] = perch_visits.get(perch_name, 0) + 1
	_update_favourite_perch()
	_save_to_db()


func record_task_completed() -> void:
	tasks_completed_nearby += 1
	# Increase affinity when tasks are completed near cat
	player_affinity = min(player_affinity + 0.02, 1.0)
	_save_to_db()


func record_player_approached() -> void:
	player_affinity = min(player_affinity + 0.005, 1.0)


func get_room_weight(room_id: String) -> float:
	## Returns a normalised preference weight for a room (0–1)
	if room_visits.size() == 0:
		return 0.5
	var max_visits: int = 1
	for v in room_visits.values():
		if v > max_visits:
			max_visits = v
	return float(room_visits.get(room_id, 0)) / float(max_visits)


func get_perch_weight(perch_name: String) -> float:
	## Returns a normalised preference weight for a perch (0–1)
	if perch_visits.size() == 0:
		return 0.5
	var max_visits: int = 1
	for v in perch_visits.values():
		if v > max_visits:
			max_visits = v
	return float(perch_visits.get(perch_name, 0)) / float(max_visits)


func get_preferred_perch(available_perches: Array) -> Node3D:
	## Pick a perch biased by visit history
	if available_perches.size() == 0:
		return null

	var weights: Array[float] = []
	var total_weight: float = 0.0
	for perch in available_perches:
		var w: float = 0.5 + get_perch_weight(perch.name) * 0.5
		weights.append(w)
		total_weight += w

	# Weighted random selection
	var roll = randf() * total_weight
	var cumulative: float = 0.0
	for i in range(available_perches.size()):
		cumulative += weights[i]
		if roll <= cumulative:
			return available_perches[i]

	return available_perches[0]


func _update_favourite_room() -> void:
	var best_room = ""
	var best_count: int = 0
	for room_id in room_visits:
		if room_visits[room_id] > best_count:
			best_count = room_visits[room_id]
			best_room = room_id
	favourite_room = best_room


func _update_favourite_perch() -> void:
	var best_perch = ""
	var best_count: int = 0
	for perch_name in perch_visits:
		if perch_visits[perch_name] > best_count:
			best_count = perch_visits[perch_name]
			best_perch = perch_name
	favourite_perch = best_perch


func _save_to_db() -> void:
	var data = {
		"room_visits": room_visits,
		"perch_visits": perch_visits,
		"player_affinity": player_affinity,
		"tasks_completed": tasks_completed_nearby,
		"favourite_room": favourite_room,
		"favourite_perch": favourite_perch,
	}
	DatabaseBridge.set_setting("cat_memory", JSON.stringify(data))


func _load_from_db() -> void:
	var raw = DatabaseBridge.get_setting("cat_memory")
	if raw == "":
		return
	var json = JSON.new()
	var err = json.parse(raw)
	if err != OK:
		return
	var parsed = json.data
	if parsed == null or typeof(parsed) != TYPE_DICTIONARY:
		return
	room_visits = parsed.get("room_visits", {})
	perch_visits = parsed.get("perch_visits", {})
	player_affinity = parsed.get("player_affinity", 0.5)
	tasks_completed_nearby = parsed.get("tasks_completed", 0)
	favourite_room = parsed.get("favourite_room", "")
	favourite_perch = parsed.get("favourite_perch", "")
