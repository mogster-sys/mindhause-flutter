## Time-of-day system — syncs palace lighting with real-world time
## Dawn, morning, afternoon, dusk, evening, night
extends Node

signal time_period_changed(period: String)

enum Period { DAWN, MORNING, AFTERNOON, DUSK, EVENING, NIGHT }

var current_period: Period = Period.MORNING
var current_hour: int = 12

# Lighting presets per period
var lighting: Dictionary = {
	Period.DAWN: {
		"ambient_color": Color(0.95, 0.85, 0.75),
		"ambient_energy": 0.3,
		"sun_color": Color(1.0, 0.8, 0.5),
		"sun_energy": 0.5,
		"sun_angle": -10.0,
	},
	Period.MORNING: {
		"ambient_color": Color(1.0, 0.97, 0.92),
		"ambient_energy": 0.5,
		"sun_color": Color(1.0, 0.95, 0.85),
		"sun_energy": 0.8,
		"sun_angle": 30.0,
	},
	Period.AFTERNOON: {
		"ambient_color": Color(1.0, 0.98, 0.95),
		"ambient_energy": 0.6,
		"sun_color": Color(1.0, 1.0, 0.95),
		"sun_energy": 1.0,
		"sun_angle": 60.0,
	},
	Period.DUSK: {
		"ambient_color": Color(0.95, 0.8, 0.7),
		"ambient_energy": 0.35,
		"sun_color": Color(1.0, 0.6, 0.3),
		"sun_energy": 0.4,
		"sun_angle": 10.0,
	},
	Period.EVENING: {
		"ambient_color": Color(0.3, 0.3, 0.45),
		"ambient_energy": 0.15,
		"sun_color": Color(0.4, 0.4, 0.6),
		"sun_energy": 0.1,
		"sun_angle": -20.0,
	},
	Period.NIGHT: {
		"ambient_color": Color(0.15, 0.15, 0.25),
		"ambient_energy": 0.08,
		"sun_color": Color(0.3, 0.3, 0.5),
		"sun_energy": 0.05,
		"sun_angle": -45.0,
	},
}

# Update interval in seconds
var update_interval: float = 60.0
var _timer: float = 0.0


func _ready() -> void:
	_update_time()


func _process(delta: float) -> void:
	_timer += delta
	if _timer >= update_interval:
		_timer = 0.0
		_update_time()


func _update_time() -> void:
	var time = Time.get_time_dict_from_system()
	current_hour = time["hour"]
	var old_period = current_period
	current_period = _hour_to_period(current_hour)
	if current_period != old_period:
		time_period_changed.emit(Period.keys()[current_period])


func _hour_to_period(hour: int) -> Period:
	if hour >= 5 and hour < 7:
		return Period.DAWN
	elif hour >= 7 and hour < 12:
		return Period.MORNING
	elif hour >= 12 and hour < 17:
		return Period.AFTERNOON
	elif hour >= 17 and hour < 19:
		return Period.DUSK
	elif hour >= 19 and hour < 22:
		return Period.EVENING
	else:
		return Period.NIGHT


func get_current_lighting() -> Dictionary:
	return lighting[current_period]


func get_period_name() -> String:
	return Period.keys()[current_period].to_lower()
