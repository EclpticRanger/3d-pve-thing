extends Node

func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("quit"):
		get_tree().change_scene_to_file("res://Ui/Start Menue/Main.tscn")
