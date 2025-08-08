extends CharacterBody3D

@export_group("Movement")
@export var gravity: int = 20
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
@export var Warlock_defence_modifier: float = 0.85
@export_subgroup("Mage")
@export var Mage_speed_modifier: float = 1.1
@export var Mage_stealth_modifier: float = 1.1
@export var Mage_defence_modifier: float = 1.3

@onready var Camera_pivot: Node3D = $Camera_pivot
@onready var Camera: Camera3D = $Camera_pivot/Camera3D

var speed_modifier: float = 1
var acceloration_modifier: float = 1
var jump_inmpulse_modifier: float = 1

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * 1))
		Camera_pivot.rotate_x(deg_to_rad(-event.relative.y * 1))
		Camera_pivot.rotation.x = clamp(Camera_pivot.rotation.x, deg_to_rad(-45), deg_to_rad(90))

func _physics_process(delta: float) -> void:
	speed_modifier = Knight_speed_modifier
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_pressed("jump") and (is_on_floor() or is_on_wall()):
		velocity.y = (BACE_JUMP_INPULSE * jump_inmpulse_modifier)
	
	
	
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * (BACE_MOVE_SPEED * speed_modifier) + (1/3 * velocity.x)
		velocity.z = direction.z * (BACE_MOVE_SPEED * speed_modifier) + (1/3 * velocity.z)
	else:
		velocity.x = move_toward(velocity.x, 0, (BACE_MOVE_SPEED * speed_modifier))
		velocity.z = move_toward(velocity.z, 0, (BACE_MOVE_SPEED * speed_modifier))

	move_and_slide()
	
	
