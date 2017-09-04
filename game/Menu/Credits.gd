extends Control

onready var button_back	= get_node("back")

func _ready():
	button_back.connect("pressed", self, "pressed_back")
	
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_accept") and not event.is_echo():
		button_back.emit_signal("pressed")

func pressed_back():
	print("Back")
	var start_scene = load("res://Menu/start_menu.tscn")
	get_tree().change_scene(start_scene)
