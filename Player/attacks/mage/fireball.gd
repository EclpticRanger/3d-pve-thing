extends Node3D


const SPEED = 40

@onready var Raycast = $RayCast3D
@onready var colition_particles = $Sparks

func _process(delta: float) -> void:
	if Raycast.is_colliding():
		$Fire_Drop.hide()
		colition_particles.emitting = true
		await  get_tree().create_timer(1.0).timeout
		queue_free()
	position += transform.basis * Vector3(0,0,-SPEED) * delta


func _on_timer_timeout() -> void:
	queue_free()
