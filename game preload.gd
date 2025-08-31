extends Node

var settings = load("res://Ui/Setings/setings.gd").new()


func _ready() -> void:
	settings.loadsettings()
	settings.UpdateSettingsGame()
	get_tree().change_scene_to_file.call_deferred("res://Ui/Start Menue/Main.tscn")
