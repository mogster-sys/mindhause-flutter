## First-person player controller
## Handles movement (virtual joystick on mobile, WASD on desktop)
## and camera look (touch-drag on mobile, mouse on desktop)
extends CharacterBody3D

@export var move_speed: float = 4.0
@export var look_sensitivity: float = 0.003
@export var head_bob_frequency: float = 2.0
@export var head_bob_amplitude: float = 0.03

@onready var camera: Camera3D = $Camera3D
@onready var raycast: RayCast3D = $Camera3D/InteractRay
@onready var head_bob_timer: float = 0.0

# Footstep audio
var _last_step_sign: float = 1.0  # Tracks head bob cycle for step timing
var _step_cooldown: float = 0.0

# Floor surface type per room (for footstep sounds)
var _room_floor_sounds: Dictionary = {
	"foyer": "footstep_stone",
	"study": "footstep_wood",
	"library": "footstep_wood",
	"kitchen": "footstep_stone",
	"workshop": "footstep_stone",
	"garden": "footstep_grass",
	"bedroom": "footstep_wood",
	"gymnasium": "footstep_wood",
	"treasury": "footstep_stone",
	"cellar": "footstep_stone",
}

# Touch input state
var _touch_look_index: int = -1
var _touch_move_index: int = -1
var _touch_look_start: Vector2 = Vector2.ZERO
var _touch_move_start: Vector2 = Vector2.ZERO
var _touch_move_current: Vector2 = Vector2.ZERO

# Camera rotation
var _camera_rotation_x: float = 0.0
var _camera_rotation_y: float = 0.0

# Current look target (what the reticule is pointing at)
var look_target: Node3D = null
var look_target_distance: float = 0.0

# Screen zones — left half for movement, right half for look
var _screen_midpoint: float = 0.0

# Gravity
const GRAVITY: float = 9.8


func _ready() -> void:
	add_to_group("player")
	_screen_midpoint = get_viewport().get_visible_rect().size.x / 2.0
	# Capture mouse on desktop
	if not _is_mobile():
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity.y -= GRAVITY * delta

	# Movement input
	var input_dir = _get_movement_input()
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
		# Head bob
		head_bob_timer += delta * head_bob_frequency
		var bob_val: float = sin(head_bob_timer)
		camera.position.y = bob_val * head_bob_amplitude + 1.6

		# Play footstep at each bob cycle crossing (bottom of step)
		_step_cooldown -= delta
		if bob_val < 0.0 and _last_step_sign >= 0.0 and _step_cooldown <= 0.0:
			_play_footstep()
			_step_cooldown = 0.25  # Min gap between steps
		_last_step_sign = bob_val
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed * delta * 8)
		velocity.z = move_toward(velocity.z, 0, move_speed * delta * 8)
		# Settle head bob
		camera.position.y = lerp(camera.position.y, 1.6, delta * 5)
		_last_step_sign = 1.0

	move_and_slide()

	# Update look target (raycast)
	_update_look_target()

	# Sync position to game state
	GameState.player_position = global_position


func _input(event: InputEvent) -> void:
	if _is_mobile():
		_handle_touch_input(event)
	else:
		_handle_desktop_input(event)


func _handle_desktop_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		_rotate_camera(event.relative)

	if event.is_action_pressed("interact"):
		_try_interact()

	# Toggle mouse capture with Escape
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _handle_touch_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			# Left half = movement, right half = look
			if event.position.x < _screen_midpoint:
				_touch_move_index = event.index
				_touch_move_start = event.position
				_touch_move_current = event.position
			else:
				_touch_look_index = event.index
				_touch_look_start = event.position
		else:
			if event.index == _touch_move_index:
				_touch_move_index = -1
				_touch_move_current = _touch_move_start
			elif event.index == _touch_look_index:
				# Quick tap on right side = interact
				var tap_distance: float = event.position.distance_to(_touch_look_start)
				if tap_distance < 20.0:
					_try_interact()
				_touch_look_index = -1

	elif event is InputEventScreenDrag:
		if event.index == _touch_look_index:
			_rotate_camera(event.relative)
		elif event.index == _touch_move_index:
			_touch_move_current = event.position


func _rotate_camera(relative: Vector2) -> void:
	_camera_rotation_y -= relative.x * look_sensitivity
	_camera_rotation_x -= relative.y * look_sensitivity
	_camera_rotation_x = clamp(_camera_rotation_x, -PI / 2.2, PI / 2.2)

	rotation.y = _camera_rotation_y
	camera.rotation.x = _camera_rotation_x


func _get_movement_input() -> Vector2:
	if _is_mobile():
		if _touch_move_index >= 0:
			var delta = _touch_move_current - _touch_move_start
			var max_distance = 100.0
			delta = delta.limit_length(max_distance) / max_distance
			return Vector2(delta.x, delta.y)
		return Vector2.ZERO
	else:
		return Input.get_vector("move_left", "move_right", "move_forward", "move_backward")


func _update_look_target() -> void:
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider is Node3D:
			look_target = collider
			look_target_distance = global_position.distance_to(raycast.get_collision_point())
		else:
			look_target = null
	else:
		look_target = null


func _try_interact() -> void:
	if look_target and look_target.has_method("interact"):
		look_target.interact()
	elif look_target and look_target is Area3D:
		# Might be a door trigger
		var parent = look_target.get_parent()
		if parent and parent.has_method("interact"):
			parent.interact()


func _play_footstep() -> void:
	var sfx_name: String = _room_floor_sounds.get(GameState.current_room, "footstep_stone")
	AudioManager.play_sfx(sfx_name, 0.4)


func _is_mobile() -> bool:
	return OS.has_feature("android") or OS.has_feature("ios")
