## PlacementSurface — a desk, shelf, notice board, etc. where task objects sit
## Manages capacity and snap positions for objects
extends StaticBody3D

signal object_placed(surface_name: String, slot_number: int)

@export var surface_id: String = ""
@export var surface_type: String = "desk"  # desk, shelf, wall, pedestal, notice_board, picture_frame, chalkboard, floor
@export var capacity: int = 10
@export var slot_spacing: float = 0.2

var occupied_slots: Array[Vector3] = []
var placed_objects: Array[Node3D] = []


func _ready() -> void:
	add_to_group("surfaces")


## Human-readable name derived from node name (e.g. "WritingDesk" → "Writing Desk")
func get_display_name() -> String:
	var raw: String = name
	# Insert space before each uppercase letter that follows a lowercase letter
	var result: String = ""
	for i in range(raw.length()):
		var ch: String = raw[i]
		if i > 0 and ch == ch.to_upper() and ch != ch.to_lower() and raw[i - 1] == raw[i - 1].to_lower():
			result += " "
		result += ch
	return result


## Get the next available position on this surface
func get_next_slot() -> Vector3:
	if occupied_slots.size() >= capacity:
		return Vector3.ZERO  # Full

	var slot_index = occupied_slots.size()
	var local_pos = _calculate_slot_position(slot_index)
	var world_pos = to_global(local_pos)
	occupied_slots.append(world_pos)
	return world_pos


## Place an object on this surface
func place_object(obj: Node3D) -> bool:
	if placed_objects.size() >= capacity:
		return false

	var slot_num: int = placed_objects.size() + 1
	var pos = get_next_slot()
	if pos == Vector3.ZERO:
		return false

	obj.global_position = pos
	placed_objects.append(obj)

	# Disable physics on placed objects so they stay put
	if obj is RigidBody3D:
		obj.freeze = true

	object_placed.emit(get_display_name(), slot_num)
	return true


## Remove an object from this surface
func remove_object(obj: Node3D) -> void:
	var idx = placed_objects.find(obj)
	if idx >= 0:
		placed_objects.remove_at(idx)
		occupied_slots.remove_at(idx)
		if obj is RigidBody3D:
			obj.freeze = false


func _calculate_slot_position(index: int) -> Vector3:
	match surface_type:
		"desk", "shelf":
			# Grid layout on a flat surface
			var cols = ceili(sqrt(float(capacity)))
			var row = index / cols
			var col = index % cols
			return Vector3(
				(col - cols / 2.0) * slot_spacing,
				0.05,  # Slightly above surface
				(row - cols / 2.0) * slot_spacing,
			)
		"wall", "notice_board", "picture_frame", "chalkboard":
			# Vertical grid
			var cols = ceili(sqrt(float(capacity)))
			var row = index / cols
			var col = index % cols
			return Vector3(
				(col - cols / 2.0) * slot_spacing,
				-(row - cols / 2.0) * slot_spacing,
				0.02,  # Slightly in front of wall
			)
		"pedestal":
			# Single item, centred
			return Vector3(0, 0.1, 0)
		"floor":
			# Spread out more
			var angle: float = index * TAU / max(capacity, 1)
			var radius: float = 0.5 + index * 0.1
			return Vector3(cos(angle) * radius, 0.05, sin(angle) * radius)
		_:
			return Vector3(index * slot_spacing, 0.05, 0)


## How many slots are free
func available_slots() -> int:
	return capacity - placed_objects.size()


## Is this surface full
func is_full() -> bool:
	return placed_objects.size() >= capacity
