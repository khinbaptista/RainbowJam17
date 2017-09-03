extends Control

export(PackedScene) var next_scene

onready var button_back	= get_node("back")

func _ready():
	button_back.connect("pressed", self, "pressed_back")
	
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_accept") and not event.is_echo():
		button_back.emit_signal("pressed")

func pressed_back():
	print("Back")
	get_tree().change_scene_to(next_scene)
