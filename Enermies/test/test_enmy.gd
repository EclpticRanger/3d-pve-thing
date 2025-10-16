extends CharacterBody3D

var move_speed = 50000
var dir = Vector3(0, 0, 0)
var min_range: int = 200

@export var Player_path: NodePath

@onready var player = get_node(Player_path)
@onready var nav_agent := $NavigationAgent3D as NavigationAgent3D

func _physics_process(delta: float) -> void:
	velocity += get_gravity()
	dir = Vector2(0, 0)
	dir = to_local(nav_agent.get_next_path_position()).normalized()
	velocity.x = dir.x * move_speed * delta
	velocity.z = dir.z * move_speed * delta
	move_and_slide()

func _make_path() -> void:
	nav_agent.target_position = player.position
	
func _on_timer_timeout() -> void:
	_make_path()
