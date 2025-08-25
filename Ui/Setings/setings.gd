extends Control

var fullscreen = false
var master_volume = 100
var sound_effect_volume = 100
var save_path = "user://settings.cfg"
var keybinds: Dictionary = {
	"abilty 1": InputEvent,
	"abilty 2": InputEvent,
	"abilty 3": InputEvent,
	"forward": InputEvent,
	"back": InputEvent,
	"left": InputEvent,
	"right": InputEvent,
	"sprint": InputEvent,
	"jump": InputEvent,
	"crouch": InputEvent}
#keybins settings

func loadsettings():
	var config = ConfigFile.new()
	if config.load(save_path) == OK:
		fullscreen = config.get_value("visual", "fullscreen")
		master_volume = config.get_value("audio", "master_volume")
		sound_effect_volume = config.get_value("audio", "sound_effect_volume") 
		keybinds = config.get_value("controls", "keybinds")
		GlobalVarables.mouse_sensitivity = config.get_value("controls", "mouse_sensitivity")
		UpdateSettingsGame()
	else:
		# File doesn't exist or failed to load, create default config
		config.set_value("visual", "fullscreen", true)
		config.set_value("audio", "master_volume", 100)
		config.set_value("audio", "sound_effect_volume", 100)
		config.set_value("controls", "keybinds", keybinds)
		config.set_value("controls", "mouse_sensitivity", 50)
		config.save(save_path)
		print("New settings config file created")

func save_data():
	var config = ConfigFile.new()
	# Load existing config first, ignore error if file doesn't exist
	config.load(save_path)

	# Set new values (overrides old values)
	config.set_value("visual", "fullscreen", fullscreen)
	config.set_value("audio", "master_volume", master_volume)
	config.set_value("audio", "sound_effect_volume", sound_effect_volume)
	config.set_value("controls", "keybinds", keybinds)
	config.set_value("controls", "mouse_sensitivity", GlobalVarables.mouse_sensitivity)
	
	var err = config.save(save_path)
	if err != OK:
		print("Failed to save config:", error_string(err))
	else:
		print("Settings saved successfully.")

@export var master_bus_index: int = 0
@onready var tabbar = $"TabBar"

func _ready() -> void:
	loadsettings()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		save_data()
		get_tree().change_scene_to_file("res://Ui/Start Menue/Main.tscn")

func _on_master_volume_slider_value_changed(value: float) -> void:
	master_volume = linear_to_db(value)
	UpdateSettingsGame()


func _on_fullscreen_button_toggled(toggled_on: bool) -> void:
	fullscreen = toggled_on
	UpdateSettingsGame()

func UpdateSettingsGame():
	if fullscreen == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	AudioServer.set_bus_volume_db(0 , master_volume)
	AudioServer.set_bus_volume_db(1 , sound_effect_volume)
	AudioServer.set_bus_volume_db(2 , master_volume)
	AudioServer.set_bus_volume_db(3 , sound_effect_volume)
	
	#InputMap.action_erase_events("abilty 1")
	#InputMap.action_erase_events("abilty 2")
	#InputMap.action_erase_events("abilty 3")
	#InputMap.action_erase_events("forward")
	#InputMap.action_erase_events("back")
	#InputMap.action_erase_events("left")
	#InputMap.action_erase_events("right")
	#InputMap.action_erase_events("jump")
	#InputMap.action_erase_events("sprint")
	
	#InputMap.action_add_event("abilty 1" , keybinds["abilty 1"])
	#InputMap.action_add_event("abilty 2" , keybinds["abilty 2"])
	#InputMap.action_add_event("abilty 3" , keybinds["abilty 3"])
	#InputMap.action_add_event("forward" , keybinds["forward"])
	#InputMap.action_add_event("back" , keybinds["back"])
	#InputMap.action_add_event("left" , keybinds["left"])
	#InputMap.action_add_event("right" , keybinds["right"])
	#InputMap.action_add_event("jump" , keybinds["jump"])
	#InputMap.action_add_event("sprint" , keybinds["sprint"])

func _on_sound_effect_volume_slider_2_value_changed(value: float) -> void:
	master_volume = linear_to_db(value)
	UpdateSettingsGame()


func _on_vsync_toggled(toggled_on: bool) -> void:
	UpdateSettingsGame()
		


func _on_tab_bar_tab_changed(tab: int) -> void:
	$"TabBar/1".hide()
	$"TabBar/2".hide()
	$"TabBar/3".hide()
	if tab == 1:
		$"TabBar/1".show()
	elif tab == 2:
		$"TabBar/2".show()
	elif tab == 3:
			$"TabBar/3".show()
