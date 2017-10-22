extends Control

export(String, FILE, "*.tscn") var next_scene

onready var button_start	= get_node("start")
onready var button_quit		= get_node("quit")

var focused_button
var music

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	#Input.warp_mouse_pos(Vector2(10000, 10000))

	button_start.connect("pressed", self, "pressed_start")
	button_quit.connect("pressed", self, "pressed_quit")

	button_start.connect("mouse_enter", self, "changed_focus", [button_start])
	button_quit.connect("mouse_enter", self, "changed_focus", [button_quit])

	changed_focus(button_start)

	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_up") and not event.is_echo():
		changed_focus(button_start)

	elif event.is_action_pressed("ui_down") and not event.is_echo():
		changed_focus(button_quit)

	elif event.is_action_pressed("ui_accept") and not event.is_echo():
		focused_button.emit_signal("pressed")

func changed_focus(button):
	Input.start_joy_vibration(0, 0.4, 0.4, 0.1)
	if focused_button != null:
		focused_button.get_node("focus").hide()

	focused_button = button
	focused_button.get_node("focus").show()

func pressed_start():
	Input.start_joy_vibration(0, 0.4, 0.4, 0.1)
	print("Start")
	get_node("/root/loader").change_scene(next_scene)

func pressed_quit():
	print("Quit")
	get_tree().quit()
