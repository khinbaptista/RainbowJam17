extends Node2D

export(NodePath) var player_path = @"../player"
onready var player = get_node(player_path)

var beams
export var speed = -100
export var offset = 217
var camera
var viewportSize
var red_pos
var red_beam

func _ready():
	beams = get_children()
	camera = player.get_node("Camera2D")
	viewportSize = get_viewport().get_rect().size
	offset *= get_scale().x
	
	for beam in beams:
		if beam.check_color() == 2:
			red_pos = beam.get_global_pos()
			red_beam = beam
		beam.distance_to_red = beam.get_global_pos().x - red_pos.x
	
	set_process(true)
	MoveBeansInit()

func _process(delta):
	for beam in beams:
		var beam_pos = beam.get_global_pos()
		var beam_new_pos
		var camera_center = camera.get_camera_screen_center()
		
		if(beam_pos.x < camera_center.x - viewportSize.x / 2 - offset):
			if beam.check_color() == 2:
				beam_new_pos = Vector2(camera_center.x + viewportSize.x / 2 + offset, camera_center.y)
				red_pos = beam_new_pos
			else:
				beam_new_pos = Vector2(red_beam.get_global_pos().x + beam.distance_to_red, camera_center.y)
		else:
			beam_new_pos = Vector2(beam_pos.x + (speed * delta), camera_center.y)
		beam.set_global_pos(beam_new_pos)
		
func MoveBeansInit():
	for beam in beams:
		beam.move_local_x(viewportSize.x / 2, false)