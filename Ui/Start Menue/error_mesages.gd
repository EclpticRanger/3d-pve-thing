extends Control



func _on_button_pressed() -> void:
	$PanelContainer.hide()
	$"PanelContainer/Out of Range".hide()
	$PanelContainer/Button.hide()

func invalid_input():
	$PanelContainer.show()
	$"PanelContainer/Invalid Input".show()
	$PanelContainer/Button.show()

func out_of_range():
	$PanelContainer.show()
	$PanelContainer/Button.show()
	$"PanelContainer/Out of Range".show()
