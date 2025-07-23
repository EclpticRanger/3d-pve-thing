extends Control

signal update_button(actionName: String, newText: String)  # swap order to match emit

var modify_control: bool = false
var modify_action: String

func _input(event: InputEvent) -> void:
	if not modify_control or event is InputEventMouseMotion or !InputMap.has_action(modify_action):
		return
	
	InputMap.action_erase_events(modify_action)
	InputMap.action_add_event(modify_action, event)
	
	modify_control = false
	
	update_button.emit(modify_action, event.as_text())

func update_control(newer_action: String):
	modify_action = newer_action
	modify_control = true
