## CatAnimation — maps brain states to procedural animation intensities
## Bridges CatBrain state changes to CatProcedural micro-animation presets
## Also handles approval ritual sequences (stretch, proud sit, tail flag)
extends Node

var _procedural: Node = null
var _brain: Node = null
var _ritual_tween: Tween = null

# Preset table: state -> procedural method name
const STATE_PRESETS: Dictionary = {
	0: "set_idle",        # IDLE
	1: "set_walking",     # WANDERING
	2: "set_leading",     # LEADING
	3: "set_hissing",     # HISSING
	4: "set_napping",     # NAPPING
	5: "set_following",   # FOLLOWING
	6: "set_celebrating", # CELEBRATING
	7: "set_idle",        # PERCHING
}

# Approval ritual types
enum Ritual { STRETCH, PROUD_SIT, TAIL_FLAG, CIRCLE_SETTLE }


func setup(brain: Node, procedural: Node) -> void:
	_brain = brain
	_procedural = procedural
	if _brain:
		_brain.state_changed.connect(_on_state_changed)


func _on_state_changed(new_state: int) -> void:
	if not _procedural:
		return
	var method: String = STATE_PRESETS.get(new_state, "set_idle")
	if _procedural.has_method(method):
		_procedural.call(method)

	# Special overrides for specific states
	match new_state:
		6:  # CELEBRATING — play an approval ritual
			_play_approval_ritual()
		7:  # PERCHING — extra calm
			_procedural.tail_intensity = 0.15
			_procedural.breathing_intensity = 1.0
			_procedural.blink_intensity = 1.0
			_procedural.head_track_intensity = 0.8


## Play one of several celebration sequences using procedural animation
func _play_approval_ritual() -> void:
	if not _procedural:
		return

	# Cancel any existing ritual
	if _ritual_tween:
		_ritual_tween.kill()

	# Pick a random ritual
	var ritual: int = randi() % 4

	_ritual_tween = _procedural.create_tween()

	match ritual:
		Ritual.STRETCH:
			# The Stretch of Approval: tail up, body stretch, settle
			_ritual_tween.tween_callback(func():
				_procedural.tail_intensity = 0.9
				_procedural.breathing_intensity = 1.5
			)
			_ritual_tween.tween_interval(0.8)
			_ritual_tween.tween_callback(func():
				_procedural.tail_intensity = 0.3
				_procedural.breathing_intensity = 1.0
				_procedural.blink_intensity = 1.0
			)

		Ritual.PROUD_SIT:
			# Proud sit: stop, tail wrap, slow blink
			_ritual_tween.tween_callback(func():
				_procedural.tail_intensity = 0.2
				_procedural.head_track_intensity = 1.0
				_procedural.blink_intensity = 1.5  # More frequent blinks
			)
			_ritual_tween.tween_interval(1.5)
			_ritual_tween.tween_callback(func():
				_procedural.blink_intensity = 0.8
			)

		Ritual.TAIL_FLAG:
			# Tail straight up, walk-by feeling
			_ritual_tween.tween_callback(func():
				_procedural.tail_intensity = 1.0
				_procedural.ear_intensity = 0.6
			)
			_ritual_tween.tween_interval(1.0)
			_ritual_tween.tween_callback(func():
				_procedural.tail_intensity = 0.5
			)

		Ritual.CIRCLE_SETTLE:
			# Circle once then settle — simulate by rapid tail + ear activity
			_ritual_tween.tween_callback(func():
				_procedural.tail_intensity = 0.8
				_procedural.ear_intensity = 0.7
				_procedural.breathing_intensity = 1.2
			)
			_ritual_tween.tween_interval(1.2)
			_ritual_tween.tween_callback(func():
				_procedural.tail_intensity = 0.15
				_procedural.ear_intensity = 0.1
				_procedural.breathing_intensity = 1.0
				_procedural.blink_intensity = 1.2
			)


## Play momentum burst when multiple tasks completed quickly
func play_momentum_burst() -> void:
	if not _procedural:
		return
	if _ritual_tween:
		_ritual_tween.kill()
	_ritual_tween = _procedural.create_tween()
	_ritual_tween.tween_callback(func():
		_procedural.tail_intensity = 1.0
		_procedural.ear_intensity = 0.8
		_procedural.breathing_intensity = 1.3
	)
	_ritual_tween.tween_interval(1.5)
	_ritual_tween.tween_callback(func():
		_procedural.set_idle()
	)
