extends CharacterBody3D


const move_speed = 5.0
const jump_impulse = 4.5

@onready var cam_pivot = $"Camera Orgin"
@onready var camera = $"Camera Orgin/SpringArm3D/Camera3D"

@export_range(0.1, 1.0) var mouse_sensertivity = 0.5

func _ready() -> void:
	Input.MOUSE_MODE_CAPTURED
	camera.current = is_multiplayer_authority()

func _enter_tree():
	set_multiplayer_authority(name.to_int())

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensertivity))
		cam_pivot.rotate_x(deg_to_rad(-event.relative.y * mouse_sensertivity))
		cam_pivot.rotation.x = clamp(cam_pivot.rotation.x, deg_to_rad(-90), deg_to_rad(45))

func _physics_process(delta: float) -> void:
	if is_multiplayer_authority():
		
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = jump_impulse
	
		if Input.is_action_just_pressed("quit"):
			$"../".exit_game(name.to_int())
			get_tree().quit( )
	
		var input_dir := Input.get_vector("left", "right", "forward", "back")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * move_speed
			velocity.z = direction.z * move_speed
		else:
			velocity.x = move_toward(velocity.x, 0, move_speed)
			velocity.z = move_toward(velocity.z, 0, move_speed)

		move_and_slide()
