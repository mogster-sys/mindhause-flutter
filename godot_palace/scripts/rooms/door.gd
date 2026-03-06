## Door — connects rooms in the palace
## Can be walked through or tapped via reticule
## Animates open/close, shows destination name
extends Node3D

@export var destination_room: String = ""
@export var destination_spawn: Vector3 = Vector3.ZERO
@export var is_stairs: bool = false
@export var requires_unlock: bool = false

@onready var door_panel: Node3D = $DoorPanel
@onready var trigger_area: Area3D = $TriggerArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var _is_open: bool = false
var _player_nearby: bool = false


func _ready() -> void:
	add_to_group("doors")
	trigger_area.body_entered.connect(_on_body_entered)
	trigger_area.body_exited.connect(_on_body_exited)


func get_destination_name() -> String:
	# Look up display name from game state
	for room in GameState.all_rooms:
		if room.get("name", "") == destination_room or room.get("id", "") == destination_room:
			return room.get("display_name", destination_room.capitalize())
	return destination_room.capitalize()


func interact() -> void:
	if requires_unlock:
		# Check if room is unlocked in settings
		# For now, all rooms are unlocked
		pass
	_transition_to_room()


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		_player_nearby = true
		if not _is_open:
			_open_door()


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		_player_nearby = false
		# Close door after a delay
		await get_tree().create_timer(1.5).timeout
		if not _player_nearby and _is_open:
			_close_door()


func _open_door() -> void:
	_is_open = true
	AudioManager.play_sfx("door_open")
	if animation_player and animation_player.has_animation("open"):
		animation_player.play("open")
	else:
		# Fallback: just rotate
		var tween := create_tween()
		tween.tween_property(door_panel, "rotation_degrees:y", -90.0, 0.5).set_ease(Tween.EASE_OUT)


func _close_door() -> void:
	_is_open = false
	AudioManager.play_sfx("door_close")
	if animation_player and animation_player.has_animation("close"):
		animation_player.play("close")
	else:
		var tween := create_tween()
		tween.tween_property(door_panel, "rotation_degrees:y", 0.0, 0.4).set_ease(Tween.EASE_IN)


func _transition_to_room() -> void:
	if is_stairs:
		AudioManager.play_sfx("stairs_step")
	# Fade to black, load new room, fade in
	GameState.change_room(destination_room)
	# Room manager handles the actual scene transition
	# This just signals the intent
