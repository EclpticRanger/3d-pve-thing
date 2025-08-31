extends Control

@onready var tabbar = $"PanelContainer/TabBar"

var fullscreen = false
var vsync = false
var resolution = 1080
var aspect_ratio = 1.777777777777778 #16:9
var resolution_tabel = [0, 720, 1080, 1440, 2160, 4320]
var aspets_ratio_table = [0, 1.333333333333333, 1.777777777777778, 1.6, 2.333333333333333, 3.555555555555556]
var master_volume = 100
var sound_effect_volume = 100
var music_volume = 100
var player_volume = 100
var save_path = "user://settings.cfg"
var keybinds: Dictionary = {
	"abilty 1": InputMap.action_get_events("abilty 1")[0],
	"abilty 2": InputMap.action_get_events("abilty 2")[0],
	"abilty 3": InputMap.action_get_events("abilty 3")[0],
	"forward": InputMap.action_get_events("forward")[0],
	"back": InputMap.action_get_events("back")[0],
	"left": InputMap.action_get_events("left")[0],
	"right": InputMap.action_get_events("right")[0],
	"sprint": InputMap.action_get_events("sprint")[0],
	"jump": InputMap.action_get_events("jump")[0],
	"crouch": InputMap.action_get_events("crouch")[0]}
#keybins settings

func loadsettings():
	var config = ConfigFile.new()
	if config.load(save_path) == OK:
		fullscreen = config.get_value("visual", "fullscreen")
		vsync = config.get_value("visual", "vsync")
		master_volume = config.get_value("audio", "master_volume")
		sound_effect_volume = config.get_value("audio", "sound_effect_volume") 
		music_volume = config.get_value("audio" , "music_volume")
		player_volume = config.get_value("audio" , "player_volume")
		keybinds = config.get_value("controls", "keybinds")
		GlobalVarables.mouse_sensitivity = config.get_value("controls", "mouse_sensitivity")
		GlobalVarables.controler_mode = config.get_value("controls", "controler mode")
		UpdateSettingsGame()
	else:
		# File doesn't exist or failed to load, create default config
		config.set_value("visual", "fullscreen", false)
		config.set_value("visual", "vsync", false)
		config.set_value("audio", "master_volume", 100)
		config.set_value("audio", "sound_effect_volume", 100)
		config.set_value("audio", "music_volume", 100)
		config.set_value("audio", "player_volume", 100)
		config.set_value("controls", "keybinds", keybinds)
		config.set_value("controls", "mouse_sensitivity", 100)
		config.set_value("controls", "controler mode", false)
		config.save(save_path)
		print("New settings config file created")

func save_data():
	var config = ConfigFile.new()
	# Load existing config first, ignore error if file doesn't exist
	config.load(save_path)

	# Set new values (overrides old values)
	config.set_value("visual", "fullscreen", fullscreen)
	config.set_value("visual", "vsync", vsync)
	config.set_value("audio", "master_volume", master_volume)
	config.set_value("audio", "sound_effect_volume", sound_effect_volume)
	config.set_value("audio", "music_volume", music_volume)
	config.set_value("audio", "player_volume", player_volume)
	config.set_value("controls", "keybinds", keybinds)
	config.set_value("controls", "mouse_sensitivity", GlobalVarables.mouse_sensitivity)
	config.set_value("controls", "controler mode", GlobalVarables.controler_mode)
	
	var err = config.save(save_path)
	if err != OK:
		print("Failed to save config:", error_string(err))
	else:
		print("Settings saved successfully.")

func _ready() -> void:
	loadsettings()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		save_data()
		get_tree().change_scene_to_file("res://Ui/Start Menue/Main.tscn")

func _on_master_volume_slider_value_changed(value: float) -> void:
	master_volume = linear_to_db(value)
	update_audio_settings()
func _on_fullscreen_button_toggled(toggled_on: bool) -> void:
	fullscreen = toggled_on
	UpdateSettingsGame()

func UpdateSettingsGame():
	update_audio_settings()
	update_video_settings()

func update_audio_settings():
	AudioServer.set_bus_volume_db(0 , master_volume)
	AudioServer.set_bus_volume_db(1 , sound_effect_volume)
	AudioServer.set_bus_volume_db(2 , master_volume)
	AudioServer.set_bus_volume_db(3 , sound_effect_volume)

func update_keybinds():
	InputMap.action_erase_events("abilty 1")
	InputMap.action_erase_events("abilty 2")
	InputMap.action_erase_events("abilty 3")
	InputMap.action_erase_events("forward")
	InputMap.action_erase_events("back")
	InputMap.action_erase_events("left")
	InputMap.action_erase_events("right")
	InputMap.action_erase_events("jump")
	InputMap.action_erase_events("sprint")
	InputMap.action_erase_events("crouch")
	
	InputMap.action_add_event("abilty 1" , keybinds["abilty 1"])
	InputMap.action_add_event("abilty 2" , keybinds["abilty 2"])
	InputMap.action_add_event("abilty 3" , keybinds["abilty 3"])
	InputMap.action_add_event("forward" , keybinds["forward"])
	InputMap.action_add_event("back" , keybinds["back"])
	InputMap.action_add_event("left" , keybinds["left"])
	InputMap.action_add_event("right" , keybinds["right"])
	InputMap.action_add_event("jump" , keybinds["jump"])
	InputMap.action_add_event("sprint" , keybinds["sprint"])
	InputMap.action_add_event("crouch" , keybinds["crouch"])
	
	keybinds["abilty 1"] = InputMap.action_get_events("abilty 1")[0]
	keybinds["abilty 2"] = InputMap.action_get_events("abilty 2")[0]
	keybinds["abilty 3"] = InputMap.action_get_events("abilty 3")[0]
	keybinds["forward"] = InputMap.action_get_events("forward")[0]
	keybinds["back"] = InputMap.action_get_events("back")[0]
	keybinds["left"] = InputMap.action_get_events("left")[0]
	keybinds["right"] = InputMap.action_get_events("right")[0]
	keybinds["jump"] = InputMap.action_get_events("jump")[0]
	keybinds["sprint"] = InputMap.action_get_events("sprint")[0]
	keybinds["crouch"] = InputMap.action_get_events("crouch")[0]

func update_video_settings():
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	if vsync:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
func update_genral_settings():
	pass

func _on_sound_effect_volume_slider_2_value_changed(value: float) -> void:
	master_volume = linear_to_db(value)
	update_audio_settings()
func _on_vsync_toggled(toggled_on: bool) -> void:
	vsync = toggled_on
	UpdateSettingsGame()
func _on_tab_bar_tab_changed(tab: int) -> void:
	$"PanelContainer/0".hide()
	$"PanelContainer/1".hide()
	$"PanelContainer/2".hide()
	$"PanelContainer/3".hide()
	if tab == 0:
		$"PanelContainer/0".show()
	elif tab == 1:
		$"PanelContainer/1".show()
	elif tab == 2:
		$"PanelContainer/2".show()
	elif tab == 3:
		$"PanelContainer/3".show()
func _on_music_volume_slider_value_changed(value: float) -> void:
	music_volume = linear_to_db(value)
	update_audio_settings()
func _on_player_volume_slider_value_changed(value: float) -> void:
	player_volume = linear_to_db(value)
	update_audio_settings()
func _on_controler_mode_toggled(toggled_on: bool) -> void:
	GlobalVarables.controler_mode = toggled_on
func _on_mouse_sensativity_value_changed(value: float) -> void:
	GlobalVarables.mouse_sensitivity = value
func _on_resolution_item_selected(index: int) -> void:
	resolution = resolution_tabel[index]
	get_window().size = Vector2(resolution * aspect_ratio, resolution)
func _on_aspect_ratio_item_selected(index: int) -> void:
	aspect_ratio = aspets_ratio_table[index]
	get_window().size = Vector2(resolution * aspect_ratio, resolution)
