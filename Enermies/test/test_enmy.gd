extends CharacterBody3D

var move_speed = 50000
var dir = Vector3(0, 0, 0)
var min_range: int = 200

var player = null

@onready var nav_agent := $NavigationAgent3D as NavigationAgent3D

func _physics_process(delta: float) -> void:
		velocity += get_gravity()
		if not nav_agent.is_navigation_finished():
			var next_pos = nav_agent.get_next_path_position()
			var dir3 = (next_pos - global_transform.origin).normalized()
			velocity.x = dir3.x * move_speed * delta
			velocity.z = dir3.z * move_speed * delta
		else:
			velocity.x = move_toward(velocity.x, 0, move_speed * delta)
			velocity.z = move_toward(velocity.z, 0, move_speed * delta)
		move_and_slide()

func _process(_delta: float) -> void:
	if not player and GlobalVarables.player:
		player = GlobalVarables.player

func _make_path() -> void:
	if player and player.global_transform:
		nav_agent.target_position = player.global_transform.origin
	else:
		print("Player is not set or does not have a position.")
	
func _on_timer_timeout() -> void:
	_make_path()

func _ready() -> void:
	var timer = Timer.new()
	timer.wait_time = 0.5
	timer.autostart = true
	timer.one_shot = false
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	add_child(timer)
