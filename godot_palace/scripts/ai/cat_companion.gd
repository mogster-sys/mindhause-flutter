## Cat Companion — friendly ambient guide
## Behaviours:
##   - Wanders rooms idly, sits on surfaces, naps
##   - Leads player to urgent/overdue tasks (walks, pauses, looks back)
##   - Hisses at monster tasks (arched back, raised fur)
##   - Purrs when player completes a task (confirmation sound)
##   - Meows to get attention for important items
##   - Has Tamagotchi-like emotional state based on player engagement
extends CharacterBody3D

signal cat_meowed(reason: String)
signal cat_hissed(at_task_id: String)
signal cat_purred()

# Behaviour states
enum State {
	IDLE,         # Sitting / grooming / looking around
	WANDERING,    # Walking to a random point
	LEADING,      # Guiding player to a task
	HISSING,      # Reacting to a monster
	NAPPING,      # Asleep on a surface
	FOLLOWING,    # Casually trailing the player
	CELEBRATING,  # Purring after task completion
}

@export var move_speed: float = 2.5
@export var lead_speed: float = 1.8  # Slower when leading so player can follow
@export var idle_duration_range: Vector2 = Vector2(3.0, 12.0)
@export var nap_duration_range: Vector2 = Vector2(30.0, 120.0)
@export var lead_check_interval: float = 15.0

var current_state: State = State.IDLE
var _target_position: Vector3 = Vector3.ZERO
var _target_task_id: String = ""
var _state_timer: float = 0.0
var _lead_check_timer: float = 0.0
var _player_ref: CharacterBody3D = null

# Emotional state (Tamagotchi-like)
var happiness: float = 0.7  # 0.0 to 1.0
var energy: float = 0.8

# Navigation
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var mesh: MeshInstance3D = $CatMesh
@onready var animation_tree: AnimationTree = $AnimationTree

const GRAVITY: float = 9.8


func _ready() -> void:
	add_to_group("cat")
	GameState.task_interacted.connect(_on_task_interacted)
	GameState.monster_spawned.connect(_on_monster_spawned)
	GameState.room_changed.connect(_on_room_changed)

	# Start idling
	_enter_state(State.IDLE)


func _physics_process(delta: float) -> void:
	if not GameState.cat_enabled:
		visible = false
		return
	visible = true

	# Gravity
	if not is_on_floor():
		velocity.y -= GRAVITY * delta

	_state_timer -= delta
	_lead_check_timer -= delta

	match current_state:
		State.IDLE:
			_process_idle(delta)
		State.WANDERING:
			_process_wandering(delta)
		State.LEADING:
			_process_leading(delta)
		State.HISSING:
			_process_hissing(delta)
		State.NAPPING:
			_process_napping(delta)
		State.FOLLOWING:
			_process_following(delta)
		State.CELEBRATING:
			_process_celebrating(delta)

	# Periodic check for urgent tasks to lead player to
	if _lead_check_timer <= 0 and current_state in [State.IDLE, State.WANDERING, State.FOLLOWING]:
		_lead_check_timer = lead_check_interval
		_check_for_lead_target()

	move_and_slide()

	# Update emotional state
	_update_emotions(delta)


func _enter_state(new_state: State) -> void:
	current_state = new_state
	match new_state:
		State.IDLE:
			_state_timer = randf_range(idle_duration_range.x, idle_duration_range.y)
			velocity = Vector3.ZERO
		State.WANDERING:
			_state_timer = 10.0
			_pick_wander_target()
		State.LEADING:
			_state_timer = 30.0  # Give up after 30s
		State.HISSING:
			_state_timer = 3.0
			velocity = Vector3.ZERO
			AudioManager.play_sfx("cat_hiss")
			cat_hissed.emit(_target_task_id)
		State.NAPPING:
			_state_timer = randf_range(nap_duration_range.x, nap_duration_range.y)
			velocity = Vector3.ZERO
			energy = min(energy + 0.3, 1.0)
		State.FOLLOWING:
			_state_timer = randf_range(8.0, 20.0)
		State.CELEBRATING:
			_state_timer = 2.5
			velocity = Vector3.ZERO
			AudioManager.play_sfx("cat_purr")
			cat_purred.emit()
			happiness = min(happiness + 0.15, 1.0)


# --- State processors ---

func _process_idle(delta: float) -> void:
	if _state_timer <= 0:
		# Transition to next state
		var roll := randf()
		if roll < 0.4:
			_enter_state(State.WANDERING)
		elif roll < 0.6 and energy < 0.4:
			_enter_state(State.NAPPING)
		elif roll < 0.8 and _player_ref:
			_enter_state(State.FOLLOWING)
		else:
			_enter_state(State.IDLE)


func _process_wandering(_delta: float) -> void:
	if _state_timer <= 0 or nav_agent.is_navigation_finished():
		_enter_state(State.IDLE)
		return

	var next_pos := nav_agent.get_next_path_position()
	var direction := (next_pos - global_position).normalized()
	velocity.x = direction.x * move_speed
	velocity.z = direction.z * move_speed

	# Face movement direction
	if direction.length() > 0.1:
		look_at(global_position + direction, Vector3.UP)


func _process_leading(delta: float) -> void:
	if _state_timer <= 0:
		_enter_state(State.IDLE)
		return

	if nav_agent.is_navigation_finished():
		# Reached the task — meow to get attention
		AudioManager.play_sfx("cat_meow")
		cat_meowed.emit("found_task")
		_enter_state(State.IDLE)
		return

	var next_pos := nav_agent.get_next_path_position()
	var direction := (next_pos - global_position).normalized()

	# Check if player is following (within range)
	if _player_ref:
		var dist_to_player := global_position.distance_to(_player_ref.global_position)
		if dist_to_player > 6.0:
			# Player fell behind — pause and look back
			velocity.x = 0
			velocity.z = 0
			look_at(_player_ref.global_position, Vector3.UP)
			# Meow to get attention
			if _state_timer < 28.0:  # Don't meow immediately
				AudioManager.play_sfx("cat_chirp")
				cat_meowed.emit("follow_me")
			return

	velocity.x = direction.x * lead_speed
	velocity.z = direction.z * lead_speed

	if direction.length() > 0.1:
		look_at(global_position + direction, Vector3.UP)


func _process_hissing(_delta: float) -> void:
	if _state_timer <= 0:
		_enter_state(State.IDLE)
		return
	# Face the monster
	var monsters := get_tree().get_nodes_in_group("task_objects").filter(
		func(n): return n.visual_state == n.VisualState.MONSTER
	)
	if monsters.size() > 0:
		var nearest := _find_nearest(monsters)
		if nearest:
			look_at(nearest.global_position, Vector3.UP)


func _process_napping(_delta: float) -> void:
	if _state_timer <= 0:
		_enter_state(State.IDLE)


func _process_following(_delta: float) -> void:
	if _state_timer <= 0 or not _player_ref:
		_enter_state(State.IDLE)
		return

	var dist := global_position.distance_to(_player_ref.global_position)
	if dist > 2.5:
		nav_agent.target_position = _player_ref.global_position
		var next_pos := nav_agent.get_next_path_position()
		var direction := (next_pos - global_position).normalized()
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
		if direction.length() > 0.1:
			look_at(global_position + direction, Vector3.UP)
	else:
		velocity.x = 0
		velocity.z = 0


func _process_celebrating(_delta: float) -> void:
	if _state_timer <= 0:
		_enter_state(State.IDLE)


# --- Decision making ---

func _check_for_lead_target() -> void:
	if not _player_ref:
		return

	# Find overdue or high-priority tasks in current room
	var tasks := GameState.tasks_in_room
	var best_task: Dictionary = {}
	var best_score: float = 0.0

	for task in tasks:
		if task.get("status", "") == "done":
			continue
		var score: float = 0.0
		# Priority weight
		match task.get("priority", "normal"):
			"high":
				score += 3.0
			"normal":
				score += 1.0
			"low":
				score += 0.5
		# Overdue bonus
		var due = task.get("due_date", null)
		if due != null and typeof(due) == TYPE_INT:
			var now := int(Time.get_unix_time_from_system())
			if due < now:
				score += 5.0  # Overdue
		# Monster penalty (cat avoids full monsters, but leads to neglected/corrupting)
		match task.get("monster_state", "none"):
			"neglected":
				score += 2.0
			"corrupting":
				score += 1.0
			"monster":
				score -= 2.0  # Cat hisses at these instead

		if score > best_score:
			best_score = score
			best_task = task

	if best_score >= 3.0 and best_task.size() > 0:
		# Lead player to this task
		_target_task_id = best_task.get("id", "")
		var pos := Vector3(
			best_task.get("position_x", 0.0),
			best_task.get("position_y", 0.5),
			best_task.get("position_z", 0.0),
		)
		nav_agent.target_position = pos
		_enter_state(State.LEADING)


func _pick_wander_target() -> void:
	# Pick a random point in the room
	var pos := global_position + Vector3(
		randf_range(-4, 4),
		0,
		randf_range(-4, 4),
	)
	nav_agent.target_position = pos


func _find_nearest(nodes: Array) -> Node3D:
	var nearest: Node3D = null
	var min_dist: float = INF
	for node in nodes:
		var dist: float = global_position.distance_to(node.global_position)
		if dist < min_dist:
			min_dist = dist
			nearest = node
	return nearest


# --- Signal handlers ---

func _on_task_interacted(task_id: String) -> void:
	# Player interacted with a task — celebrate if we were leading to it
	if current_state == State.LEADING and task_id == _target_task_id:
		_enter_state(State.CELEBRATING)
	happiness = min(happiness + 0.05, 1.0)


func _on_monster_spawned(task_id: String, _room_id: String) -> void:
	# React to a new monster in the current room
	if GameState.current_room == _room_id:
		_target_task_id = task_id
		_enter_state(State.HISSING)


func _on_room_changed(_from: String, _to: String) -> void:
	# Teleport cat to new room
	_enter_state(State.IDLE)


# --- Emotional state ---

func _update_emotions(delta: float) -> void:
	# Happiness decays slowly, boosted by player interaction
	happiness = max(happiness - 0.001 * delta, 0.0)
	# Energy decays while active, restores while napping
	if current_state != State.NAPPING:
		energy = max(energy - 0.002 * delta, 0.0)


func set_player(player: CharacterBody3D) -> void:
	_player_ref = player
