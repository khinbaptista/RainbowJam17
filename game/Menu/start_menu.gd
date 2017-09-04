extends Control

export(String, FILE, "*.tscn") var next_scene

onready var button_start	= get_node("start")
onready var button_quit		= get_node("quit")

var focused_button
var music

func _ready():
	button_start.connect("pressed", self, "pressed_start")
	button_quit.connect("pressed", self, "pressed_quit")
	
	button_start.connect("mouse_enter", self, "changed_focus", [button_start])
	button_quit.connect("mouse_enter", self, "changed_focus", [button_quit])
	
	changed_focus(button_start)
	
	set_process_input(true)
	
	music = get_node("SamplePlayer2D")
	var sample = music.get_sample_library().get_sample("menu")
	sample.set_loop_format(sample.LOOP_FORWARD)
	sample.set_loop_begin(0)
	sample.set_loop_end(sample.get_length())
	music.play("menu")

func _input(event):
	if event.is_action_pressed("ui_up") and not event.is_echo():
		changed_focus(button_start)
	
	elif event.is_action_pressed("ui_down") and not event.is_echo():
		changed_focus(button_quit)
	
	elif event.is_action_pressed("ui_accept") and not event.is_echo():
		focused_button.emit_signal("pressed")

func changed_focus(button):
	if focused_button != null:
		focused_button.get_node("focus").hide()
	
	focused_button = button
	focused_button.get_node("focus").show()

func pressed_start():
	print("Start")
	music.stop_all()
	get_node("/root/loader").change_scene(next_scene)
#	get_tree().change_scene_to(next_scene)

func pressed_quit():
	print("Quit")
	get_tree().quit()
