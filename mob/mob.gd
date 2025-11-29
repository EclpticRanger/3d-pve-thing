class_name mob
extends CharacterBody3D


var gravity: int = -20
var BACE_MOVE_SPEED: float = 5
var target = null
var attacking: bool = false
var last_frame_attack_state: bool = false

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	# Only server should run pathfinding/physics for this mob
	if not multiplayer.is_server():
		set_physics_process(false)
	else:
		set_physics_process(true)
		global_position = Vector3(rng.randf_range(10, 10), 1, rng.randf_range(10, 10))
		while get_slide_collision_count() > 0:
			global_position = Vector3(rng.randf_range(10, 10), 1, rng.randf_range(10, 10))

func _physics_process(delta: float) -> void:
	if not multiplayer.is_server():
		return
	
	if target != null:	
		navigation_agent_3d.target_position = target.global_transform.origin
		var current_pos = global_transform.origin
		var next_pos = navigation_agent_3d.get_next_path_position()
		var direction = (next_pos - current_pos).normalized()
		look_at(target.global_transform.origin)
		rotate_y(PI)
		rotation.x = 0
		velocity = direction * BACE_MOVE_SPEED
	else: 
		velocity = Vector3.ZERO
	if not is_on_floor():
		velocity.y += gravity * delta
	
	move_and_slide()

func _on_detection_area_body_entered(body: Node3D) -> void:
	if not multiplayer.is_server():
		return
	if body.get("nav_type") == "player":
		target = body
		print('target aquired')


func _on_detection_area_body_exited(body: Node3D) -> void:
	if not multiplayer.is_server():
		return
	if body.get("nav_type") == "player":
		target = null
		print("target left detection regon")


func _on_attacking_area_body_entered(body: Node3D) -> void:
	if not multiplayer.is_server():
		return
	if body.get("nav_type") == "player":
		$Model/AnimationPlayer.play("Unarmed_Melee_Attack_Punch_A")
		
