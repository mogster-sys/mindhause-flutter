## AudioManager — centralised audio playback
## Call AudioManager.play_sfx("task_complete") from any script.
## Handles pooling, volume, and missing-file graceful fallback.
extends Node

# Sound effect paths — update these when real assets are added
var sfx_paths: Dictionary = {
	"task_pickup": "res://audio/sfx/task_pickup.ogg",
	"task_complete": "res://audio/sfx/task_complete.ogg",
	"task_place": "res://audio/sfx/task_place.ogg",
	"door_open": "res://audio/sfx/door_open.ogg",
	"door_close": "res://audio/sfx/door_close.ogg",
	"cat_meow": "res://audio/sfx/cat_meow.ogg",
	"cat_purr": "res://audio/sfx/cat_purr.ogg",
	"cat_hiss": "res://audio/sfx/cat_hiss.ogg",
	"cat_chirp": "res://audio/sfx/cat_chirp.ogg",
	"monster_growl": "res://audio/sfx/monster_growl.ogg",
	"monster_chase": "res://audio/sfx/monster_chase.ogg",
	"monster_defeat": "res://audio/sfx/monster_defeat.ogg",
	"footstep_stone": "res://audio/sfx/footstep_stone.ogg",
	"footstep_wood": "res://audio/sfx/footstep_wood.ogg",
	"footstep_grass": "res://audio/sfx/footstep_grass.ogg",
	"stairs_step": "res://audio/sfx/stairs_step.ogg",
	"ui_tap": "res://audio/sfx/ui_tap.ogg",
	"ui_swipe": "res://audio/sfx/ui_swipe.ogg",
	"ui_notification": "res://audio/sfx/ui_notification.ogg",
}

# Music paths per theme
var music_paths: Dictionary = {
	"greco_roman": "res://audio/music/ambient_greco_roman.ogg",
	"modern_loft": "res://audio/music/ambient_modern_loft.ogg",
	"victorian": "res://audio/music/ambient_victorian.ogg",
	"scifi": "res://audio/music/ambient_scifi.ogg",
	"gothic": "res://audio/music/ambient_gothic.ogg",
	"ryokan": "res://audio/music/ambient_ryokan.ogg",
	"cottage": "res://audio/music/ambient_cottage.ogg",
	"fallout": "res://audio/music/ambient_fallout.ogg",
}

# Audio player pool for SFX (avoids cutting off overlapping sounds)
var _sfx_pool: Array[AudioStreamPlayer] = []
var _pool_size: int = 8
var _pool_index: int = 0

# Dedicated music player
var _music_player: AudioStreamPlayer
var _current_music: String = ""

# Volume settings (linear, 0.0–1.0)
var sfx_volume: float = 0.8
var music_volume: float = 0.4
var master_enabled: bool = true

# Cache loaded streams to avoid repeated disk reads
var _stream_cache: Dictionary = {}


func _ready() -> void:
	# Create SFX player pool
	for i in _pool_size:
		var player := AudioStreamPlayer.new()
		player.bus = "SFX"
		add_child(player)
		_sfx_pool.append(player)

	# Create music player
	_music_player = AudioStreamPlayer.new()
	_music_player.bus = "Music"
	add_child(_music_player)

	# Load volume from settings
	var saved_sfx := DatabaseBridge.get_setting("sfx_volume")
	if saved_sfx != "":
		sfx_volume = float(saved_sfx)
	var saved_music := DatabaseBridge.get_setting("music_volume")
	if saved_music != "":
		music_volume = float(saved_music)
	var saved_enabled := DatabaseBridge.get_setting("audio_enabled")
	if saved_enabled != "":
		master_enabled = saved_enabled == "true"


## Play a sound effect by name. Returns false if the sound file doesn't exist yet.
func play_sfx(sfx_name: String, volume_override: float = -1.0) -> bool:
	if not master_enabled:
		return false
	if not sfx_paths.has(sfx_name):
		push_warning("AudioManager: Unknown SFX name: " + sfx_name)
		return false

	var stream := _load_stream(sfx_paths[sfx_name])
	if not stream:
		return false  # File not yet added — silent fallback

	var player := _sfx_pool[_pool_index]
	_pool_index = (_pool_index + 1) % _pool_size

	player.stream = stream
	var vol := volume_override if volume_override >= 0.0 else sfx_volume
	player.volume_db = linear_to_db(vol)
	player.play()
	return true


## Play ambient music for a theme. Crossfades if already playing.
func play_music(theme_name: String) -> void:
	if not master_enabled:
		return
	if theme_name == _current_music and _music_player.playing:
		return  # Already playing this track

	if not music_paths.has(theme_name):
		push_warning("AudioManager: Unknown music theme: " + theme_name)
		return

	var stream := _load_stream(music_paths[theme_name])
	if not stream:
		return  # File not yet added

	_current_music = theme_name

	# Fade out current, then start new
	if _music_player.playing:
		var tween := create_tween()
		tween.tween_property(_music_player, "volume_db", -40.0, 1.0)
		tween.tween_callback(func():
			_music_player.stream = stream
			_music_player.volume_db = linear_to_db(music_volume)
			_music_player.play()
		)
	else:
		_music_player.stream = stream
		_music_player.volume_db = linear_to_db(music_volume)
		_music_player.play()


## Stop music with fade out
func stop_music(fade_duration: float = 1.0) -> void:
	if _music_player.playing:
		var tween := create_tween()
		tween.tween_property(_music_player, "volume_db", -40.0, fade_duration)
		tween.tween_callback(_music_player.stop)
		_current_music = ""


## Set SFX volume (0.0–1.0) and persist
func set_sfx_volume(vol: float) -> void:
	sfx_volume = clampf(vol, 0.0, 1.0)
	DatabaseBridge.set_setting("sfx_volume", str(sfx_volume))


## Set music volume (0.0–1.0) and persist
func set_music_volume(vol: float) -> void:
	music_volume = clampf(vol, 0.0, 1.0)
	if _music_player.playing:
		_music_player.volume_db = linear_to_db(music_volume)
	DatabaseBridge.set_setting("music_volume", str(music_volume))


## Toggle all audio
func set_enabled(enabled: bool) -> void:
	master_enabled = enabled
	if not enabled:
		stop_music(0.3)
		for player in _sfx_pool:
			player.stop()
	DatabaseBridge.set_setting("audio_enabled", str(enabled).to_lower())


func _load_stream(path: String) -> AudioStream:
	if _stream_cache.has(path):
		return _stream_cache[path]

	if not ResourceLoader.exists(path):
		return null  # File doesn't exist yet — graceful fallback

	var stream := load(path) as AudioStream
	if stream:
		_stream_cache[path] = stream
	return stream
