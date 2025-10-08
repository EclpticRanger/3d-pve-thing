extends CharacterBody3D

@export_group("Movement")
@export var gravity: int = -20
@export var BACE_MOVE_SPEED: float = 10
@export var sprint_modifier: float = 1.6
@export var Bace_ACCELORATION: float = 10
@export var BACE_JUMP_INPULSE: float = 7.5
@export var turn_speed := 12.0

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
@onready var Rouge_anamation_handerler
@onready var Paladan_anamation_handerler
@onready var Archer_anamation_handerler
@onready var Warlock_anamation_handerler
@onready var Mage_anamation_handerler
#Charter ids Knight: 0, Rouge: 1, Paladin: 2, Archer: 3, Warlock 4, Mage: 5
var Character_id = 0

@onready var Camera_pivot: Node3D = $Camera_pivot
@onready var Camera: Camera3D = $Camera_pivot/Camera3D

var speed_modifier: float = 1
var acceloration_modifier: float = 1
var jump_inmpulse_modifier: float = 1
var input_dir: Vector2

var Character_speed_Moderfiers = [Knight_speed_modifier, Rouge_speed_modifier, Paladin_speed_modifier, Archer_speed_modifier, Warlock_speed_modifier, Mage_speed_modifier]
var Character_defance_moderfier = [Knight_defence_modifier, Rouge_defence_modifier, Paladan_defence_modifier, Archer_defence_modifier, Warlock_defence_modifier, Mage_defence_modifier]

func _enter_tree() -> void:
	# In multiplayer, set authority based on node name (peer id). In single player, set to local peer.
	if get_tree().get_multiplayer().has_multiplayer_peer():
		if get_tree().get_multiplayer().is_server():
			set_multiplayer_authority(str(name).to_int())
		else:
			set_multiplayer_authority(get_tree().get_multiplayer().get_unique_id())

func _ready() -> void:
	# Only check authority if in multiplayer, otherwise always run
	if get_tree().get_multiplayer().has_multiplayer_peer():
		if not is_multiplayer_authority():
			return
	Camera.current = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	GlobalVarables.player = self

func _input(event: InputEvent) -> void:
	if get_tree().get_multiplayer().has_multiplayer_peer():
		if not is_multiplayer_authority():
			return
	# Handle Escape key to go to main menu
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		go_to_main_menu()
		return
	if event is InputEventMouseMotion and not GlobalVarables.controler_mode:
		rotate_y(deg_to_rad(-event.relative.x * (GlobalVarables.mouse_sensitivity/1000)))
		Camera_pivot.rotate_x(deg_to_rad(-event.relative.y * (GlobalVarables.mouse_sensitivity/1000)))
		Camera_pivot.rotation.x = clamp(Camera_pivot.rotation.x, deg_to_rad(-90), deg_to_rad(90))
		# Mouse Direction Control
func go_to_main_menu():
	# TODO: Replace this with your actual main menu scene path
	get_tree().change_scene_to_file("res://Ui/Start Menue/Main.tscn")

func handle_animation():
	
	if (Input.is_action_pressed("sprint") or Input.is_joy_button_pressed(0, JOY_BUTTON_RIGHT_SHOULDER)) and (abs(velocity.x)>0 or abs(velocity.z)>0):
		if input_dir.y > 0.5:
			play_animation.rpc("Running_A", 2)
		elif input_dir.x < -0.5:
			play_animation.rpc("Running_Strafe_Left", 2)
		elif input_dir.y > 0.5:
			play_animation("Running_Strafe_Right", 2)
		elif input_dir.y > 0.5:
			play_animation.rpc("Running_A", 2)
	elif not (Input.is_action_pressed("sprint") or Input.is_joy_button_pressed(0, JOY_BUTTON_RIGHT_SHOULDER)) and (abs(velocity.x)>0 or abs(velocity.z)>0):
		play_animation.rpc("Walking_A", 1.5)
	else:
		play_animation.rpc("Idle", 1)

@rpc("call_local")
func play_animation(animation: String, Speed: float):
	
	if Character_id == 0:
		knight_anamation_handerler.speed_scale = Speed
		knight_anamation_handerler.play(animation)
	elif Character_id == 1:
		pass
	elif Character_id == 2:
		pass
	elif Character_id == 3:
		pass
	elif Character_id == 4:
		pass
	elif Character_id == 5:
		pass
	else:
		print("charter id out of range????")

func _physics_process(delta: float) -> void:
	if get_tree().get_multiplayer().has_multiplayer_peer():
		if not is_multiplayer_authority():
			return
	
	if GlobalVarables.controler_mode:
		var deadzone = 0.1
		var raw_yaw = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
		var raw_pitch = Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
		var sensitivity = GlobalVarables.mouse_sensitivity / -3000.0
		var yaw_input = raw_yaw * sensitivity if abs(raw_yaw) > deadzone else 0.0
		var pitch_input = raw_pitch * sensitivity if abs(raw_pitch) > deadzone else 0.0
		rotate_y(yaw_input)
		Camera_pivot.rotation.x = clamp(Camera_pivot.rotation.x + pitch_input, deg_to_rad(-90), deg_to_rad(90))
		# Right Sitck Camera Control
	
	if Input.is_action_pressed("sprint") and not GlobalVarables.controler_mode:
		speed_modifier = Character_speed_Moderfiers[Character_id] * 1.5
	elif Input.is_joy_button_pressed(0, JOY_BUTTON_RIGHT_SHOULDER) and GlobalVarables.controler_mode:
		speed_modifier = Character_speed_Moderfiers[Character_id] * 1.5
	else:
		speed_modifier = Character_speed_Moderfiers[Character_id]
	
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_pressed("jump") and not GlobalVarables.controler_mode and is_on_floor():
		velocity.y = (BACE_JUMP_INPULSE * jump_inmpulse_modifier)
		#Handle jump with keybord
	elif Input.is_joy_button_pressed(0, JOY_BUTTON_A) and GlobalVarables.controler_mode and is_on_floor():
		velocity.y = (BACE_JUMP_INPULSE * jump_inmpulse_modifier)
		#handle jump with controler
	
	if GlobalVarables.controler_mode:
		input_dir = Vector2(Input.get_joy_axis(0, JOY_AXIS_LEFT_X), Input.get_joy_axis(0, JOY_AXIS_LEFT_Y))
		if input_dir.length() > 1:
			input_dir = input_dir.normalized()
		#get move input with controler
	else:
		input_dir = Input.get_vector("left", "right", "forward", "back")
		#get move input with keybord
	if input_dir.length() > 0.1:
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		velocity.x = direction.x * (BACE_MOVE_SPEED * speed_modifier)
		velocity.z = direction.z * (BACE_MOVE_SPEED * speed_modifier)
	else:
		velocity.x = move_toward(velocity.x, 0, (BACE_MOVE_SPEED * speed_modifier))
		velocity.z = move_toward(velocity.z, 0, (BACE_MOVE_SPEED * speed_modifier))
	#control movement
	move_and_slide()
	handle_animation()
