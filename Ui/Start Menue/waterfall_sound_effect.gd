extends AudioStreamPlayer3D

func _ready() -> void:
	volume_db = -215 # makes volume sensable level

func _on_timer_timeout() -> void:
	AudioServer.set_bus_mute(1, false)
