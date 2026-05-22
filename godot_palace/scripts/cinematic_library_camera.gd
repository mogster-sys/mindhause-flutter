## Cinematic camera path for the Library pitch video.
## Auto-plays a 30-second slow glide on _ready when running the scene directly.
## Press R to replay, ESC to release the camera back to the player.
extends Camera3D

@export var auto_play: bool = true
@export var debug_replay_key: bool = true

# (time_at_seconds, position, look_at_target)
# Beats: 0=enter from foyer door, 6=sweep left bookshelf, 12=centre on bookshelves,
# 18=descend toward display, 24=close on statue+jar, 30=sideways pull final beat
const SEQUENCE := [
	[0.0,  Vector3(4.5, 1.7, 2.5),   Vector3(0, 1.4, 0)],
	[6.0,  Vector3(2.0, 1.7, 2.5),   Vector3(-2, 1.4, -3)],
	[12.0, Vector3(0,   1.7, 1.5),   Vector3(0, 1.5, -3)],
	[18.0, Vector3(0,   1.5, -1.5),  Vector3(0, 1.4, -5)],
	[24.0, Vector3(0,   1.2, -3.0),  Vector3(0, 1.55, -5)],
	[30.0, Vector3(1.5, 1.2, -3.0),  Vector3(0, 1.55, -5)],
]

var look_target: Vector3 = Vector3.ZERO


func _ready() -> void:
	current = true
	global_position = SEQUENCE[0][1]
	look_target = SEQUENCE[0][2]
	if auto_play:
		await get_tree().create_timer(0.4).timeout
		play_sequence()


func play_sequence() -> void:
	# Two independent tweens running in parallel — one for position, one for look target.
	# Each tween chains its keyframes sequentially with sine easing for smooth motion.
	var pos_tween := create_tween().set_trans(Tween.TRANS_SINE)
	var look_tween := create_tween().set_trans(Tween.TRANS_SINE)

	# Reset to start
	global_position = SEQUENCE[0][1]
	look_target = SEQUENCE[0][2]

	var prev_time: float = SEQUENCE[0][0]
	for i in range(1, SEQUENCE.size()):
		var kf = SEQUENCE[i]
		var dur: float = kf[0] - prev_time
		pos_tween.tween_property(self, "global_position", kf[1], dur)
		look_tween.tween_property(self, "look_target", kf[2], dur)
		prev_time = kf[0]


func _process(_delta: float) -> void:
	# Continuously face look_target so the camera turns naturally as it travels.
	if look_target != global_position:
		look_at(look_target, Vector3.UP)


func _input(event: InputEvent) -> void:
	if not debug_replay_key:
		return
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_R:
			play_sequence()
