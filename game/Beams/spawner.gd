extends Node

# 1, 2, 4, 8 ...
export(int, FLAGS, "None", "Red", "Orange", "Yellow", "Green", "Blue", "Violet") var colors = 1

export(PackedScene) var beam_scene

var interrupt = false

func _ready():
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("beams") and not event.is_echo():
		interrupt = false
		spawn()

func color2bit(value):
	if value == 2: return 1
	if value == 4: return 2
	if value == 8: return 3
	if value == 16: return 4
	if value == 32: return 5
	if value == 64: return 6
	return 0

func spawn():
	if colors & 2:
		var beam = beam_scene.instance()
		beam.set_global_pos(get_parent().get_global_pos())
		beam.set_color(color2bit(2))
		add_child(beam)
		beam.spawn()
