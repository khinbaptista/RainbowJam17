extends Node2D

export(NodePath) var player_path = @"../player"
onready var player = get_node(player_path)

var beams
export var speed = 0.4
export var offset = 217
export var scale_to_appear = 0.18
export var max_scale = 4
var camera
var last_position
var viewportSize
var first_time = true
var active = false
var initial_scale

func _ready():
	beams = get_children()
	initial_scale = beams[0].get_scale()
	camera = player.get_node("Camera2D")
	viewportSize = get_viewport().get_rect().size
	offset *= get_scale().x

	player.connect("new_color_learned", self, "player_learned")

	set_process(true)
	set_process_input(true)
	MoveBeansInit()

func _process(delta):
	if(active):
		var beam_scale
		var beam_new_scale
		var new_x_scale
		var new_y_scale

		for i in range(6):
			beam_scale = beams[i].get_scale()
			beam_new_scale = beam_scale

			new_x_scale = beam_scale.x + (speed * delta * beam_scale.x)
			new_y_scale = beam_scale.y + (speed * delta * beam_scale.y)

			if(beams[i].is_hidden() and beams[i].learned):
				if((beams[(i % 6) - 1].get_scale().x > scale_to_appear) or first_time):
					beams[i].show()
					beams[i].set_global_pos(last_position)
					first_time = false
					beam_new_scale = Vector2(new_x_scale, new_y_scale)
			elif(beams[i].learned):
				beam_new_scale = Vector2(new_x_scale, new_y_scale)

			beams[i].set_scale(beam_new_scale)

		if (beams[0].get_scale().x > max_scale):
			MoveBeansInit()
			active = false

func _input(event):
	if event.is_action_pressed("beams") and not event.is_echo():
		last_position = player.get_global_pos()
		first_time = true
		if(active):
			MoveBeansInit()
		else:
			active = true

func MoveBeansInit():
	for beam in beams:
		beam.hide()
		beam.set_scale(initial_scale)

func color_index2string(index):
	if index & 2:	return "red"
	if index & 4:	return "orange"
	if index & 8:	return "yellow"
	if index & 16:	return "green"
	if index & 32:	return "blue"
	if index & 64:	return "purple"

func player_learned(new_color):
	var color_string = color_index2string(new_color)
	if color_string == null: return

	get_tree().call_group(0, color_string, "color_revealed")
