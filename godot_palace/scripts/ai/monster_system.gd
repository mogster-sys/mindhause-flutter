## MonsterSystem — evolves neglected tasks into monsters
## Runs periodic checks against the database
## Handles monster chasing behaviour when enabled
extends Node

@export var check_interval: float = 60.0  # Check every minute
@export var chase_speed: float = 1.5
@export var chase_range: float = 8.0
@export var flee_range: float = 12.0

var _check_timer: float = 0.0
var _active_chasers: Array[Node3D] = []
var _chase_audio_playing: bool = false


func _ready() -> void:
	GameState.room_changed.connect(_on_room_changed)
	_check_timer = 5.0  # First check after 5 seconds


func _process(delta: float) -> void:
	if not GameState.monsters_enabled:
		return

	_check_timer -= delta
	if _check_timer <= 0:
		_check_timer = check_interval
		_evolve_tasks()

	# Process chasers
	if GameState.monster_chasing:
		_process_chasers(delta)


func _evolve_tasks() -> void:
	# Check all tasks for monster evolution
	var neglectable := DatabaseBridge.get_neglectable_tasks()
	var now := int(Time.get_unix_time_from_system())

	for task in neglectable:
		var last_interaction = task.get("last_interaction", now)
		if typeof(last_interaction) != TYPE_INT:
			continue

		var hours_since := (now - last_interaction) / 3600.0
		var thresholds := GameState.monster_thresholds.get(
			GameState.monster_sensitivity,
			GameState.monster_thresholds["normal"]
		)

		var new_state := "none"
		if hours_since >= thresholds["monster"]:
			new_state = "monster"
		elif hours_since >= thresholds["corrupting"]:
			new_state = "corrupting"
		elif hours_since >= thresholds["neglected"]:
			new_state = "neglected"

		var current_state: String = task.get("monster_state", "none")
		if new_state != current_state and new_state != "none":
			var task_id: String = task.get("id", "")
			DatabaseBridge.update_monster_state(task_id, new_state)
			if new_state == "monster":
				AudioManager.play_sfx("monster_growl")
				var room_id: String = task.get("room", "")
				GameState.monster_spawned.emit(task_id, room_id)

	# Also check existing monsters for any that got completed/interacted
	_refresh_active_monsters()


func _refresh_active_monsters() -> void:
	GameState.active_monsters = DatabaseBridge.get_monster_tasks()


func _process_chasers(delta: float) -> void:
	# Find monster task objects in the current room
	var player := _get_player()
	if not player:
		return

	var monster_objects := get_tree().get_nodes_in_group("task_objects").filter(
		func(n): return n.visual_state == n.VisualState.MONSTER
	)

	var any_chasing := false
	for monster in monster_objects:
		if not monster is RigidBody3D:
			continue

		var dist: float = monster.global_position.distance_to(player.global_position)

		if dist < chase_range and dist > 1.5:
			any_chasing = true
			# Chase the player
			var direction := (player.global_position - monster.global_position).normalized()
			# Monsters move along the floor
			direction.y = 0
			monster.linear_velocity = direction * chase_speed

			# Face the player
			monster.look_at(player.global_position, Vector3.UP)
		elif dist <= 1.5:
			# Close enough — nudge the player (scare effect)
			monster.linear_velocity = Vector3.ZERO
		elif dist > flee_range:
			# Too far — slow down
			monster.linear_velocity = monster.linear_velocity.lerp(Vector3.ZERO, delta * 2)

	# Chase audio — play while any monster is actively chasing
	if any_chasing and not _chase_audio_playing:
		AudioManager.play_sfx("monster_chase")
		_chase_audio_playing = true
	elif not any_chasing and _chase_audio_playing:
		_chase_audio_playing = false


func _on_room_changed(_from: String, _to: String) -> void:
	_active_chasers.clear()


func _get_player() -> CharacterBody3D:
	var players := get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		return players[0] as CharacterBody3D
	return null
