extends Node

var mouse_sensitivity: float = 100
var controler_mode = false
var player = null
var port = null
var _multiplayer = 0

func _enter_tree() -> void:
	if _multiplayer == 0: _multiplayer = 0
