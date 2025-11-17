extends MultiplayerSynchronizer

@onready var mob = $".."

func _on_actervation_area_body_entered(body):
	if not is_inside_tree() or not multiplayer.has_multiplayer_peer() or not is_multiplayer_authority():
		return
	
	print('body entered')
		
	mob.set_traget_player(body)

func _on_actervation_area_body_exited(_body):
	if not is_inside_tree() or not multiplayer.has_multiplayer_peer() or not is_multiplayer_authority():
		return
	
	print("body exited")

		
	mob.set_traget_player(null)
