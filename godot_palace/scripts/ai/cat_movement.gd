## CatMovement — handles navigation, pathfinding, and physical movement
## Controlled by CatBrain, drives the CharacterBody3D
extends Node

@export var move_speed: float = 2.5
@export var lead_speed: float = 1.8
@export var turn_speed: float = 8.0

var _cat: CharacterBody3D = null
var _nav_agent: NavigationAgent3D = null
var _is_perched: bool = false
var _perch_tween: Tween = null

const GRAVITY: float = 9.8


func setup(cat: CharacterBody3D, nav_agent: NavigationAgent3D) -> void:
	_cat = cat
	_nav_agent = nav_agent


func _physics_process(delta: float) -> void:
	if not _cat or not GameState.cat_enabled:
		return

	# Gravity (skip while perched — tweening handles position)
	if not _is_perched and not _cat.is_on_floor():
		_cat.velocity.y -= GRAVITY * delta

	_cat.move_and_slide()


func stop() -> void:
	if _cat:
		_cat.velocity.x = 0
		_cat.velocity.z = 0


func move_to(target: Vector3) -> void:
	if _nav_agent:
		_nav_agent.target_position = target


func wander_to_spot() -> void:
	# Pick a random cat_spot
	var spots = _cat.get_tree().get_nodes_in_group("cat_spots")
	if spots.size() > 0:
		var target_spot: Node3D = spots[randi() % spots.size()]
		move_to(target_spot.global_position)
		return

	# Fallback: random nearby position
	if _cat:
		var pos = _cat.global_position + Vector3(
			randf_range(-4, 4), 0, randf_range(-4, 4)
		)
		move_to(pos)


func follow_target(target_pos: Vector3) -> void:
	if not _cat:
		return
	var dist = _cat.global_position.distance_to(target_pos)
	if dist > 2.5:
		move_to(target_pos)
		_navigate_toward_target(move_speed)
	else:
		stop()


func face_position(target_pos: Vector3) -> void:
	if _cat:
		_cat.look_at(target_pos, Vector3.UP)


func is_arrived() -> bool:
	if _nav_agent:
		return _nav_agent.is_navigation_finished()
	return true


func get_cat_position() -> Vector3:
	if _cat:
		return _cat.global_position
	return Vector3.ZERO


func navigate_step(speed: float) -> void:
	_navigate_toward_target(speed)


func _navigate_toward_target(speed: float) -> void:
	if not _nav_agent or not _cat:
		return
	if _nav_agent.is_navigation_finished():
		return

	var next_pos = _nav_agent.get_next_path_position()
	var direction = (next_pos - _cat.global_position).normalized()
	_cat.velocity.x = direction.x * speed
	_cat.velocity.z = direction.z * speed

	# Smooth turn toward movement direction
	if direction.length() > 0.1:
		var target_rot: float = atan2(-direction.x, -direction.z)
		_cat.rotation.y = lerp_angle(_cat.rotation.y, target_rot, _cat.get_physics_process_delta_time() * turn_speed)


# --- Perch system ---

func jump_to_perch(perch: Marker3D) -> void:
	if not _cat or _is_perched:
		return

	_is_perched = true
	stop()

	var perch_pos = perch.global_position
	var mid_point = (_cat.global_position + perch_pos) / 2.0
	mid_point.y = max(_cat.global_position.y, perch_pos.y) + 0.4  # Arc height

	if _perch_tween:
		_perch_tween.kill()
	_perch_tween = _cat.create_tween()
	_perch_tween.tween_property(_cat, "global_position", mid_point, 0.25).set_ease(Tween.EASE_OUT)
	_perch_tween.tween_property(_cat, "global_position", perch_pos, 0.2).set_ease(Tween.EASE_IN)

	# Face the perch's preferred direction
	var facing: Vector3 = perch.get_meta("facing", Vector3(0, 0, 1))
	if facing.length() > 0:
		_perch_tween.tween_callback(func():
			face_position(perch_pos + facing)
		)


func dismount_perch() -> void:
	if not _cat or not _is_perched:
		return

	_is_perched = false

	# Find nearest floor-level cat_spot to land at
	var spots = _cat.get_tree().get_nodes_in_group("cat_spots")
	var best_spot: Node3D = null
	var best_dist: float = INF
	for spot in spots:
		var dist = _cat.global_position.distance_to(spot.global_position)
		if dist < best_dist:
			best_dist = dist
			best_spot = spot

	var land_pos: Vector3
	if best_spot:
		land_pos = best_spot.global_position
	else:
		land_pos = _cat.global_position
		land_pos.y = 0.05

	var mid_point = (_cat.global_position + land_pos) / 2.0
	mid_point.y = _cat.global_position.y + 0.2

	if _perch_tween:
		_perch_tween.kill()
	_perch_tween = _cat.create_tween()
	_perch_tween.tween_property(_cat, "global_position", mid_point, 0.2).set_ease(Tween.EASE_OUT)
	_perch_tween.tween_property(_cat, "global_position", land_pos, 0.25).set_ease(Tween.EASE_IN)
