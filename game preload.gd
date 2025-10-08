extends Node

var settings = load("res://Ui/Setings/setings.gd").new()


func _ready() -> void:
	#settings.loadsettings()
	call_deferred("change_scene")

func change_scene():
	get_tree().change_scene_to_file("res://Ui/Start Menue/Main.tscn")
