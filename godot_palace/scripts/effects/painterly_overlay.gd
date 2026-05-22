## PainterlyOverlay — fullscreen kuwahara + posterize + grain post-process.
## Reads the `painterly_enabled` and `painterly_strength` settings from the DB
## and toggles itself accordingly. Per-theme strength can be tuned in ThemeManager.
extends CanvasLayer

@onready var effect: ColorRect = $Effect

var _shader_mat: ShaderMaterial = null


func _ready() -> void:
	add_to_group("painterly_overlay")
	if effect and effect.material is ShaderMaterial:
		_shader_mat = effect.material
	_apply_settings()
	GameState.settings_changed.connect(_on_settings_changed)
	ThemeManager.theme_changed.connect(_on_theme_changed)


func _apply_settings() -> void:
	var enabled: bool = DatabaseBridge.get_setting("painterly_enabled") != "false"
	visible = enabled

	var strength_str: String = DatabaseBridge.get_setting("painterly_strength")
	if strength_str != "" and _shader_mat:
		_shader_mat.set_shader_parameter("strength", strength_str.to_float())


func set_enabled(enabled: bool) -> void:
	visible = enabled
	DatabaseBridge.set_setting("painterly_enabled", "true" if enabled else "false")


func set_strength(value: float) -> void:
	value = clamp(value, 0.0, 1.0)
	if _shader_mat:
		_shader_mat.set_shader_parameter("strength", value)
	DatabaseBridge.set_setting("painterly_strength", str(value))


func _on_settings_changed(key: String, value: String) -> void:
	if key == "painterly_enabled":
		visible = value != "false"
	elif key == "painterly_strength" and _shader_mat:
		_shader_mat.set_shader_parameter("strength", value.to_float())


## Per-theme tuning — some themes want stronger painted look than others
func _on_theme_changed(theme_id: String) -> void:
	if not _shader_mat:
		return
	var preset: Dictionary = _theme_preset(theme_id)
	for key in preset:
		_shader_mat.set_shader_parameter(key, preset[key])


func _theme_preset(theme_id: String) -> Dictionary:
	match theme_id:
		"greco_roman":
			return {"strength": 0.85, "posterize_levels": 12.0, "saturation": 1.05}
		"victorian":
			return {"strength": 0.9, "posterize_levels": 10.0, "saturation": 0.95}
		"gothic":
			return {"strength": 0.95, "posterize_levels": 8.0, "saturation": 0.85}
		"ryokan":
			return {"strength": 0.8, "posterize_levels": 14.0, "saturation": 1.0}
		"cottage":
			return {"strength": 0.85, "posterize_levels": 12.0, "saturation": 1.1}
		"modern_loft":
			return {"strength": 0.6, "posterize_levels": 16.0, "saturation": 1.0}
		"scifi":
			return {"strength": 0.5, "posterize_levels": 18.0, "saturation": 1.05}
		"fallout":
			return {"strength": 0.75, "posterize_levels": 8.0, "saturation": 0.9}
		_:
			return {"strength": 0.85, "posterize_levels": 12.0, "saturation": 1.05}
