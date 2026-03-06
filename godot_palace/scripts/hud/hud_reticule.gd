## HUD Reticule — the centre-screen crosshair that passively scans objects
## Shows task info on hover, changes colour based on priority/monster state
extends Control

@onready var crosshair: Control = $Crosshair
@onready var reticule_icon: ColorRect = $Crosshair/ReticuleIcon
@onready var info_panel: PanelContainer = $InfoPanel
@onready var task_title: Label = $InfoPanel/VBox/TaskTitle
@onready var task_priority: Label = $InfoPanel/VBox/TaskPriority
@onready var task_due: Label = $InfoPanel/VBox/TaskDue
@onready var monster_warning: Label = $InfoPanel/VBox/MonsterWarning
@onready var interact_hint: PanelContainer = $InteractHint
@onready var hint_label: Label = $InteractHint/HintLabel
@onready var room_label: Label = $RoomLabel

# Reticule colours
const COLOR_IDLE := Color(0.96, 0.94, 0.91, 0.4)  # marble, subtle
const COLOR_HOVER := Color(0.72, 0.45, 0.2, 0.8)   # terracotta
const COLOR_HIGH := Color(0.75, 0.22, 0.17, 0.9)    # urgent red
const COLOR_MONSTER := Color(0.8, 0.1, 0.1, 1.0)    # monster red
const COLOR_DONE := Color(0.83, 0.66, 0.26, 0.6)    # completed gold

var _current_target: Node3D = null
var _player: CharacterBody3D = null
var _tween: Tween = null
var _room_label_tween: Tween = null


func _ready() -> void:
	info_panel.visible = false
	interact_hint.visible = false
	_set_reticule_color(COLOR_IDLE)
	# Auto-find the player after the scene tree is ready
	await get_tree().process_frame
	var players := get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		_player = players[0]
	# Listen for room changes to show room name
	GameState.room_changed.connect(_on_room_changed)


func set_player(player: CharacterBody3D) -> void:
	_player = player


func _process(_delta: float) -> void:
	if not _player:
		return

	var target: Node3D = _player.look_target
	var distance: float = _player.look_target_distance

	if target != _current_target:
		_current_target = target
		_update_display(target, distance)


func _update_display(target: Node3D, distance: float) -> void:
	if target == null or distance > 8.0:
		_hide_info()
		return

	if target.has_method("get_task_data"):
		var data: Dictionary = target.get_task_data()
		_show_task_info(data)
	elif target.is_in_group("doors"):
		_show_door_hint(target)
	elif target.is_in_group("surfaces"):
		_show_surface_hint(target)
	else:
		_hide_info()


func _show_task_info(data: Dictionary) -> void:
	task_title.text = data.get("title", "Unknown")

	var priority: String = data.get("priority", "normal")
	task_priority.text = priority.capitalize()
	task_priority.add_theme_color_override("font_color", _priority_color(priority))

	var due_date = data.get("due_date", "")
	task_due.visible = due_date != ""
	if due_date != "":
		task_due.text = "Due: " + str(due_date)

	var monster_state: String = data.get("monster_state", "none")
	monster_warning.visible = monster_state != "none"
	if monster_state != "none":
		monster_warning.text = "! " + monster_state.capitalize()

	if monster_state == "monster":
		_set_reticule_color(COLOR_MONSTER)
	elif priority == "high" or monster_state == "corrupting":
		_set_reticule_color(COLOR_HIGH)
	elif data.get("status", "") == "done":
		_set_reticule_color(COLOR_DONE)
	else:
		_set_reticule_color(COLOR_HOVER)

	info_panel.visible = true
	interact_hint.visible = true
	hint_label.text = "Tap to interact"


func _show_door_hint(door: Node3D) -> void:
	info_panel.visible = false
	interact_hint.visible = true
	if door.has_method("get_destination_name"):
		hint_label.text = "Go to " + door.get_destination_name()
	else:
		hint_label.text = "Open door"
	_set_reticule_color(COLOR_HOVER)


func _show_surface_hint(surface: Node3D) -> void:
	info_panel.visible = false
	interact_hint.visible = true
	hint_label.text = "Place item"
	_set_reticule_color(COLOR_HOVER)


func _hide_info() -> void:
	info_panel.visible = false
	interact_hint.visible = false
	_set_reticule_color(COLOR_IDLE)


func _set_reticule_color(color: Color) -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(crosshair, "modulate", color, 0.15)


func _on_room_changed(_from: String, to_room: String) -> void:
	var display_name := to_room.capitalize()
	for room in GameState.all_rooms:
		if room.get("id", "") == to_room or room.get("name", "") == to_room:
			display_name = room.get("display_name", display_name)
			break

	room_label.text = display_name
	room_label.modulate.a = 1.0
	if _room_label_tween:
		_room_label_tween.kill()
	_room_label_tween = create_tween()
	_room_label_tween.tween_interval(2.0)
	_room_label_tween.tween_property(room_label, "modulate:a", 0.0, 1.0)


func _priority_color(priority: String) -> Color:
	match priority:
		"high":
			return Color(0.75, 0.22, 0.17)
		"low":
			return Color(0.41, 0.64, 0.34)
		_:
			return Color(0.83, 0.66, 0.26)
