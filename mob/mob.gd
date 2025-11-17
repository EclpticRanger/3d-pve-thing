class_name Mob extends CharacterBody3D

const MOB_WALK_SPEED = 7.5
const JUMP_VELOCITY = 6
const gravity = 20

var target_player
var target_player_position
var oruentation = Transform3D()

func _ready() -> void:
	oruentation = $Model.global_transform
	oruentation.origin = Vector3()
	
	if not multiplayer.is_server():
		set_process(false)

func _process(_delta):
	if target_player != null:
		target_player_position = target_player.transform.origin

func set_traget_player(player):
	target_player = player
	if target_player != null:
		target_player_position = target_player.transform.origin

func _physics_process(delta: float) -> void:
	
	
	if multiplayer.is_server():
		_apply_movement(delta)
		if not is_on_floor():
			velocity.y -= gravity * delta
	else:
		_animate()

func _apply_movement(_delta):
	if target_player != null:
		
		target_player_position = target_player.transform.origin
		if not global_position.is_equal_approx(target_player_position):
			look_at(target_player_position, Vector3.UP)
		
		if is_on_floor():
			var player_direction = global_position.direction_to(target_player.global_position)
			player_direction *= MOB_WALK_SPEED
			velocity= player_direction * _delta
			set_up_direction(Vector3.UP)
	else:
		velocity.x = 0
		velocity.z = 0
	move_and_slide()

func _animate(): 
	pass
