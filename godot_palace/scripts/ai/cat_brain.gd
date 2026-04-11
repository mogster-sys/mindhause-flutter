## CatBrain — state machine and decision making for the cat companion
## Decides what the cat wants to do, delegates movement/animation to siblings
extends Node

signal state_changed(new_state: int)

# Behaviour states
enum State {
	IDLE,         # Sitting / grooming / looking around
	WANDERING,    # Walking to a cat_spot
	LEADING,      # Guiding player to a task
	HISSING,      # Reacting to a monster
	NAPPING,      # Asleep on a surface
	FOLLOWING,    # Casually trailing the player
	CELEBRATING,  # Purring after task completion
	PERCHING,     # Sitting on furniture
	MORNING_WALK, # Guided review tour through rooms with tasks
}

@export var idle_duration_range: Vector2 = Vector2(3.0, 12.0)
@export var nap_duration_range: Vector2 = Vector2(30.0, 120.0)
@export var lead_check_interval: float = 15.0

var current_state: int = State.IDLE
var _state_timer: float = 0.0
var _lead_check_timer: float = 0.0
var _target_task_id: String = ""
var _player_ref: CharacterBody3D = null

# Emotional state (Tamagotchi-like)
var happiness: float = 0.7  # 0.0 to 1.0
var energy: float = 0.8

# Sibling references (set by cat_companion)
var movement: Node = null
var memory: Node = null

# Morning walk state
var _walk_room_queue: Array[String] = []
var _walk_task_queue: Array[Dictionary] = []
var _walk_pause_timer: float = 0.0
var _walk_heading_to_door: bool = false
var _morning_walk_offered: bool = false
var WALK_ROUTE = [
	"foyer", "study", "library", "garden", "kitchen",
	"workshop", "bedroom", "gymnasium", "treasury", "cellar",
]


func _ready() -> void:
	GameState.task_interacted.connect(_on_task_interacted)
	GameState.monster_spawned.connect(_on_monster_spawned)
	GameState.room_changed.connect(_on_room_changed)
	GameState.morning_walk_requested.connect(_on_morning_walk_requested)
	# Auto-start morning walk at dawn/morning on session start
	_try_auto_morning_walk.call_deferred()


func _process(delta: float) -> void:
	if not GameState.cat_enabled:
		return

	_state_timer -= delta
	_lead_check_timer -= delta

	match current_state:
		State.IDLE:
			_process_idle()
		State.WANDERING:
			_process_wandering()
		State.LEADING:
			_process_leading()
		State.HISSING:
			_process_hissing()
		State.NAPPING:
			_process_napping()
		State.FOLLOWING:
			_process_following()
		State.CELEBRATING:
			_process_celebrating()
		State.PERCHING:
			_process_perching()
		State.MORNING_WALK:
			_process_morning_walk(delta)

	# Periodic check for urgent tasks
	if _lead_check_timer <= 0 and current_state in [State.IDLE, State.WANDERING, State.FOLLOWING]:
		_lead_check_timer = lead_check_interval
		_check_for_lead_target()

	# Update emotional state
	_update_emotions(delta)


func enter_state(new_state: int) -> void:
	current_state = new_state
	state_changed.emit(new_state)

	match new_state:
		State.IDLE:
			_state_timer = randf_range(idle_duration_range.x, idle_duration_range.y)
			if movement:
				movement.stop()
		State.WANDERING:
			_state_timer = 10.0
			if movement:
				movement.wander_to_spot()
		State.LEADING:
			_state_timer = 30.0
		State.HISSING:
			_state_timer = 3.0
			if movement:
				movement.stop()
			AudioManager.play_sfx("cat_hiss")
		State.NAPPING:
			_state_timer = randf_range(nap_duration_range.x, nap_duration_range.y)
			if movement:
				movement.stop()
			energy = min(energy + 0.3, 1.0)
		State.FOLLOWING:
			_state_timer = randf_range(8.0, 20.0)
		State.CELEBRATING:
			_state_timer = 2.5
			if movement:
				movement.stop()
			AudioManager.play_sfx("cat_purr")
			happiness = min(happiness + 0.15, 1.0)
		State.PERCHING:
			_state_timer = randf_range(10.0, 40.0)
			if movement:
				movement.stop()
				_jump_to_nearest_perch()
		State.MORNING_WALK:
			_state_timer = 120.0  # Max time for one room's portion
			_walk_heading_to_door = false
			# Load tasks for the current room
			_walk_task_queue = DatabaseBridge.get_tasks_for_room(GameState.current_room)
			_walk_pause_timer = 1.0  # Brief pause before starting


# --- State processors ---

func _process_idle() -> void:
	if _state_timer <= 0:
		var weights = _get_behaviour_weights()
		var roll = randf()
		var cumulative: float = 0.0

		for entry in weights:
			cumulative += entry["weight"]
			if roll <= cumulative:
				if entry["state"] == State.NAPPING and energy > 0.5:
					enter_state(State.IDLE)
				elif entry["state"] == State.FOLLOWING and not _player_ref:
					enter_state(State.IDLE)
				elif entry["state"] == State.PERCHING and not _can_perch():
					enter_state(State.IDLE)
				else:
					enter_state(entry["state"])
				return
		enter_state(State.IDLE)


## Returns behaviour transition weights adjusted for time-of-day and energy
func _get_behaviour_weights() -> Array:
	var period: int = TimeOfDay.current_period

	# Base weights: wander, nap, follow, perch, idle
	var w_wander: float = 0.30
	var w_nap: float = 0.10
	var w_follow: float = 0.20
	var w_perch: float = 0.15
	var w_idle: float = 0.25

	# Time-of-day adjustments
	match period:
		0, 1:  # DAWN, MORNING — active, exploratory
			w_wander += 0.15
			w_follow += 0.05
			w_nap -= 0.05
		2:  # AFTERNOON — calm companion
			w_idle += 0.10
			w_perch += 0.05
			w_wander -= 0.10
		3:  # DUSK — curious, starts winding down
			w_perch += 0.10
			w_wander += 0.05
		4, 5:  # EVENING, NIGHT — sleepy, watchful
			w_nap += 0.15
			w_idle += 0.10
			w_wander -= 0.15
			w_follow -= 0.05

	# Energy adjustments
	if energy < 0.3:
		w_nap += 0.20
		w_wander -= 0.15
		w_follow -= 0.10
	elif energy > 0.7:
		w_wander += 0.10
		w_follow += 0.05
		w_nap -= 0.05

	# Happiness adjustments
	if happiness > 0.7:
		w_follow += 0.05
		w_perch += 0.05
	elif happiness < 0.3:
		w_idle += 0.10
		w_nap += 0.05

	# Clamp and normalise
	var entries = [
		{"state": State.WANDERING, "weight": max(w_wander, 0.05)},
		{"state": State.NAPPING, "weight": max(w_nap, 0.02)},
		{"state": State.FOLLOWING, "weight": max(w_follow, 0.05)},
		{"state": State.PERCHING, "weight": max(w_perch, 0.05)},
		{"state": State.IDLE, "weight": max(w_idle, 0.10)},
	]

	var total: float = 0.0
	for e in entries:
		total += e["weight"]
	for e in entries:
		e["weight"] = e["weight"] / total

	return entries


func _process_wandering() -> void:
	if _state_timer <= 0 or (movement and movement.is_arrived()):
		enter_state(State.IDLE)
		return
	if movement:
		movement.navigate_step(movement.move_speed)


func _process_leading() -> void:
	if _state_timer <= 0:
		enter_state(State.IDLE)
		return
	if movement and movement.is_arrived():
		AudioManager.play_sfx("cat_meow")
		enter_state(State.IDLE)
		return
	# Look back if player is far
	if movement and _player_ref:
		var dist = movement.get_cat_position().distance_to(_player_ref.global_position)
		if dist > 6.0:
			movement.stop()
			movement.face_position(_player_ref.global_position)
			if _state_timer < 28.0:
				AudioManager.play_sfx("cat_chirp")
		else:
			movement.navigate_step(movement.lead_speed)


func _process_hissing() -> void:
	if _state_timer <= 0:
		enter_state(State.IDLE)


func _process_napping() -> void:
	if _state_timer <= 0:
		enter_state(State.IDLE)


func _process_following() -> void:
	if _state_timer <= 0 or not _player_ref:
		enter_state(State.IDLE)
		return
	if movement:
		movement.follow_target(_player_ref.global_position)


func _process_celebrating() -> void:
	if _state_timer <= 0:
		enter_state(State.IDLE)


func _process_perching() -> void:
	if _state_timer <= 0:
		if movement:
			movement.dismount_perch()
		enter_state(State.IDLE)


# --- Decision making ---

func _jump_to_nearest_perch() -> void:
	var perches = get_tree().get_nodes_in_group("cat_perches")
	if perches.size() == 0 or not movement:
		return
	# Use memory to pick preferred perch, or nearest
	var chosen: Node3D
	if memory:
		chosen = memory.get_preferred_perch(perches)
	else:
		# Just pick nearest
		var cat_pos = movement.get_cat_position()
		var best_dist: float = INF
		for perch in perches:
			var dist = cat_pos.distance_to(perch.global_position)
			if dist < best_dist:
				best_dist = dist
				chosen = perch
	if chosen:
		movement.jump_to_perch(chosen)
		if memory:
			memory.record_perch_use(chosen.name)


func _can_perch() -> bool:
	var perches = get_tree().get_nodes_in_group("cat_perches")
	if perches.size() == 0 or not movement:
		return false
	# Check if any perch is within reach
	var cat_pos = movement.get_cat_position()
	for perch in perches:
		if cat_pos.distance_to(perch.global_position) < 3.0:
			return true
	return false


func _check_for_lead_target() -> void:
	if not _player_ref:
		return

	var tasks = GameState.tasks_in_room
	var best_task: Dictionary = {}
	var best_score: float = 0.0

	for task in tasks:
		if task.get("status", "") == "done":
			continue
		var score: float = 0.0
		match task.get("priority", "normal"):
			"high":
				score += 3.0
			"normal":
				score += 1.0
			"low":
				score += 0.5
		var due = task.get("due_date", null)
		if due != null and typeof(due) == TYPE_INT:
			var now = int(Time.get_unix_time_from_system())
			if due < now:
				score += 5.0
		match task.get("monster_state", "none"):
			"neglected":
				score += 2.0
			"corrupting":
				score += 1.0
			"monster":
				score -= 2.0

		if score > best_score:
			best_score = score
			best_task = task

	if best_score >= 3.0 and best_task.size() > 0:
		_target_task_id = best_task.get("id", "")
		var pos = Vector3(
			best_task.get("position_x", 0.0),
			best_task.get("position_y", 0.5),
			best_task.get("position_z", 0.0),
		)
		if movement:
			movement.move_to(pos)
		enter_state(State.LEADING)


# --- Morning walk ---

func _try_auto_morning_walk() -> void:
	if _morning_walk_offered:
		return
	var period: int = TimeOfDay.current_period
	# Only auto-start at dawn or morning
	if period != 0 and period != 1:  # DAWN=0, MORNING=1
		return
	# Check if there are any active tasks to review
	var tasks: Array[Dictionary] = DatabaseBridge.get_all_active_tasks()
	if tasks.size() == 0:
		return
	_morning_walk_offered = true
	# Wait a moment for the room to fully load, then start
	await get_tree().create_timer(3.0).timeout
	if GameState.cat_enabled:
		start_morning_walk()


## Start a guided tour of rooms with active tasks
func start_morning_walk() -> void:
	# Build queue of rooms that have tasks, in route order
	_walk_room_queue = []
	for room_id in WALK_ROUTE:
		var tasks: Array[Dictionary] = DatabaseBridge.get_tasks_for_room(room_id)
		if tasks.size() > 0:
			_walk_room_queue.append(room_id)

	if _walk_room_queue.size() == 0:
		GameState.cat_alert.emit("No tasks to review!")
		return

	GameState.cat_alert.emit("Morning walk starting...")
	AudioManager.play_sfx("cat_meow")

	# If current room has tasks, start here; otherwise go to first room
	if GameState.current_room in _walk_room_queue:
		# Remove rooms before current from queue (start from where we are)
		while _walk_room_queue.size() > 0 and _walk_room_queue[0] != GameState.current_room:
			_walk_room_queue.remove_at(0)
		enter_state(State.MORNING_WALK)
	else:
		# Current room has no tasks — change to first room with tasks
		var first_room: String = _walk_room_queue[0]
		enter_state(State.MORNING_WALK)
		GameState.change_room(first_room)


func _process_morning_walk(delta: float) -> void:
	if _state_timer <= 0 or _walk_room_queue.size() == 0:
		_finish_morning_walk()
		return

	_walk_pause_timer -= delta

	if _walk_pause_timer > 0:
		# Pausing — cat faces the player
		if movement and _player_ref:
			movement.face_position(_player_ref.global_position)
		return

	if _walk_heading_to_door:
		# Moving toward the door to the next room
		if movement and movement.is_arrived():
			# Cat is at the door; wait for player to follow through
			if _player_ref:
				movement.face_position(_player_ref.global_position)
		elif movement:
			movement.navigate_step(movement.lead_speed)
		return

	# Leading to task objects in this room
	if _walk_task_queue.size() > 0:
		var task: Dictionary = _walk_task_queue[0]
		var pos = Vector3(
			task.get("position_x", 0.0),
			task.get("position_y", 0.5),
			task.get("position_z", 0.0),
		)

		if movement:
			if movement.is_arrived():
				# Arrived at this task — pause and alert, then move to next
				AudioManager.play_sfx("cat_chirp")
				_walk_task_queue.remove_at(0)
				_walk_pause_timer = 2.5  # Pause so the player can see the task
			else:
				movement.move_to(pos)
				movement.navigate_step(movement.lead_speed)
	else:
		# All tasks in this room visited — head to the door for the next room
		_walk_room_queue.remove_at(0)  # Remove current room
		if _walk_room_queue.size() == 0:
			_finish_morning_walk()
			return

		# Find the door to the next room in queue
		_walk_heading_to_door = true
		var next_room: String = _walk_room_queue[0]
		var doors = get_tree().get_nodes_in_group("doors")
		for door in doors:
			if door.destination_room == next_room and movement:
				movement.move_to(door.global_position)
				AudioManager.play_sfx("cat_meow")
				return
		# No direct door found — just change room
		GameState.change_room(next_room)


func _advance_walk_room() -> void:
	# Called after a room transition during morning walk
	# Remove the previous room from queue if it's at the front
	if _walk_room_queue.size() > 0 and _walk_room_queue[0] != GameState.current_room:
		_walk_room_queue.remove_at(0)
	enter_state(State.MORNING_WALK)


func _finish_morning_walk() -> void:
	_walk_room_queue = []
	_walk_task_queue = []
	GameState.cat_alert.emit("Walk complete!")
	AudioManager.play_sfx("cat_purr")
	happiness = min(happiness + 0.2, 1.0)
	enter_state(State.CELEBRATING)


# --- Signal handlers ---

func _on_task_interacted(task_id: String) -> void:
	if current_state == State.LEADING and task_id == _target_task_id:
		enter_state(State.CELEBRATING)
	happiness = min(happiness + 0.05, 1.0)
	if memory:
		memory.record_task_completed()


func _on_morning_walk_requested() -> void:
	if current_state != State.MORNING_WALK:
		start_morning_walk()


func _on_monster_spawned(task_id: String, _room_id: String) -> void:
	if GameState.current_room == _room_id:
		_target_task_id = task_id
		enter_state(State.HISSING)


func _on_room_changed(_from: String, _to: String) -> void:
	if memory:
		memory.record_room_visit(_to)
	if current_state == State.MORNING_WALK:
		# Continue walk in the new room
		_advance_walk_room()
		return
	enter_state(State.IDLE)


# --- Emotional state ---

func _update_emotions(delta: float) -> void:
	happiness = max(happiness - 0.001 * delta, 0.0)
	if current_state != State.NAPPING:
		energy = max(energy - 0.002 * delta, 0.0)


func set_player(player: CharacterBody3D) -> void:
	_player_ref = player
