extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.volume_db = -120
	self.play(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
