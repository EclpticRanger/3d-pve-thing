extends Control

@onready var join_code_entry = $"PanelContainer/VBoxContainer/PanelContainer/VBoxContainer/Join Code Entry"
@onready var multiplayer_menue = $PanelContainer/VBoxContainer/PanelContainer

func _on_quit_button_pressed() -> void:
	get_tree().quit(0)


func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Ui/Setings/Setings.tscn")

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_host_button_pressed() -> void:
	GlobalVarables._multiplayer = 1
	get_tree().change_scene_to_file("res://Ui/Multiplayer/LanMultiplayer.tscn")

func _on_multiplayer_button_pressed() -> void:
	if multiplayer_menue.visible:  multiplayer_menue.hide()
	else: multiplayer_menue.show()

func _on_join_button_lan_pressed() -> void:
	GlobalVarables.port = $"PanelContainer/VBoxContainer/PanelContainer/VBoxContainer/Port Entrey".text
	if GlobalVarables.port == null:
		$"Error Mesages".invalid_input()
	elif GlobalVarables.port.is_valid_int():
		GlobalVarables.port = int(GlobalVarables.port)
		if GlobalVarables.port > 0 and GlobalVarables.port < 65535:
			GlobalVarables._multiplayer = 2
			get_tree().change_scene_to_file("res://Ui/Multiplayer/LanMultiplayer.tscn")
		else: $"Error Mesages".out_of_range()
	else: $"Error Mesages".invalid_input()
