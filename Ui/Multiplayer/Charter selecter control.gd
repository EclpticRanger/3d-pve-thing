extends VBoxContainer
var id: int

func _on_knight_pressed() -> void:
	id = 0

func _on_rouge_pressed() -> void:
	id = 1

func _on_paladin_pressed() -> void:
	id = 2

func _on_archer_pressed() -> void:
	id = 3

func _on_warlock_pressed() -> void:
	id = 4


func _on_select_pressed() -> void:
	GlobalVarables.player.Character_id = id
	GlobalVarables.player.Character_Showm_update()
	$"../..".hide()
	GlobalVarables.player_state = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_mage_pressed() -> void:
	id = 5
