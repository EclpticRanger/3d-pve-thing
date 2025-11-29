class_name playerer # this is purposly mispelled
extends CharacterBody3D 

@export_group("Movement")
@export var gravity: int = -20
@export var BACE_MOVE_SPEED: float = 10
@export var sprint_modifier: float = 1.6
@export var Bace_ACCELORATION: float = 10
@export var BACE_JUMP_INPULSE: float = 7.5
@export var turn_speed := 12.0
@export var nav_type = "player"

#Speed modifier is 1 * modifier * modifier... Max 2.5
#Stealth modifier is detchtable distance / (modifier * modifier) Max 2
#Defence modifier is incoming damage * (Defence modifier * Defence modifier)
@export_group("Character")
@export_subgroup("Knight")
@export var Knight_speed_modifier: float = 0.9
@export var Knight_stealth_modifier: float = 1
@export var Knight_defence_modifier: float = 0.7
@export_subgroup("Rouge")
@export var Rouge_speed_modifier: float = 1.3
@export var Rouge_stealth_modifier: float = 1.5
@export var Rouge_defence_modifier: float = 1
@export_subgroup("Paladin")
@export var Paladin_speed_modifier: float = 0.9
@export var Paladin_stealth_modifier: float = 0.9
@export var Paladan_defence_modifier: float = 0.5
@export_subgroup("Archer")
@export var Archer_speed_modifier: float = 1.2
@export var Archer_stealth_modifier: float = 1.3
@export var Archer_defence_modifier: float = 1.15
@export_subgroup("Warlock")
@export var Warlock_speed_modifier: float = 1
@export var Warlock_stealth_modifier: float = 1.2
@export var Warlock_defence_modifier: float = 0.852
@export_subgroup("Mage")
@export var Mage_speed_modifier: float = 1.1
@export var Mage_stealth_modifier: float = 1.1
@export var Mage_defence_modifier: float = 1.3

@onready var knight_anamation_handerler = $"Character Model/Knight/AnimationPlayer"
@onready var Rouge_anamation_handerler = $"Character Model/Rogue/AnimationPlayer"
@onready var Paladan_anamation_handerler = $"Character Model/Paladan/AnimationPlayer"
@onready var Archer_anamation_handerler = $"Character Model/Archer/AnimationPlayer"
@onready var Warlock_anamation_handerler = $"Character Model/Warlock/AnimationPlayer"
@onready var Mage_anamation_handerler = $"Character Model/Mage/AnimationPlayer"
#Charter ids Knight: 0, Rouge: 1, Paladin: 2, Archer: 3, Warlock 4, Mage: 5
var Character_id = 0

@onready var Camera_pivot: Node3D = $Camera_pivot
@onready var Camera: Camera3D = $Camera_pivot/Camera3D
@onready var Healthbar = $CanvasLayer/Node2D/Health/AnimatedSprite2D
@onready var _Staminabar = $CanvasLayer/Node2D/Stamina/AnimatedSprite2D

var speed_modifier: float = 1
var acceloration_modifier: float = 1
var jump_inmpulse_modifier: float = 1
var input_dir: Vector2
var health = 10
var stamina = 300
var stamina_used: bool = false
var attack_animating = false

var mage_fireball = preload("res://Player/attacks/mage/fireball.tscn")
var warlock_Acidball = preload("res://Player/attacks/Warlock/Acidball.tscn")
var archer_arrow = preload("res://Player/attacks/Archer/arrow.tscn")
var instance

const stamina_max = 300

var Character_speed_Moderfiers = [Knight_speed_modifier, Rouge_speed_modifier, Paladin_speed_modifier, Archer_speed_modifier, Warlock_speed_modifier, Mage_speed_modifier]
var Character_defance_moderfier = [Knight_defence_modifier, Rouge_defence_modifier, Paladan_defence_modifier, Archer_defence_modifier, Warlock_defence_modifier, Mage_defence_modifier]

func Character_Showm_update():
	$"Character Model/Knight".hide()
	$"Character Model/Knight/Rig/Skeleton3D/Knight_Head".hide()
	$"CanvasLayer/Node2D/Character Icons/Knight".hide()
	$"Character Model/Rogue".hide()
	$"Character Model/Rogue/Rig/Skeleton3D/Rogue_Head_Hooded".hide()
	$"CanvasLayer/Node2D/Character Icons/Rouge".hide()
	$"Character Model/Paladan".hide()
	$"Character Model/Paladan/Rig/Skeleton3D/Knight_Helmet/Knight_Helmet".hide()
	$"Character Model/Paladan/Rig/Skeleton3D/Knight_Head".hide()
	$"CanvasLayer/Node2D/Character Icons/Paladin".hide()
	$"Character Model/Archer".hide()
	$"Character Model/Archer/Rig/Skeleton3D/Rogue_Head".hide()
	$"CanvasLayer/Node2D/Character Icons/Archer".hide()
	$"Character Model/Warlock".hide()
	$"Character Model/Warlock/Rig/Skeleton3D/Mage_Head".hide()
	$"Character Model/Mage".hide()
	$"CanvasLayer/Node2D/Character Icons/Mage".hide()
	$"Character Model/Mage/Rig/Skeleton3D/Mage_Head".hide()
	$"Character Model/Mage/Rig/Skeleton3D/Mage_Hat/Mage_Hat".hide()
	if Character_id == 0: 
		$"Character Model/Knight".show()
		$"CanvasLayer/Node2D/Character Icons/Knight".show()
	elif Character_id == 1: 
		$"Character Model/Rogue".show()
		$"CanvasLayer/Node2D/Character Icons/Rouge".show()
	elif Character_id == 2: 
		$"Character Model/Paladan".show()
		$"CanvasLayer/Node2D/Character Icons/Paladin".show()
	elif Character_id == 3: 
		$"Character Model/Archer".show()
		$"CanvasLayer/Node2D/Character Icons/Archer".show()
	elif Character_id == 4: 
		$"Character Model/Warlock".show()
	elif Character_id == 5: 
		$"Character Model/Mage".show()
		$"CanvasLayer/Node2D/Character Icons/Mage".show()
	else: get_tree().quit()

func _enter_tree() -> void:
	set_multiplayer_authority(str(name).to_int())
	if is_multiplayer_authority(): GlobalVarables.player = self

func _ready() -> void:
	if not is_multiplayer_authority(): return
	Camera.current = true
	Healthbar.play("Full 10")
	# Only check authority if in multiplayer, otherwise always run

func _input(event: InputEvent) -> void:
	if not is_multiplayer_authority(): return
	# Handle Escape key to go to main menu
	if GlobalVarables.player_state:
		if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
			go_to_main_menu()
			return
		if event is InputEventMouseMotion and not GlobalVarables.controler_mode:
			rotate_y(deg_to_rad(-event.relative.x * (GlobalVarables.mouse_sensitivity/1000)))
			Camera_pivot.rotate_x(deg_to_rad(-event.relative.y * (GlobalVarables.mouse_sensitivity/1000)))
			Camera_pivot.rotation.x = clamp(Camera_pivot.rotation.x, deg_to_rad(-45), deg_to_rad(90))
		# Mouse Direction Control

func go_to_main_menu():
	# TODO: Replace this with your actual main menu scene path
	get_tree().change_scene_to_file("res://Ui/Start Menue/Main.tscn")

func handle_animation():
	if not attack_animating:
		if Input.is_action_just_pressed("jump") and is_on_floor():
			play_animation("Jump_Start", 1.5)
		elif velocity.y < 0 and is_on_floor():
			play_animation("Jump_Land", 1.5)
		elif not is_on_floor():
			play_animation("Jump_Idle", 1)
		elif (Input.is_action_pressed("sprint") or Input.is_joy_button_pressed(0, JOY_BUTTON_RIGHT_SHOULDER)) and (abs(velocity.x)>0 or abs(velocity.z)>0):
			if input_dir.y < -0.5:
				play_animation("Running_A", 2)
			elif input_dir.x < -0.5:
				play_animation("Running_Strafe_Left", 2)
			elif input_dir.x > 0.5:
				play_animation("Running_Strafe_Right", 2)
			elif input_dir.y > 0.5:
				play_animation("Running_A_Backwords", 2)
		elif not (Input.is_action_pressed("sprint") or Input.is_joy_button_pressed(0, JOY_BUTTON_RIGHT_SHOULDER)) and (abs(velocity.x)>0 or abs(velocity.z)>0):
			if input_dir.y < -0.5:
				play_animation("Walking_A", 1.5)
			elif input_dir.x < -0.5:
				play_animation("Running_Strafe_Left", 1)
			elif input_dir.x > 0.5:
				play_animation("Running_Strafe_Right", 1)
			elif input_dir.y > 0.5:
				play_animation("Walking_Backwards", 1.5)
		else:
			play_animation("Idle", 1)

func play_animation(animation: String, Speed: float):
	if Character_id == 0:#Knight
		knight_anamation_handerler.speed_scale = Speed
		if animation == "Running_A_Backwords": knight_anamation_handerler.play_backwards("Running_A")
		else: knight_anamation_handerler.play(animation)
	elif Character_id == 1:# Rouge
		Rouge_anamation_handerler.speed_scale = Speed
		if animation == "Running_A_Backwords": Rouge_anamation_handerler.play_backwards("Running_A")
		else: Rouge_anamation_handerler.play(animation)
	elif Character_id == 2: #Paladin
		Paladan_anamation_handerler.speed_scale = Speed
		if animation == "Running_A_Backwords": Paladan_anamation_handerler.play_backwards("Running_A")
		else: Paladan_anamation_handerler.play(animation)
	elif Character_id == 3:#Archer
		Archer_anamation_handerler.speed_scale = Speed
		if animation == "Running_A_Backwords": Archer_anamation_handerler.play_backwards("Running_A")
		else: Archer_anamation_handerler.play(animation)
	elif Character_id == 4:#Warlock
		Warlock_anamation_handerler.speed_scale = Speed
		if animation == "Running_A_Backwords": Warlock_anamation_handerler.play_backwards("Running_A")
		else: Warlock_anamation_handerler.play(animation)
	elif Character_id == 5:#MAge
		Mage_anamation_handerler.speed_scale = Speed
		if animation == "Running_A_Backwords": Mage_anamation_handerler.play_backwards("Running_A")
		else: Mage_anamation_handerler.play(animation)
	else:
		print("charter id out of range????")

func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority(): return
	
	stamina_used = false
	if GlobalVarables.player_state:
		if GlobalVarables.controler_mode:
			var deadzone = 0.1
			var raw_yaw = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
			var raw_pitch = Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
			var sensitivity = GlobalVarables.mouse_sensitivity / -3000.0
			var yaw_input = raw_yaw * sensitivity if abs(raw_yaw) > deadzone else 0.0
			var pitch_input = raw_pitch * sensitivity if abs(raw_pitch) > deadzone else 0.0
			rotate_y(yaw_input)
			Camera_pivot.rotation.x = clamp(Camera_pivot.rotation.x + pitch_input, deg_to_rad(-90), deg_to_rad(90))
			# Right Sitck Camera Contros
	
		if not is_on_floor():
			velocity.y += gravity * delta
			stamina -= (2.0/3.0)*delta
			stamina_used = true

	# Handle jump.
		if Input.is_action_pressed("jump") and not GlobalVarables.controler_mode and is_on_floor() and stamina > 30:
			velocity.y = (BACE_JUMP_INPULSE * jump_inmpulse_modifier)
			stamina -=30
			stamina_used = true
		#Handle jump with keybord
		elif Input.is_joy_button_pressed(0, JOY_BUTTON_A) and GlobalVarables.controler_mode and is_on_floor() and stamina > 30:
			velocity.y = (BACE_JUMP_INPULSE * jump_inmpulse_modifier)
			stamina -=30
			stamina_used = true
		#handle jump with controler
	
		if GlobalVarables.controler_mode:
			input_dir = Vector2(Input.get_joy_axis(0, JOY_AXIS_LEFT_X), Input.get_joy_axis(0, JOY_AXIS_LEFT_Y))
		if input_dir.length() > 1:
			input_dir = input_dir.normalized()
		#get move input with controler
		else:
			input_dir = Input.get_vector("left", "right", "forward", "back")
			#get move input with keybord
			
		if Input.is_action_pressed("sprint") and not GlobalVarables.controler_mode and stamina > 10:
			speed_modifier = Character_speed_Moderfiers[Character_id] * 1.5
			if (input_dir.x > 0.1 or input_dir.x < -0.1) or (input_dir.y > 0.1 or input_dir.y < -0.1):
				stamina -= 15 * delta
				stamina_used = true
			
		elif Input.is_joy_button_pressed(0, JOY_BUTTON_RIGHT_SHOULDER) and GlobalVarables.controler_modeand and stamina > 10:
			speed_modifier = Character_speed_Moderfiers[Character_id] * 1.5
			if (input_dir.x > 0.1 or input_dir.x < -0.1) or (input_dir.y > 0.1 or input_dir.y < -0.1):
				stamina -= 15 * delta
				stamina_used = true
		else:
			speed_modifier = Character_speed_Moderfiers[Character_id]
		
		if input_dir.length() > 0.1:
			var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
			velocity.x = direction.x * (BACE_MOVE_SPEED * speed_modifier)
			velocity.z = direction.z * (BACE_MOVE_SPEED * speed_modifier)
		else:
			velocity.x = move_toward(velocity.x, 0, (BACE_MOVE_SPEED * speed_modifier))
			velocity.z = move_toward(velocity.z, 0, (BACE_MOVE_SPEED * speed_modifier))
	#control movement
		move_and_slide()
		
		if not stamina_used and stamina < stamina_max:
			if stamina < 10:
				stamina += delta
			else:
				stamina += 15*delta
		_update_stamina()
		_attack_1()
	handle_animation()

func _update_health():
	if health == 10: Healthbar.play("Full 10")
	elif health == 0: 
		Healthbar.play("0 Empty")
		death()
	elif health < 10 and health > 0:
		Healthbar.play(str(health))
	elif health > 10: 
		health = 10
		_update_health()
	elif health > 0: death()
	else: get_tree().quit()
	
func death():
	global_position = Vector3.ZERO
	health = 10
	_update_health()

func _on_damage(_area: Area3D) -> void:
	health -= 1
	_update_health()

func _update_stamina():
	if stamina >= 300: _Staminabar.play("Full 30")
	elif stamina <10*1.1: _Staminabar.play("0 Empty")
	else: _Staminabar.play(str(int(floor(stamina/10))))

func _attack_1():
	if Input.is_action_just_pressed("attack") and not attack_animating:
		if Character_id == 0:
			knight_anamation_handerler.play("1H_Melee_Attack_Slice_Diagonal")
			$"Character Model/Knight/Rig/Skeleton3D/2H_Sword/RayCast3D".enabled = true
			$"Node/Knight/Knight attack".start()
			attack_animating = true
		if Character_id == 1:
			Rouge_anamation_handerler.play("1H_Melee_Attack_Slice_Diagonal")
			$"Character Model/Rogue/Rig/Skeleton3D/Knife/Knife/RayCast3D".enabled = true
			$"Node/Rouge/Rouge attack".start()
			attack_animating = true
		elif Character_id == 3 and stamina > 10:
			play_animation("1H_Ranged_Shoot", 2)
			instance = archer_arrow.instantiate()
			instance.position = Camera.global_position
			instance.transform.basis = Camera.global_transform.basis
			attack_animating = true
			$"Node/Archer/Archer attack".start()
			get_parent().add_child(instance)
			stamina -= 10
		elif Character_id == 4 and stamina > 10:
			play_animation("Spellcast_Shoot", 2)
			instance = warlock_Acidball.instantiate()
			instance.position = Camera.global_position
			instance.transform.basis = Camera.global_transform.basis
			attack_animating = true
			$"Node/Mage/Mage attack".start()
			get_parent().add_child(instance)
			stamina -= 10
		elif Character_id == 5 and stamina > 10:
			play_animation("Spellcast_Shoot", 2)
			attack_animating = true
			$"Node/Mage/Mage attack".start()
			stamina -= 10
			instance = mage_fireball.instantiate()
			instance.position = Camera.global_position
			instance.transform.basis = Camera.global_transform.basis
			get_parent().add_child(instance)

func _on_knight_attack_timeout() -> void:
	attack_animating = false
	$"Character Model/Knight/Rig/Skeleton3D/2H_Sword/RayCast3D".enabled = false
func _on_rouge_attack_timeout() -> void:
	attack_animating = false
	$"Character Model/Rogue/Rig/Skeleton3D/Knife/Knife/RayCast3D".enabled = false
func _on_mage_attack_timeout() -> void:
	attack_animating = false
func _on_archer_attack_timeout() -> void:
	attack_animating = false
func _on_warlock_attack_timeout() -> void:
	attack_animating = false
