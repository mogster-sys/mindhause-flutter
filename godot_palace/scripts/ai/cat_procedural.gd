## CatProcedural — drives micro-animations on the primitive cat mesh
## Channels: tail sway, ear twitch, slow blink, breathing, head tracking
## Supports two modes:
##   Primitive: drives Node3D transforms on the built-in sphere/cylinder mesh
##   Skeleton: drives Skeleton3D bone pose rotations on a loaded GLB model
extends Node

# Intensity controls (set by cat_companion or cat_animation)
var tail_intensity: float = 0.5
var ear_intensity: float = 0.3
var blink_intensity: float = 1.0
var breathing_intensity: float = 1.0
var head_track_intensity: float = 0.6

# Internal state
var _time: float = 0.0
var _blink_timer: float = 0.0
var _blink_duration: float = 0.0
var _is_blinking: bool = false
var _ear_twitch_timer: float = 0.0
var _ear_twitch_target_l: float = 0.0
var _ear_twitch_target_r: float = 0.0
var _ear_twitch_current_l: float = 0.0
var _ear_twitch_current_r: float = 0.0

# --- Primitive mode: cached node references ---
var _head: Node3D
var _ear_l: Node3D
var _ear_r: Node3D
var _eye_l: MeshInstance3D
var _eye_r: MeshInstance3D
var _tail_base: Node3D
var _tail_mid: Node3D
var _tail_tip: Node3D
var _body: MeshInstance3D
var _cat_mesh: Node3D
var _player_ref: CharacterBody3D = null

# --- Skeleton mode ---
var _use_skeleton: bool = false
var _skeleton: Skeleton3D = null

# Bone indices — -1 means not found
var _bone_head: int = -1
var _bone_neck: int = -1
var _bone_ear_l: int = -1
var _bone_ear_r: int = -1
var _bone_tail_base: int = -1
var _bone_tail_mid: int = -1
var _bone_tail_tip: int = -1
var _bone_spine: int = -1
var _bone_chest: int = -1
var _bone_leg_fl_upper: int = -1
var _bone_leg_fl_lower: int = -1
var _bone_leg_fr_upper: int = -1
var _bone_leg_fr_lower: int = -1
var _bone_leg_bl_upper: int = -1
var _bone_leg_bl_lower: int = -1
var _bone_leg_br_upper: int = -1
var _bone_leg_br_lower: int = -1

# Eye mesh nodes found inside the GLB (for blink in skeleton mode)
var _skel_eye_l: MeshInstance3D = null
var _skel_eye_r: MeshInstance3D = null

# Bone name lookup table — tries multiple naming conventions per logical bone
var _bone_name_map: Dictionary = {
	"Head": ["Head", "head", "DEF-Head", "DEF-head"],
	"Neck": ["Neck", "neck", "DEF-Neck"],
	"EarL": ["EarL", "Ear.L", "ear_l", "DEF-Ear.L", "ear.L"],
	"EarR": ["EarR", "Ear.R", "ear_r", "DEF-Ear.R", "ear.R"],
	"TailBase": ["TailBase", "Tail", "tail_01", "DEF-Tail", "tail.001"],
	"TailMid": ["TailMid", "Tail.001", "tail_02", "DEF-Tail.001", "tail.002"],
	"TailTip": ["TailTip", "Tail.002", "tail_03", "DEF-Tail.002", "tail.003"],
	"Spine": ["Spine", "spine", "DEF-Spine"],
	"Chest": ["Chest", "chest", "Spine1", "DEF-Spine.001"],
	"LegFL_Upper": ["ScapulaL", "FrontLegL", "UpperLeg.L.Front", "FrontUpperLeg.L",
		"front_upper_leg_l", "DEF-FrontUpperLeg.L", "F_UpperLeg.L", "shoulder.L"],
	"LegFL_Lower": ["FrontKneeL", "LowerLeg.L.Front", "FrontLowerLeg.L",
		"front_lower_leg_l", "DEF-FrontLowerLeg.L", "F_LowerLeg.L", "forearm.L"],
	"LegFR_Upper": ["ScapulaR", "FrontLegR", "UpperLeg.R.Front", "FrontUpperLeg.R",
		"front_upper_leg_r", "DEF-FrontUpperLeg.R", "F_UpperLeg.R", "shoulder.R"],
	"LegFR_Lower": ["FrontKneeR", "LowerLeg.R.Front", "FrontLowerLeg.R",
		"front_lower_leg_r", "DEF-FrontLowerLeg.R", "F_LowerLeg.R", "forearm.R"],
	"LegBL_Upper": ["HipL", "BackLegL", "UpperLeg.L.Back", "BackUpperLeg.L",
		"back_upper_leg_l", "DEF-BackUpperLeg.L", "B_UpperLeg.L", "thigh.L"],
	"LegBL_Lower": ["BackKneeL", "LowerLeg.L.Back", "BackLowerLeg.L",
		"back_lower_leg_l", "DEF-BackLowerLeg.L", "B_LowerLeg.L", "shin.L"],
	"LegBR_Upper": ["HipR", "BackLegR", "UpperLeg.R.Back", "BackUpperLeg.R",
		"back_upper_leg_r", "DEF-BackUpperLeg.R", "B_UpperLeg.R", "thigh.R"],
	"LegBR_Lower": ["BackKneeR", "LowerLeg.R.Back", "BackLowerLeg.R",
		"back_lower_leg_r", "DEF-BackLowerLeg.R", "B_LowerLeg.R", "shin.R"],
}


func setup(cat_mesh: Node3D) -> void:
	_cat_mesh = cat_mesh
	_use_skeleton = false
	_skeleton = null
	_skel_eye_l = null
	_skel_eye_r = null

	_head = cat_mesh.get_node_or_null("Head")
	_ear_l = cat_mesh.get_node_or_null("Head/EarL")
	_ear_r = cat_mesh.get_node_or_null("Head/EarR")
	_eye_l = cat_mesh.get_node_or_null("Head/EyeL")
	_eye_r = cat_mesh.get_node_or_null("Head/EyeR")
	_tail_base = cat_mesh.get_node_or_null("TailBase")
	_tail_mid = cat_mesh.get_node_or_null("TailBase/TailMid")
	_tail_tip = cat_mesh.get_node_or_null("TailBase/TailMid/TailTip")
	_body = cat_mesh.get_node_or_null("Body")

	# Randomise initial timers so multiple cats don't sync
	_blink_timer = randf_range(3.0, 8.0)
	_ear_twitch_timer = randf_range(1.0, 4.0)


func setup_skeleton(skeleton: Skeleton3D, eye_l: MeshInstance3D = null, eye_r: MeshInstance3D = null) -> void:
	_skeleton = skeleton
	_use_skeleton = true
	_skel_eye_l = eye_l
	_skel_eye_r = eye_r

	# Cache bone indices
	_bone_head = _find_bone("Head")
	_bone_neck = _find_bone("Neck")
	_bone_ear_l = _find_bone("EarL")
	_bone_ear_r = _find_bone("EarR")
	_bone_tail_base = _find_bone("TailBase")
	_bone_tail_mid = _find_bone("TailMid")
	_bone_tail_tip = _find_bone("TailTip")
	_bone_spine = _find_bone("Spine")
	_bone_chest = _find_bone("Chest")
	_bone_leg_fl_upper = _find_bone("LegFL_Upper")
	_bone_leg_fl_lower = _find_bone("LegFL_Lower")
	_bone_leg_fr_upper = _find_bone("LegFR_Upper")
	_bone_leg_fr_lower = _find_bone("LegFR_Lower")
	_bone_leg_bl_upper = _find_bone("LegBL_Upper")
	_bone_leg_bl_lower = _find_bone("LegBL_Lower")
	_bone_leg_br_upper = _find_bone("LegBR_Upper")
	_bone_leg_br_lower = _find_bone("LegBR_Lower")

	# Randomise initial timers
	_blink_timer = randf_range(3.0, 8.0)
	_ear_twitch_timer = randf_range(1.0, 4.0)

	# Log which bones were found for debugging
	var found_bones: PackedStringArray = []
	var missing_bones: PackedStringArray = []
	for key in _bone_name_map.keys():
		var idx = _find_bone(key)
		if idx >= 0:
			found_bones.append(key)
		else:
			missing_bones.append(key)
	if found_bones.size() > 0:
		print("CatProcedural: Skeleton mode — found bones: ", ", ".join(found_bones))
	if missing_bones.size() > 0:
		print("CatProcedural: Skeleton mode — missing bones: ", ", ".join(missing_bones))


## Search the skeleton for a bone matching any of the naming conventions
func _find_bone(logical_name: String) -> int:
	if not _skeleton:
		return -1
	var candidates: Array = _bone_name_map.get(logical_name, [])
	for bone_name in candidates:
		var idx = _skeleton.find_bone(bone_name)
		if idx >= 0:
			return idx
	return -1


func set_player(player: CharacterBody3D) -> void:
	_player_ref = player


func _process(delta: float) -> void:
	if _use_skeleton:
		if not _skeleton or not is_instance_valid(_skeleton):
			return
	else:
		if not _cat_mesh or not _cat_mesh.visible:
			return

	_time += delta
	_process_tail_sway(delta)
	_process_ear_twitch(delta)
	_process_slow_blink(delta)
	_process_breathing(delta)
	_process_head_tracking(delta)


# --- Tail Sway ---
# Sinusoidal rotation cascading through 3 tail segments
func _process_tail_sway(_delta: float) -> void:
	var amp: float = tail_intensity * 0.3  # max ~17 degrees
	var speed: float = 2.0 + tail_intensity * 3.0  # faster when excited

	if _use_skeleton:
		if _bone_tail_base >= 0:
			var rot_x: float = sin(_time * speed) * amp * 0.5
			var rot_z: float = sin(_time * speed * 0.7) * amp
			_skeleton.set_bone_pose_rotation(_bone_tail_base,
				Quaternion.from_euler(Vector3(rot_x, 0.0, rot_z)))
		if _bone_tail_mid >= 0:
			var rot_z: float = sin(_time * speed + 0.8) * amp * 1.2
			_skeleton.set_bone_pose_rotation(_bone_tail_mid,
				Quaternion.from_euler(Vector3(0.0, 0.0, rot_z)))
		if _bone_tail_tip >= 0:
			var rot_z: float = sin(_time * speed + 1.6) * amp * 1.5
			_skeleton.set_bone_pose_rotation(_bone_tail_tip,
				Quaternion.from_euler(Vector3(0.0, 0.0, rot_z)))
	else:
		# Primitive mode
		if not _tail_base:
			return
		if _tail_base:
			_tail_base.rotation.x = sin(_time * speed) * amp * 0.5
			_tail_base.rotation.z = sin(_time * speed * 0.7) * amp
		if _tail_mid:
			_tail_mid.rotation.z = sin(_time * speed + 0.8) * amp * 1.2
		if _tail_tip:
			_tail_tip.rotation.z = sin(_time * speed + 1.6) * amp * 1.5


# --- Ear Twitch ---
# Random small rotations every few seconds
func _process_ear_twitch(delta: float) -> void:
	_ear_twitch_timer -= delta
	if _ear_twitch_timer <= 0:
		_ear_twitch_timer = randf_range(2.0, 6.0) / max(ear_intensity, 0.1)
		# Pick new twitch targets
		if randf() < 0.4:
			# Both ears
			var angle: float = randf_range(-0.25, 0.25) * ear_intensity
			_ear_twitch_target_l = angle
			_ear_twitch_target_r = angle
		else:
			# One ear
			_ear_twitch_target_l = randf_range(-0.3, 0.3) * ear_intensity
			_ear_twitch_target_r = randf_range(-0.3, 0.3) * ear_intensity

	# Lerp toward targets
	_ear_twitch_current_l = lerp(_ear_twitch_current_l, _ear_twitch_target_l, delta * 8.0)
	_ear_twitch_current_r = lerp(_ear_twitch_current_r, _ear_twitch_target_r, delta * 8.0)

	if _use_skeleton:
		if _bone_ear_l >= 0:
			_skeleton.set_bone_pose_rotation(_bone_ear_l,
				Quaternion.from_euler(Vector3(_ear_twitch_current_l, 0.0, _ear_twitch_current_l * 0.5)))
		if _bone_ear_r >= 0:
			_skeleton.set_bone_pose_rotation(_bone_ear_r,
				Quaternion.from_euler(Vector3(_ear_twitch_current_r, 0.0, -_ear_twitch_current_r * 0.5)))
	else:
		# Primitive mode
		if not _ear_l or not _ear_r:
			return
		_ear_l.rotation.x = _ear_twitch_current_l
		_ear_l.rotation.z = _ear_twitch_current_l * 0.5
		_ear_r.rotation.x = _ear_twitch_current_r
		_ear_r.rotation.z = -_ear_twitch_current_r * 0.5


# --- Slow Blink ---
# Scale eyes Y to 0 and back, cat-smile
func _process_slow_blink(delta: float) -> void:
	if _use_skeleton:
		# In skeleton mode, try scaling eye mesh nodes if we have them.
		# If no eye meshes were found in the GLB, skip blinking entirely.
		if not _skel_eye_l and not _skel_eye_r:
			return
		_process_slow_blink_meshes(delta, _skel_eye_l, _skel_eye_r)
	else:
		# Primitive mode
		if not _eye_l or not _eye_r:
			return
		_process_slow_blink_meshes(delta, _eye_l, _eye_r)


## Shared blink logic that works on any pair of MeshInstance3D eye nodes
func _process_slow_blink_meshes(delta: float, eye_l: MeshInstance3D, eye_r: MeshInstance3D) -> void:
	if _is_blinking:
		_blink_duration -= delta
		if _blink_duration <= 0:
			_is_blinking = false
			if eye_l:
				eye_l.scale.y = 1.0
			if eye_r:
				eye_r.scale.y = 1.0
			_blink_timer = randf_range(4.0, 10.0) / max(blink_intensity, 0.1)
		else:
			# Close-open cycle: close for first half, open for second
			var half: float = 0.2
			if _blink_duration > half:
				# Closing
				var t: float = 1.0 - (_blink_duration - half) / half
				if eye_l:
					eye_l.scale.y = lerp(1.0, 0.05, t)
				if eye_r:
					eye_r.scale.y = lerp(1.0, 0.05, t)
			else:
				# Opening
				var t: float = 1.0 - _blink_duration / half
				if eye_l:
					eye_l.scale.y = lerp(0.05, 1.0, t)
				if eye_r:
					eye_r.scale.y = lerp(0.05, 1.0, t)
	else:
		_blink_timer -= delta
		if _blink_timer <= 0:
			_is_blinking = true
			_blink_duration = 0.4


# --- Breathing ---
# Subtle body/bone scale pulse
func _process_breathing(_delta: float) -> void:
	var breath: float = sin(_time * 1.5) * 0.02 * breathing_intensity

	if _use_skeleton:
		# Modulate Spine/Chest bone scale slightly for a breathing effect
		if _bone_spine >= 0:
			_skeleton.set_bone_pose_scale(_bone_spine,
				Vector3(1.0, 1.0 + breath, 1.0))
		if _bone_chest >= 0:
			_skeleton.set_bone_pose_scale(_bone_chest,
				Vector3(1.0, 1.0 + breath * 0.7, 1.0))
	else:
		# Primitive mode
		if not _body:
			return
		_body.scale.y = 1.0 + breath
		# Slight position offset to keep feet planted
		_body.position.y = 0.05 + breath * 0.5


# --- Head Tracking ---
# Head looks toward player when within range
func _process_head_tracking(delta: float) -> void:
	if head_track_intensity <= 0:
		return

	if _use_skeleton:
		_process_head_tracking_skeleton(delta)
	else:
		_process_head_tracking_primitive(delta)


func _process_head_tracking_primitive(delta: float) -> void:
	if not _head:
		return

	if not _player_ref or not is_instance_valid(_player_ref):
		# Return head to forward
		_head.rotation = _head.rotation.lerp(Vector3.ZERO, delta * 3.0)
		return

	var cat_pos: Vector3 = _cat_mesh.global_position
	var player_pos: Vector3 = _player_ref.global_position
	var dist = cat_pos.distance_to(player_pos)

	if dist > 4.0 or dist < 0.3:
		# Too far or too close — return to neutral
		_head.rotation = _head.rotation.lerp(Vector3.ZERO, delta * 2.0)
		return

	# Calculate direction to player in cat's local space
	var dir_world = (player_pos - cat_pos).normalized()
	var cat_parent = _cat_mesh.get_parent() as Node3D
	if not cat_parent:
		return

	# Convert to local direction relative to cat's facing
	var local_dir = cat_parent.global_transform.basis.inverse() * dir_world

	# Yaw (left/right) and pitch (up/down) — clamped
	var target_yaw: float = clamp(atan2(-local_dir.x, -local_dir.z), -0.6, 0.6)
	var target_pitch: float = clamp(atan2(local_dir.y, Vector2(local_dir.x, local_dir.z).length()), -0.3, 0.4)

	var lerp_speed: float = delta * 3.0 * head_track_intensity
	_head.rotation.y = lerp(_head.rotation.y, target_yaw, lerp_speed)
	_head.rotation.x = lerp(_head.rotation.x, target_pitch, lerp_speed)


func _process_head_tracking_skeleton(delta: float) -> void:
	if _bone_head < 0:
		return

	var identity_quat: Quaternion = Quaternion.IDENTITY
	var lerp_speed: float = delta * 3.0 * head_track_intensity

	if not _player_ref or not is_instance_valid(_player_ref):
		# Return head and neck to rest pose
		var current = _skeleton.get_bone_pose_rotation(_bone_head)
		_skeleton.set_bone_pose_rotation(_bone_head, current.slerp(identity_quat, delta * 3.0))
		if _bone_neck >= 0:
			var neck_current = _skeleton.get_bone_pose_rotation(_bone_neck)
			_skeleton.set_bone_pose_rotation(_bone_neck, neck_current.slerp(identity_quat, delta * 3.0))
		return

	# Get world positions
	var cat_root = _skeleton.get_parent() as Node3D
	if not cat_root:
		cat_root = _skeleton
	var cat_pos: Vector3 = cat_root.global_position
	var player_pos: Vector3 = _player_ref.global_position
	var dist = cat_pos.distance_to(player_pos)

	if dist > 4.0 or dist < 0.3:
		# Too far or too close — return to neutral
		var current = _skeleton.get_bone_pose_rotation(_bone_head)
		_skeleton.set_bone_pose_rotation(_bone_head, current.slerp(identity_quat, delta * 2.0))
		if _bone_neck >= 0:
			var neck_current = _skeleton.get_bone_pose_rotation(_bone_neck)
			_skeleton.set_bone_pose_rotation(_bone_neck, neck_current.slerp(identity_quat, delta * 2.0))
		return

	# Calculate direction to player in skeleton's local space
	var dir_world = (player_pos - cat_pos).normalized()
	var local_dir = cat_root.global_transform.basis.inverse() * dir_world

	# Yaw (left/right) and pitch (up/down) — clamped
	var target_yaw: float = clamp(atan2(-local_dir.x, -local_dir.z), -0.6, 0.6)
	var target_pitch: float = clamp(atan2(local_dir.y, Vector2(local_dir.x, local_dir.z).length()), -0.3, 0.4)

	# Head gets full rotation
	var target_head: Quaternion = Quaternion.from_euler(Vector3(target_pitch, target_yaw, 0.0))
	var current_head = _skeleton.get_bone_pose_rotation(_bone_head)
	_skeleton.set_bone_pose_rotation(_bone_head, current_head.slerp(target_head, lerp_speed))

	# Neck gets a fraction of the rotation for natural look
	if _bone_neck >= 0:
		var target_neck = Quaternion.from_euler(Vector3(target_pitch * 0.3, target_yaw * 0.4, 0.0))
		var current_neck = _skeleton.get_bone_pose_rotation(_bone_neck)
		_skeleton.set_bone_pose_rotation(_bone_neck, current_neck.slerp(target_neck, lerp_speed))


# --- State presets ---
# Called by the behaviour system to set animation mood

func set_idle() -> void:
	tail_intensity = 0.3
	ear_intensity = 0.2
	blink_intensity = 0.8
	breathing_intensity = 1.0
	head_track_intensity = 0.6


func set_walking() -> void:
	tail_intensity = 0.5
	ear_intensity = 0.4
	blink_intensity = 0.3
	breathing_intensity = 0.8
	head_track_intensity = 0.4


func set_celebrating() -> void:
	tail_intensity = 1.0
	ear_intensity = 0.6
	blink_intensity = 0.5
	breathing_intensity = 1.0
	head_track_intensity = 0.8


func set_hissing() -> void:
	tail_intensity = 0.9  # Puffed up, stiff wag
	ear_intensity = 0.8  # Ears flat
	blink_intensity = 0.0  # Wide eyes
	breathing_intensity = 1.2
	head_track_intensity = 0.0  # Staring at threat


func set_napping() -> void:
	tail_intensity = 0.1
	ear_intensity = 0.1
	blink_intensity = 0.0  # Eyes closed
	breathing_intensity = 1.0
	head_track_intensity = 0.0


func set_leading() -> void:
	tail_intensity = 0.7
	ear_intensity = 0.5
	blink_intensity = 0.4
	breathing_intensity = 0.9
	head_track_intensity = 0.3


func set_following() -> void:
	tail_intensity = 0.6
	ear_intensity = 0.3
	blink_intensity = 0.6
	breathing_intensity = 1.0
	head_track_intensity = 0.7
