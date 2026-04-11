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
@onready var room_banner: PanelContainer = $RoomBanner
@onready var banner_room_name: Label = $RoomBanner/VBox/RoomName
@onready var banner_task_count: Label = $RoomBanner/VBox/TaskCount
@onready var placement_toast: PanelContainer = $PlacementToast
@onready var toast_label: Label = $PlacementToast/ToastLabel
@onready var quiz_overlay: PanelContainer = $QuizOverlay
@onready var quiz_task_name: Label = $QuizOverlay/VBox/QuizTaskName
@onready var quiz_options: VBoxContainer = $QuizOverlay/VBox/QuizOptions
@onready var quiz_feedback: Label = $QuizOverlay/VBox/QuizFeedback

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
var _toast_tween: Tween = null
var _quiz_correct_room: String = ""
var _room_transitions_since_quiz: int = 0
const QUIZ_CHANCE_PER_TRANSITION := 0.15  # 15% chance per room change


func _ready() -> void:
	info_panel.visible = false
	interact_hint.visible = false
	_set_reticule_color(COLOR_IDLE)
	# Auto-find the player after the scene tree is ready
	await get_tree().process_frame
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		_player = players[0]
	# Listen for room changes to show room name
	GameState.room_changed.connect(_on_room_changed)
	# Listen for task placements to show spatial address
	GameState.task_placed.connect(_on_task_placed)


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
	if surface.has_method("get_display_name") and surface.has_method("available_slots"):
		var avail: int = surface.available_slots()
		var display: String = surface.get_display_name()
		if avail > 0:
			hint_label.text = display + " (" + str(avail) + " free)"
		else:
			hint_label.text = display + " (full)"
	else:
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
	var display_name: String = to_room.capitalize()
	for room in GameState.all_rooms:
		if room.get("id", "") == to_room or room.get("name", "") == to_room:
			display_name = room.get("display_name", display_name)
			break

	# Room name
	banner_room_name.text = display_name

	# Task count — tasks_in_room is refreshed before this signal fires
	var task_count: int = GameState.tasks_in_room.size()
	if task_count == 0:
		banner_task_count.text = "No tasks"
	elif task_count == 1:
		banner_task_count.text = "1 task"
	else:
		banner_task_count.text = str(task_count) + " tasks"

	# Show banner and fade out after a pause
	room_banner.visible = true
	room_banner.modulate.a = 1.0
	if _room_label_tween:
		_room_label_tween.kill()
	_room_label_tween = create_tween()
	_room_label_tween.tween_interval(2.5)
	_room_label_tween.tween_property(room_banner, "modulate:a", 0.0, 1.0)
	_room_label_tween.tween_callback(func(): room_banner.visible = false)

	# Maybe trigger a retrieval quiz after a few room transitions
	_room_transitions_since_quiz += 1
	if _room_transitions_since_quiz >= 3 and randf() < QUIZ_CHANCE_PER_TRANSITION:
		# Delay so the banner shows first
		await get_tree().create_timer(3.5).timeout
		_try_show_quiz()


func _on_task_placed(room_name: String, surface_name: String, slot_number: int) -> void:
	toast_label.text = room_name + "  >  " + surface_name + "  >  Slot " + str(slot_number)
	placement_toast.visible = true
	placement_toast.modulate.a = 1.0
	if _toast_tween:
		_toast_tween.kill()
	_toast_tween = create_tween()
	_toast_tween.tween_interval(2.0)
	_toast_tween.tween_property(placement_toast, "modulate:a", 0.0, 0.8)
	_toast_tween.tween_callback(func(): placement_toast.visible = false)


func _try_show_quiz() -> void:
	if quiz_overlay.visible:
		return
	var all_tasks: Array[Dictionary] = DatabaseBridge.get_all_active_tasks()
	# Filter to tasks NOT in the current room (test recall of other rooms)
	var candidates: Array[Dictionary] = []
	for t in all_tasks:
		if t.get("room", "") != GameState.current_room:
			candidates.append(t)
	if candidates.size() == 0:
		return

	var task: Dictionary = candidates[randi() % candidates.size()]
	var correct_room_id: String = task.get("room", "")
	_quiz_correct_room = correct_room_id

	# Get display name for correct room
	var correct_display: String = correct_room_id.capitalize()
	for room in GameState.all_rooms:
		if room.get("id", "") == correct_room_id:
			correct_display = room.get("display_name", correct_display)
			break

	# Build 4 options: 1 correct + 3 random wrong
	var all_room_ids: Array[String] = []
	for room in GameState.all_rooms:
		var rid: String = room.get("id", "")
		if rid != correct_room_id:
			all_room_ids.append(rid)

	# Shuffle and pick 3 wrong rooms
	var wrong_rooms: Array[String] = []
	while wrong_rooms.size() < 3 and all_room_ids.size() > 0:
		var idx: int = randi() % all_room_ids.size()
		wrong_rooms.append(all_room_ids[idx])
		all_room_ids.remove_at(idx)

	# Build option list and shuffle
	var options: Array[Dictionary] = []
	options.append({"id": correct_room_id, "display": correct_display})
	for wid in wrong_rooms:
		var wdisplay: String = wid.capitalize()
		for room in GameState.all_rooms:
			if room.get("id", "") == wid:
				wdisplay = room.get("display_name", wdisplay)
				break
		options.append({"id": wid, "display": wdisplay})

	# Shuffle options
	for i in range(options.size() - 1, 0, -1):
		var j: int = randi() % (i + 1)
		var temp: Dictionary = options[i]
		options[i] = options[j]
		options[j] = temp

	# Set up the UI
	quiz_task_name.text = "\"" + task.get("title", "Unknown Task") + "\""
	quiz_feedback.visible = false

	# Clear old buttons
	for child in quiz_options.get_children():
		child.queue_free()

	# Create option buttons
	for opt in options:
		var btn := Button.new()
		btn.text = opt["display"]
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.add_theme_font_size_override("font_size", 15)
		var room_id: String = opt["id"]
		btn.pressed.connect(func(): _on_quiz_answer(room_id, correct_room_id, correct_display))
		quiz_options.add_child(btn)

	quiz_overlay.visible = true
	quiz_overlay.modulate.a = 1.0
	_room_transitions_since_quiz = 0


func _on_quiz_answer(chosen: String, correct_id: String, correct_display: String) -> void:
	# Disable buttons
	for child in quiz_options.get_children():
		if child is Button:
			child.disabled = true

	quiz_feedback.visible = true
	if chosen == correct_id:
		quiz_feedback.text = "Correct!"
		quiz_feedback.add_theme_color_override("font_color", Color(0.41, 0.64, 0.34))
		AudioManager.play_sfx("task_complete")
	else:
		quiz_feedback.text = "It's in " + correct_display
		quiz_feedback.add_theme_color_override("font_color", Color(0.75, 0.22, 0.17))

	# Auto-dismiss after a pause
	await get_tree().create_timer(2.0).timeout
	var dismiss_tween: Tween = create_tween()
	dismiss_tween.tween_property(quiz_overlay, "modulate:a", 0.0, 0.5)
	dismiss_tween.tween_callback(func(): quiz_overlay.visible = false)


func _priority_color(priority: String) -> Color:
	match priority:
		"high":
			return Color(0.75, 0.22, 0.17)
		"low":
			return Color(0.41, 0.64, 0.34)
		_:
			return Color(0.83, 0.66, 0.26)
