extends CharacterBody3D

@export_group("Movement")
@export var gravity: int = 20
@export var BACE_MOVE_SPEED: float = 10
@export var sprint_moderfer: float = 1.6
@export var Bace_ACCELORATION: float = 10
@export var BACE_JUMP_INPULSE: float = 7.5
@export var turn_speed := 12.0

#@export_group("Character")
#@export_subgroup("Knight")
#@export var Knight_path = load("")
#@export_subgroup("Rouge")
#@export var Rouge_path = load("")
#@export_subgroup("Paladin")
#@export var Paladin_path = load("")
#@export_subgroup("Archer")
#@export var Archer_path = load("")
#@export_subgroup("Warlock")
#@export var Warlock_path = load("")
#@export_subgroup("Mage")
#@export var Mage_path = load("")

@onready var Camera_pivot: Node3D = $Camera_pivot
@onready var Camera: Camera3D = $Camera_pivot/Camera3D
@onready var temp_moddle: MeshInstance3D = $MeshInstance3D

var speed_moderfier: float = 1
var acceloration_moderfier: float = 1
var jump_inmpulse_moderfier: float = 1

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * 1))
		Camera_pivot.rotate_x(deg_to_rad(-event.relative.y * 1))
		Camera_pivot.rotation.x = clamp(Camera_pivot.rotation.x, deg_to_rad(-90), deg_to_rad(45))

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_pressed("jump") and (is_on_floor() or is_on_wall()):
		velocity.y = (BACE_JUMP_INPULSE * jump_inmpulse_moderfier)
	
	
	
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * (BACE_MOVE_SPEED * speed_moderfier) + (1/3 * velocity.x)
		velocity.z = direction.z * (BACE_MOVE_SPEED * speed_moderfier) + (1/3 * velocity.z)
	else:
		velocity.x = move_toward(velocity.x, 0, (BACE_MOVE_SPEED * speed_moderfier) + (1/3 * velocity.x))
		velocity.z = move_toward(velocity.z, 0, (BACE_MOVE_SPEED * speed_moderfier) + (1/3 * velocity.z))

	move_and_slide()
	
	
