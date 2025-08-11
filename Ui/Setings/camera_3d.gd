extends Camera3D

func _process(delta: float) -> void:
	rotate(Vector3(0 ,1 ,0), 0.1 * delta)
