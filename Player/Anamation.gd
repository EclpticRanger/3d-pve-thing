extends AnimationTree

@export var knight_anamation_player_path: NodePath

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim_player = knight_anamation_player_path


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
