extends Control

var save_path := "user://settings.cfg"
var fullscreen := true
var master_volume := 1.0
var sound_effect_volume := 1.0
var mouse_sensitivity := 1.0
# Store only serializable data (e.g. keycodes or strings) for keybinds
var keybinds: Dictionary = {
	"abilty 1": "",
	"abilty 2": "",
	"abilty 3": "",
	"forward": "",
	"back": "",
	"left": "",
	"right": "",
	"sprint": "",
	"jump": ""
}

@export var master_bus_index: int = 0

func _ready() -> void:
	load_settings()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func save_settings():
	var config = ConfigFile.new()
	config.set_value("visual", "fullscreen", fullscreen)
	config.set_value("audio", "master_volume", master_volume)
	config.set_value("audio", "sound_effect_volume", sound_effect_volume)
	config.set_value("controls", "mouse_sensitivity", mouse_sensitivity)
	config.set_value("controls", "keybinds", keybinds)
	var err = config.save(save_path)
	if err != OK:
		print("Failed to save settings: ", err)

func load_settings():
	var config = ConfigFile.new()
	if config.load(save_path) == OK:
		fullscreen = config.get_value("visual", "fullscreen", true)
		master_volume = config.get_value("audio", "master_volume", 1.0)
		sound_effect_volume = config.get_value("audio", "sound_effect_volume", 1.0)
		mouse_sensitivity = config.get_value("controls", "mouse_sensitivity", 1.0)
		keybinds = config.get_value("controls", "keybinds", keybinds)
	else:
		print("Settings file not found, saving defaults.")
		save_settings() # Save defaults if file doesn't exist

		# Apply loaded values to UI
	var master_slider = $Settings/Main/PanelContainer/VBoxContainer/master_volume_slider
	if master_slider:
		master_slider.value = master_volume

	var sfx_slider = $Settings/Main/PanelContainer/VBoxContainer/sound_effect_volume_slider2
	if sfx_slider:
		sfx_slider.value = sound_effect_volume

	var mouse_slider = $Settings/Main/PanelContainer/VBoxContainer/mouse_speed_slider2
	if mouse_slider:
		mouse_slider.value = mouse_sensitivity

	var fullscreen_btn = $Settings/Main/PanelContainer/VBoxContainer/fullscreen_button
	if fullscreen_btn:
		fullscreen_btn.button_pressed = fullscreen
	UpdateSettingsGame()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		save_settings()
		get_tree().change_scene_to_file("res://Ui/Start Menue/Main.tscn")

func _on_master_volume_slider_value_changed(value: float) -> void:
	master_volume = value
	UpdateSettingsGame()
	save_settings()

func _on_sound_effect_volume_slider2_value_changed(value: float) -> void:
	sound_effect_volume = value
	UpdateSettingsGame()
	save_settings()

func _on_mouse_speed_slider2_value_changed(value: float) -> void:
	mouse_sensitivity = value
	UpdateSettingsGame()
	save_settings()

func _on_fullscreen_button_toggled(toggled_on: bool) -> void:
	fullscreen = toggled_on
	UpdateSettingsGame()
	save_settings()

func UpdateSettingsGame():
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	AudioServer.set_bus_volume_db(master_bus_index, linear_to_db(master_volume))
	# Add sound effect volume and keybinds logic as needed

func _on_go_to_main_setings_pressed() -> void:
	$Keybinds.call_deferred("hide")
	$Main.call_deferred("show")

func _on_go_to_control_setings_pressed() -> void:
	$Keybinds.call_deferred("show")
	$Main.call_deferred("hide")
