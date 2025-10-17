extends CharacterBody3D

signal died(enemy)

@export var move_speed: float = 4.0
@export var detection_radius: float = 20.0
@export var attack_radius: float = 2.0
@export var damage: int = 10
@export var attack_cooldown: float = 1.0
@export var knockback_strength: float = 6.0
@export var use_navigation: bool = true

@export var attack_sound: AudioStream
@export var attack_vfx: PackedScene

var _attack_timer: float = 0.0
@onready var _player = null
@onready var _nav_agent: NavigationAgent3D = get_node_or_null("NavigationAgent3D")
#@onready var _audio: AudioStreamPlayer3D = get_node_or_null("AudioStreamPlayer3D")
#@onready var _anim: AnimationPlayer = get_node_or_null("AnimationPlayer")
@onready var _attack_area: Area3D = get_node_or_null("AttackArea")

@export var max_health: int = 50
var health: int

func _ready() -> void:
	health = max_health
	# Try to get player from global singleton
	if Engine.has_singleton("GlobalVarables"):
		_player = GlobalVarables.player

	# If we have an AudioStream set in the Inspector, assign it to the player node (if present)
	#if _audio and attack_sound:
	#	_audio.stream = attack_sound

	# Configure navigation agent if present
	if _nav_agent:
		_nav_agent.target_desired_distance = 0.1

	# Connect attack area signal if present
	var attack_callable = Callable(self, "_on_attack_area_body_entered")
	if _attack_area and not _attack_area.is_connected("body_entered", attack_callable):
		_attack_area.connect("body_entered", attack_callable)

	# Ensure AnimationPlayer has basic placeholder animations
	#if _anim:
	#	if not _anim.has_animation("attack"):
	#		var a = Animation.new()
	#		a.length = 0.5
	#		_anim.add_animation("attack", a)
	#	if not _anim.has_animation("hit"):
	#		var h = Animation.new()
	#		h.length = 0.3
	#		_anim.add_animation("hit", h)
	#	if not _anim.has_animation("death"):
	#		var d = Animation.new()
	#		d.length = 1.0
	#		_anim.add_animation("death", d)

func _physics_process(delta: float) -> void:
	# Ensure we have a live player reference
	if not _player:
		if Engine.has_singleton("GlobalVarables"):
			_player = GlobalVarables.player
		if not _player:
			return

	_attack_timer = max(_attack_timer - delta, 0.0)

	var to_player: Vector3 = _player.global_transform.origin - global_transform.origin
	var dist := to_player.length()

	if dist <= detection_radius:
		# Face the player
		look_at(_player.global_transform.origin, Vector3.UP)

		# Move: prefer NavigationAgent3D pathfinding when enabled and available
		if use_navigation and _nav_agent:
			_nav_agent.set_target_location(_player.global_transform.origin)
			var next_pos = _nav_agent.get_next_path_position()
			if next_pos != Vector3.ZERO:
				var dir = (next_pos - global_transform.origin).with_y(0).normalized()
				velocity.x = dir.x * move_speed
				velocity.z = dir.z * move_speed
		else:
			var dir = to_player.normalized()
			velocity.x = dir.x * move_speed
			velocity.z = dir.z * move_speed

		# Keep enemy roughly grounded
		velocity.y = 0
		move_and_slide()

		# Attack if close enough and cooldown expired (backup check)
		if dist <= attack_radius and _attack_timer <= 0.0:
			_perform_attack()
			_attack_timer = attack_cooldown
	else:
		# Slow to a stop when player is out of detection range
		velocity.x = move_toward(velocity.x, 0, move_speed * delta)
		velocity.z = move_toward(velocity.z, 0, move_speed * delta)
		move_and_slide()

func _perform_attack() -> void:
	# Play attack animation (if exists)
	#if _anim and _anim.has_animation("attack"):
	#	_anim.play("attack")

	# Play sound
	#if _audio and _audio.stream:
	#	_audio.play()

	# Spawn VFX if provided
	if attack_vfx:
		var vfx_instance = attack_vfx.instantiate()
		if vfx_instance:
			get_tree().get_current_scene().add_child(vfx_instance)
			vfx_instance.global_transform.origin = global_transform.origin

	# Deal damage + knockback
	_do_attack()


func _on_attack_area_body_entered(body: Node) -> void:
	# Area-based attack trigger: only attack the player
	if not body:
		return
	if Engine.has_singleton("GlobalVarables"):
		var p = GlobalVarables.player
		if body == p and _attack_timer <= 0.0:
			_perform_attack()
			_attack_timer = attack_cooldown

func take_damage(amount: int) -> void:
	# Called by player weapons or other scripts
	health = max(health - amount, 0)
	# Play hit animation/vfx
	#if _anim and _anim.has_animation("hit"):
	#	_anim.play("hit")
	if attack_vfx:
		var v = attack_vfx.instantiate()
		if v:
			get_tree().get_current_scene().add_child(v)
			v.global_transform.origin = global_transform.origin
	if health <= 0:
		_die()

func _die() -> void:
	# Play death animation/sound then free
	#if _anim and _anim.has_animation("death"):
	#	_anim.play("death")
	#if _audio and _audio.stream:
	#	_audio.play()
	# Disable movement/area to avoid further interactions
	if _nav_agent:
		_nav_agent.enabled = false
	if _attack_area:
		_attack_area.monitoring = false
	if has_node("CollisionShape3D"):
		$CollisionShape3D.disabled = true

	# Emit died signal and notify global handler if present
	emit_signal("died", self)
	if Engine.has_singleton("GlobalVarables") and GlobalVarables.has_method("enemy_died"):
		GlobalVarables.enemy_died(self)

	# Wait a moment for animation/sound
	await get_tree().create_timer(1.0).timeout
	queue_free()

func _do_attack() -> void:
	if not _player:
		return
	# Hit verification: angle and raycast to ensure target is in front and visible
	var to_player: Vector3 = _player.global_transform.origin - global_transform.origin
	var dist := to_player.length()
	if dist > attack_radius:
		return

	# Forward direction (Godot -Z is forward)
	var forward = -global_transform.basis.z.normalized()
	var dir_norm = to_player.normalized()
	# require roughly within 60 degrees cone in front
	var min_dot = cos(deg_to_rad(60))
	if forward.dot(dir_norm) < min_dot:
		return

	# Raycast to player to ensure no obstacles between
	var space = get_world_3d().direct_space_state
	var from_pos = global_transform.origin
	var to_pos = _player.global_transform.origin
	var exclude = [self]
	var params = PhysicsRayQueryParameters3D.new()
	params.from = from_pos
	params.to = to_pos
	params.exclude = exclude
	var res = space.intersect_ray(params)
	if res.empty() or not res.has("collider"):
		return
	var collider = res["collider"]
	if collider != _player:
		# Hit something else before reaching player
		return

	# Damage call
	if _player.has_method("take_damage"):
		_player.take_damage(damage)
	elif _player.has_method("apply_damage"):
		_player.apply_damage(damage)
	else:
		print("Enemy tried to deal %d damage but player has no damage API" % damage)

	# Knockback: try player's API, else nudge the player's velocity directly
	var knock_dir = dir_norm
	var kb = knock_dir * knockback_strength
	if _player.has_method("apply_knockback"):
		_player.apply_knockback(kb)
	else:
		if _player.has_variable("velocity"):
			_player.velocity += kb
