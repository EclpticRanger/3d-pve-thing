extends Node

var settings = load("res://Ui/Setings/setings.gd")

func _ready() -> void:
	settings.loadsettings()
	settings.UpdateSettingsGame()
