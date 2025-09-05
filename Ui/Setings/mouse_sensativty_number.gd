extends Label

func _on_h_slider_value_changed(value: float) -> void:
	self.text = str(value) + "%"
