extends Node

var mouse_sensitivity: float = 100
var controler_mode = false
var player_state = false
var player = null
var port = 0
var _multiplayer = 0

func _enter_tree() -> void:
	if _multiplayer == 0: _multiplayer = 0
