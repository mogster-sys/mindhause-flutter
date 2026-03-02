## TaskObject — a physical representation of a task in the palace
## Spawns as one of 10 object types, evolves visually based on monster state
## Interactable via reticule / tap
extends RigidBody3D

signal task_selected(task_id: String)
signal task_completed(task_id: String)

@export var task_id: String = ""
@export var object_type: String = "scroll"  # scroll, book, candle, statue, letter, blueprint, plant, post_it, jar, key

# Data from database
var task_data: Dictionary = {}

# Visual states
enum VisualState { HEALTHY, NEGLECTED, CORRUPTING, MONSTER }
var visual_state: VisualState = VisualState.HEALTHY

# Child nodes (set up based on object_type)
var _mesh: MeshInstance3D = null
var _glow: OmniLight3D = null
var _particles: GPUParticles3D = null
var _collision: CollisionShape3D = null

# Priority glow colours
const GLOW_LOW := Color(0.41, 0.64, 0.34)     # olive green
const GLOW_NORMAL := Color(0.83, 0.66, 0.26)   # bronze gold
const GLOW_HIGH := Color(0.75, 0.22, 0.17)     # urgent red
const GLOW_MONSTER := Color(0.6, 0.0, 0.0)     # deep red

# Monster visual params
const MONSTER_SCALE_MULT := 1.5
const CORRUPTION_WOBBLE := 0.02


func _ready() -> void:
	add_to_group("task_objects")
	contact_monitor = true
	max_contacts_reported = 1

	_setup_visual()
	_load_task_data()


func _process(delta: float) -> void:
	if visual_state == VisualState.CORRUPTING:
		# Subtle wobble effect
		rotation.y += sin(Time.get_ticks_msec() * 0.003) * CORRUPTION_WOBBLE * delta
	elif visual_state == VisualState.MONSTER:
		# More aggressive pulsing
		if _glow:
			_glow.light_energy = 1.5 + sin(Time.get_ticks_msec() * 0.005) * 0.5


func _setup_visual() -> void:
	# Create base mesh based on object type
	_mesh = MeshInstance3D.new()
	_collision = CollisionShape3D.new()

	match object_type:
		"scroll":
			_mesh.mesh = CylinderMesh.new()
			_mesh.mesh.top_radius = 0.03
			_mesh.mesh.bottom_radius = 0.03
			_mesh.mesh.height = 0.25
			_mesh.rotation_degrees.z = 90
			var shape := CylinderShape3D.new()
			shape.radius = 0.03
			shape.height = 0.25
			_collision.shape = shape
		"book":
			_mesh.mesh = BoxMesh.new()
			_mesh.mesh.size = Vector3(0.15, 0.22, 0.04)
			var shape := BoxShape3D.new()
			shape.size = Vector3(0.15, 0.22, 0.04)
			_collision.shape = shape
		"candle":
			_mesh.mesh = CylinderMesh.new()
			_mesh.mesh.top_radius = 0.015
			_mesh.mesh.bottom_radius = 0.02
			_mesh.mesh.height = 0.15
			var shape := CylinderShape3D.new()
			shape.radius = 0.02
			shape.height = 0.15
			_collision.shape = shape
		"key":
			_mesh.mesh = BoxMesh.new()
			_mesh.mesh.size = Vector3(0.06, 0.02, 0.12)
			var shape := BoxShape3D.new()
			shape.size = Vector3(0.06, 0.02, 0.12)
			_collision.shape = shape
		_:
			# Default: small sphere
			_mesh.mesh = SphereMesh.new()
			_mesh.mesh.radius = 0.08
			_mesh.mesh.height = 0.16
			var shape := SphereShape3D.new()
			shape.radius = 0.08
			_collision.shape = shape

	add_child(_mesh)
	add_child(_collision)

	# Priority glow light
	_glow = OmniLight3D.new()
	_glow.light_color = GLOW_NORMAL
	_glow.light_energy = 0.3
	_glow.omni_range = 1.0
	_glow.shadow_enabled = false
	add_child(_glow)


func _load_task_data() -> void:
	if task_id.is_empty():
		return
	task_data = DatabaseBridge.get_task_by_id(task_id)
	if task_data.is_empty():
		return

	_apply_priority_glow()
	_apply_monster_state()


func _apply_priority_glow() -> void:
	if not _glow:
		return
	var priority: String = task_data.get("priority", "normal")
	match priority:
		"high":
			_glow.light_color = GLOW_HIGH
			_glow.light_energy = 0.6
		"low":
			_glow.light_color = GLOW_LOW
			_glow.light_energy = 0.2
		_:
			_glow.light_color = GLOW_NORMAL
			_glow.light_energy = 0.3


func _apply_monster_state() -> void:
	var state: String = task_data.get("monster_state", "none")
	match state:
		"neglected":
			visual_state = VisualState.NEGLECTED
			# Slight colour desaturation
			if _mesh and _mesh.mesh:
				var mat := StandardMaterial3D.new()
				mat.albedo_color = Color(0.6, 0.55, 0.5)
				_mesh.material_override = mat
		"corrupting":
			visual_state = VisualState.CORRUPTING
			if _mesh and _mesh.mesh:
				var mat := StandardMaterial3D.new()
				mat.albedo_color = Color(0.4, 0.3, 0.3)
				mat.emission_enabled = true
				mat.emission = Color(0.5, 0.1, 0.1)
				mat.emission_energy_multiplier = 0.3
				_mesh.material_override = mat
			if _glow:
				_glow.light_color = Color(0.6, 0.2, 0.1)
		"monster":
			visual_state = VisualState.MONSTER
			# Scale up and go red
			scale *= MONSTER_SCALE_MULT
			if _mesh and _mesh.mesh:
				var mat := StandardMaterial3D.new()
				mat.albedo_color = Color(0.3, 0.1, 0.1)
				mat.emission_enabled = true
				mat.emission = GLOW_MONSTER
				mat.emission_energy_multiplier = 0.8
				_mesh.material_override = mat
			if _glow:
				_glow.light_color = GLOW_MONSTER
				_glow.light_energy = 1.5
				_glow.omni_range = 2.5
			_spawn_monster_particles()
		_:
			visual_state = VisualState.HEALTHY


func _spawn_monster_particles() -> void:
	_particles = GPUParticles3D.new()
	var particle_mat := ParticleProcessMaterial.new()
	particle_mat.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_SPHERE
	particle_mat.emission_sphere_radius = 0.3
	particle_mat.gravity = Vector3(0, 0.5, 0)
	particle_mat.initial_velocity_min = 0.2
	particle_mat.initial_velocity_max = 0.5
	particle_mat.color = Color(0.4, 0.0, 0.0, 0.6)
	particle_mat.scale_min = 0.02
	particle_mat.scale_max = 0.06
	_particles.process_material = particle_mat
	_particles.amount = 12
	_particles.lifetime = 2.0
	add_child(_particles)


## Called by player interaction
func interact() -> void:
	AudioManager.play_sfx("task_pickup")
	task_selected.emit(task_id)
	DatabaseBridge.update_task_interaction(task_id)
	GameState.task_interacted.emit(task_id)


## Called by HUD reticule
func get_task_data() -> Dictionary:
	return task_data


## Mark this task complete (called from UI or interaction)
func complete() -> void:
	if visual_state == VisualState.MONSTER:
		AudioManager.play_sfx("monster_defeat")
	DatabaseBridge.complete_task(task_id)
	task_completed.emit(task_id)
	# Play completion effect then remove
	_play_completion_effect()


func _play_completion_effect() -> void:
	AudioManager.play_sfx("task_complete")
	if _glow:
		var tween := create_tween()
		tween.tween_property(_glow, "light_energy", 3.0, 0.3)
		tween.tween_property(_glow, "light_energy", 0.0, 0.5)
		tween.tween_callback(queue_free)
