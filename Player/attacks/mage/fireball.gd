extends Node3D


const SPEED = 40

@onready var Raycast = $Area3D
@onready var colition_particles = $Sparks

func _process(delta: float) -> void:
	position += transform.basis * Vector3(0,0,-SPEED) * delta


func _on_timer_timeout() -> void:
	queue_free()


func _on_area_3d_area_entered(_area: Area3D) -> void:
	$Fire_Drop.hide()
	colition_particles.emitting = true
	await  get_tree().create_timer(1.0).timeout
	queue_free()
