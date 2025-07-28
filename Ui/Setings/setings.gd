extends Control

var fullscreen = false
var master_volume = 100
var save_path = "user://settings.cfg"
var keybinds: Dictionary = {
	"abilty 1": "1",
	"abilty 2": "2",
	"abilty 3": "3",
	"forward": "w",
	"back": "s",
	"left": "a",
	"right": "d",
	"sprint": "ctrl",
	"jump": "space"}
#keybins settings

func loadsettings():
	var config = ConfigFile.new()
	if config.load(save_path) == OK:
		fullscreen = config.get_value("visual", "fullscreen")
		master_volume = config.get_value("audio", "master_volume") 
		keybinds = config.get_value("controls", "keybinds")
		GlobalVarables.mouse_sensitivity = config.get_value("controls", "mouse_sensitivity")
		UpdateSettingsGame()
	else:
		# File doesn't exist or failed to load, create default config
		config.set_value("visual", "fullscreen", true)
		config.set_value("audio", "master_volume", 100)
		config.set_value("controls", "keybinds", keybinds)
		config.set_value("controls", "mouse_sensitivity", 100)
		config.save(save_path)
		print("New settings config file created")

func save_data():
	var config = ConfigFile.new()
	# Load existing config first, ignore error if file doesn't exist
	config.load(save_path)

	# Set new values (overrides old values)
	config.set_value("visual", "fullscreen", fullscreen)
	config.set_value("audio", "master_volume", master_volume)
	config.set_value("controls", "keybinds", keybinds)
	config.set_value("controls", "mouse_sensitivity", GlobalVarables.mouse_sensitivity)
	
	var err = config.save(save_path)
	if err != OK:
		print("Failed to save config:", error_string(err))
	else:
		print("Settings saved successfully.")

@export var master_bus_index: int = 0

func _ready() -> void:
	loadsettings()

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
	
	#for item in keybinds: #Erase all InputMap keybinds
		#InputMap.action_erase_events(item)
	#for item in keybinds:
		#InputMap.action_add_event(item, keybinds[item])

func _on_go_to_main_setings_pressed() -> void:
	$Controls.hide()
	$Main.show()


func _on_go_to_control_setings_pressed() -> void:
	$Controls.show()
	$Main.hide()
