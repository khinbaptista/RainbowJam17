extends Node

export(PackedScene) var ring_scene
export(float, 0.0, 60.0, 0.1) var wait_time = 0.5

onready var player = get_parent()

var position
var colors

var timer
var counter

func _ready():
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("beams") and not event.is_echo():
		spawn()

func spawn():
	for child in get_children():
		if child.has_method("despawn"):
			child.despawn()
	if timer:
		timer.stop()
		timer = null

	position = player.get_global_pos()
	colors = player.colors_learned
	counter = 1

	timer = Timer.new()
	timer.set_one_shot(false)
	timer.set_autostart(true)
	timer.set_wait_time(wait_time)
	timer.connect("timeout", self, "_spawn")
	add_child(timer)
	_spawn()

func mask2string(mask):
	if mask == 2:  return "Red"
	if mask == 4:  return "Orange"
	if mask == 8:  return "Yellow"
	if mask == 16: return "Green"
	if mask == 32: return "Blue"
	if mask == 64: return "Purple"

func _spawn():
	var color_mask = 1 << counter

	while not colors & color_mask and counter <= 6:
		counter += 1
		color_mask = 1 << counter

	if counter > 6:
		timer.stop()
		timer.queue_free()
		timer = null
		return

	var color_string = mask2string(color_mask)
	var ring = ring_scene.instance()
	ring.color_string = color_string
	add_child(ring)
	ring.set_global_pos(position)
	ring.spawn()

	counter += 1
