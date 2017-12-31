extends Control

export(String, FILE, "*.tscn") var next_scene

onready var button_start = get_node("ButtonGroup/Play")
onready var button_quit  = get_node("ButtonGroup/Exit")

var focused_button
var music

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.warp_mouse_pos(Vector2(100, 100))

	button_start.connect("pressed", self, "pressed_start")
	button_quit.connect("pressed", self, "pressed_quit")

	button_start.connect("mouse_enter", self, "changed_focus", [button_start])
	button_quit.connect("mouse_enter", self, "changed_focus", [button_quit])
	
	button_start.grab_focus()

func pressed_start():
	Input.start_joy_vibration(0, 0.4, 0.4, 0.1)
	print("Start")
	get_node("/root/loader").change_scene(next_scene)

func pressed_quit():
	print("Quit")
	get_tree().quit()
