extends CharacterBody3D

@export_group("Movement")
@export var gravity: int = -20
@export var BACE_MOVE_SPEED: float = 30
@export var sprint_moderfer: float = 1.6
@export var Bace_ACCELORATION: float = 10
@export var BACE_JUMP_INPULSE: float = 20

@export_group("Character")
@export_subgroup("Knight")
@export var Knight_path = load("")
@export_subgroup("Rouge")
@export var Rouge_path = load("")
@export_subgroup("Paladin")
@export var Paladin_path = load("")
@export_subgroup("Archer")
@export var Archer_path = load("")
@export_subgroup("Worlock")
@export var Worlock_path = load("")
@export_subgroup("Mage")
@export var Mage_path = load("")

@onready var Camera_pivot: Node3D = $Camera_pivot

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	rotate_y(deg_to_rad(-event.relative.x * 10))
	Camera_pivot.rotate_x(deg_to_rad(-event.relative.y * 10))
	Camera_pivot.rotation.x = clamp(Camera_pivot.rotation.x, deg_to_rad(-90), deg_to_rad(45))

func _physics_process(delta: float) -> void:
	pass
	
	
	
	
