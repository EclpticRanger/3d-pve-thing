class_name Mob extends CharacterBody3D

const MOB_WALK_SPEED = 50
const JUMP_VELOCITY = 6
const gravity = 20

var target_player
var target_player_position
var oruentation = Transform3D()
@export var server_authority: bool = true
@export var debug_mob: bool = false

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
	
	# `server_authority` keeps the previous server-only behaviour by default.
	# Set `server_authority = false` on the mob instance for local testing so
	# movement/rotation runs on the client as well.
	if server_authority:
		if multiplayer.is_server():
			_apply_movement(delta)
			if not is_on_floor():
				velocity.y -= gravity * delta
		else:
			_animate()
	else:
		# Local testing mode: always run movement and gravity locally.
		_apply_movement(delta)
		if not is_on_floor():
			velocity.y -= gravity * delta

func _apply_movement(_delta):
	if target_player != null:
		
		target_player_position = target_player.global_position
		# Face the player on the horizontal plane. Use the visible model if present
		# so we don't tilt the whole body up/down. Guard against identical
		# positions to avoid look_at() errors.
		var target_pos = target_player_position
		var horizontal_target = Vector3(target_pos.x, global_position.y, target_pos.z)
		if not global_position.is_equal_approx(horizontal_target):
			if has_node("Model"):
				$Model.look_at(horizontal_target, Vector3.UP)
			else:
				look_at(horizontal_target, Vector3.UP)
				# keep only yaw on fallback
				rotation.x = 0
				rotation.z = 0

		if is_on_floor():
			# Compute horizontal direction and set velocity (units/sec).
			var player_direction = (target_player.global_position - global_position)
			player_direction.y = 0
			if player_direction.length() > 0.001:
				player_direction = player_direction.normalized() * MOB_WALK_SPEED
				velocity.x = player_direction.x
				velocity.z = player_direction.z
			set_up_direction(Vector3.UP)
	else:
		velocity.x = 0
		velocity.z = 0
	move_and_slide()

func _animate(): 
	pass
