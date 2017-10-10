extends Node2D

export(NodePath) var player_path = @"../player"
onready var player = get_node(player_path)

var beams
export var speed = 0.2
export var offset = 217
var camera
var viewportSize
var red_pos
var red_beam
var first_time = true

func _ready():
	beams = get_children()
	camera = player.get_node("Camera2D")
	viewportSize = get_viewport().get_rect().size
	offset *= get_scale().x
	
	player.connect("new_color_learned", self, "player_learned")
	
	for beam in beams:
		if beam.check_color() == 2:
			red_pos = beam.get_global_pos()
			red_beam = beam
		beam.distance_to_red = beam.get_global_pos().x - red_pos.x
	
	set_process(true)
	MoveBeansInit()

func _process(delta):
	for i in range(6):
		var beam_scale = beams[i].get_scale()
		var beam_new_scale = beam_scale
		var camera_center = camera.get_camera_screen_center()
		
		#if(beam_pos.x < camera_center.x - viewportSize.x / 2 - offset):
		#if beam.check_color() == 2:
			#beam_new_scale = Vector2(camera_center.x + viewportSize.x / 2 + offset, camera_center.y)
			#red_pos = beam_new_scale
		#else:
			#beam_new_scale = Vector2(red_beam.get_global_pos().x + beam.distance_to_red, camera_center.y)
		#else:
			
		var new_x_scale = beam_scale.x + (speed * delta * beam_scale.x)
		var new_y_scale = beam_scale.y + (speed * delta * beam_scale.y)
		
		if(beams[i].is_hidden()):
			if((beams[(i % 6) - 1].get_scale().x > 1.4) or first_time):
				beams[i].show()
				beams[i].set_global_pos(camera.get_camera_screen_center())
				first_time = false
				beam_new_scale = Vector2(new_x_scale, new_y_scale)
		elif(not beams[i].is_hidden()):
			beam_new_scale = Vector2(new_x_scale, new_y_scale)
		#var beam_shape  = beams[i].get_node("beam_area/CollisionShape2D").get_shape()
		#var not_beam = beams[i].get_node("negative_beam")

		beams[i].set_scale(beam_new_scale)
		
func MoveBeansInit():
	for beam in beams:
		beam.hide()

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
