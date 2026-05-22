## Unified cinematic camera for pitch-video room walkthroughs.
## One script for all rooms — set `room_key` per scene to pick the waypoint
## sequence. Auto-plays a ~30s glide on _ready; press R to replay.
##
## Replaces the former per-room cinematic_<theme>_camera.gd scripts.
## To tune a room's path, edit its entry in SEQUENCES below.
extends Camera3D

@export var room_key: String = ""
@export var auto_play: bool = true
@export var debug_replay_key: bool = true

# room_key -> Array of [time_at_seconds, position, look_at_target]
const SEQUENCES := {
	"library": [
		[0.0,  Vector3(4.5, 1.7, 2.5),   Vector3(0, 1.4, 0)],
		[6.0,  Vector3(2.0, 1.7, 2.5),   Vector3(-2, 1.4, -3)],
		[12.0, Vector3(0,   1.7, 1.5),   Vector3(0, 1.5, -3)],
		[18.0, Vector3(0,   1.5, -1.5),  Vector3(0, 1.4, -5)],
		[24.0, Vector3(0,   1.2, -3.0),  Vector3(0, 1.55, -5)],
		[30.0, Vector3(1.5, 1.2, -3.0),  Vector3(0, 1.55, -5)],
	],
	"garden": [
		[0.0,  Vector3(0.0,  1.7, -6.0),  Vector3(0, 0.8, 0)],
		[8.0,  Vector3(0.0,  1.6, -2.8),  Vector3(0, 0.7, 0)],
		[16.0, Vector3(2.6,  1.4,  0.0),  Vector3(0, 0.7, 0)],
		[24.0, Vector3(2.0,  2.3,  3.2),  Vector3(0, 1.2, 0)],
		[30.0, Vector3(-3.2, 1.8,  4.2),  Vector3(0, 1.0, -1)],
	],
	"study": [
		[0.0,  Vector3(-3.0, 1.6,  2.0),  Vector3(0, 1.0, -3)],
		[8.0,  Vector3(-1.0, 1.5, -0.3),  Vector3(0, 0.9, -3)],
		[16.0, Vector3(0.4,  1.25, -1.4), Vector3(0, 0.85, -3)],
		[22.0, Vector3(0.0,  1.8, -1.0),  Vector3(0, 3.3, 0)],
		[30.0, Vector3(2.2,  1.6,  1.2),  Vector3(0, 1.2, -2)],
	],
	"bedroom": [
		[0.0,  Vector3(0.0,  1.6,  3.0),  Vector3(-1.5, 1.0, -2)],
		[8.0,  Vector3(0.0,  1.45, 0.6),  Vector3(-2.0, 0.8, -2.5)],
		[16.0, Vector3(-1.4, 1.2, -0.4),  Vector3(-2.5, 0.5, -2.5)],
		[22.0, Vector3(0.2,  1.5, -1.0),  Vector3(2.5, 1.1, 2.0)],
		[30.0, Vector3(1.6,  1.6,  1.6),  Vector3(-1.0, 1.0, -2)],
	],
	"kitchen": [
		[0.0,  Vector3(2.5,  1.7,  3.0),  Vector3(-3, 1.2, -1)],
		[8.0,  Vector3(0.0,  1.6,  1.0),  Vector3(-3.5, 1.0, -1.5)],
		[16.0, Vector3(-1.5, 1.5, -0.5),  Vector3(-3.5, 1.2, -2.5)],
		[22.0, Vector3(0.5,  1.6,  0.5),  Vector3(1.5, 0.9, 1.5)],
		[30.0, Vector3(2.8,  1.6,  2.8),  Vector3(0.5, 1.0, 0)],
	],
	"cellar": [
		[0.0,  Vector3(0.0,  1.7, -3.5),  Vector3(0, 1.2, 0)],
		[8.0,  Vector3(0.0,  1.6, -1.0),  Vector3(-2.5, 1.5, -2)],
		[16.0, Vector3(0.5,  1.4,  1.0),  Vector3(0, 0.7, 0)],
		[22.0, Vector3(-1.0, 1.6,  1.5),  Vector3(0, 2.8, 0)],
		[30.0, Vector3(2.0,  1.6,  2.5),  Vector3(-1, 1.0, 0)],
	],
	"treasury": [
		[0.0,  Vector3(0.0,  1.6,  2.0),  Vector3(0, 1.1, 0)],
		[8.0,  Vector3(1.5,  1.4,  0.6),  Vector3(0, 1.0, 0)],
		[16.0, Vector3(-1.5, 1.3, -0.4),  Vector3(-2, 0.7, -1.5)],
		[22.0, Vector3(0.0,  1.5,  0.6),  Vector3(0, 1.1, 0)],
		[30.0, Vector3(1.6,  1.5,  1.8),  Vector3(0, 1.0, 0)],
	],
	"gymnasium": [
		[0.0,  Vector3(0.0,  1.7,  4.5),  Vector3(0, 1.5, -4)],
		[8.0,  Vector3(-3.0, 1.6,  1.0),  Vector3(-5, 1.2, 0)],
		[16.0, Vector3(0.0,  1.5, -1.0),  Vector3(0, 1.6, -5.5)],
		[22.0, Vector3(2.5,  2.0,  1.0),  Vector3(4, 1.0, 3)],
		[30.0, Vector3(3.5,  1.7,  4.0),  Vector3(-1, 1.3, -2)],
	],
	"workshop": [
		[0.0,  Vector3(0.0,  1.7,  3.0),  Vector3(0, 1.0, -3.5)],
		[8.0,  Vector3(0.0,  1.5, -1.0),  Vector3(0, 0.9, -3.5)],
		[16.0, Vector3(1.5,  1.4, -1.0),  Vector3(4.5, 1.5, 0)],
		[22.0, Vector3(-1.0, 1.6,  1.0),  Vector3(-2, 0.5, 2.5)],
		[30.0, Vector3(2.0,  1.7,  2.5),  Vector3(0, 1.0, -2)],
	],
	"foyer": [
		[0.0,  Vector3(0.0,  1.8,  4.0),  Vector3(0, 1.4, -3)],
		[8.0,  Vector3(0.0,  1.7,  1.0),  Vector3(0, 1.0, -3)],
		[16.0, Vector3(-2.0, 1.6,  0.0),  Vector3(-5, 1.2, -2)],
		[22.0, Vector3(1.0,  2.2,  0.0),  Vector3(0, 3.6, 0)],
		[30.0, Vector3(2.5,  1.7,  2.5),  Vector3(0, 1.2, -3)],
	],
}

var look_target: Vector3 = Vector3.ZERO
var _seq: Array = []


func _ready() -> void:
	current = true
	_seq = SEQUENCES.get(room_key, [])
	if _seq.size() == 0:
		push_warning("CinematicCamera: no sequence for room_key '%s'" % room_key)
		return
	global_position = _seq[0][1]
	look_target = _seq[0][2]
	if auto_play:
		await get_tree().create_timer(0.4).timeout
		play_sequence()


func play_sequence() -> void:
	if _seq.size() < 2:
		return
	var pos_tween := create_tween().set_trans(Tween.TRANS_SINE)
	var look_tween := create_tween().set_trans(Tween.TRANS_SINE)

	global_position = _seq[0][1]
	look_target = _seq[0][2]

	var prev_time: float = _seq[0][0]
	for i in range(1, _seq.size()):
		var kf = _seq[i]
		var dur: float = kf[0] - prev_time
		pos_tween.tween_property(self, "global_position", kf[1], dur)
		look_tween.tween_property(self, "look_target", kf[2], dur)
		prev_time = kf[0]


func _process(_delta: float) -> void:
	if look_target != global_position:
		look_at(look_target, Vector3.UP)


func _input(event: InputEvent) -> void:
	if not debug_replay_key:
		return
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_R:
			play_sequence()
