extends Button

@export var action_name: String
@onready var setings_root_node = $"../../../../../../../"

func _ready() -> void:
	pressed.connect(self.on_button_clicked)  # add 'self.' or use 'self.pressed.connect'
	ControlsMannger.update_button.connect(recive_new_text_data)  # fix typo in manager name
	#recive_new_text_data(action_name, Setings.keybinds[action_name])

func on_button_clicked():
	ControlsMannger.update_control(action_name)

func recive_new_text_data(act_name: String, new_button_name: String):
	if act_name != action_name:
		return
	self.text = new_button_name
