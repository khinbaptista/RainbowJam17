extends Node

var beams
var speed = -100
var camera
var viewportSize

func _ready():
	set_process(true)
	beams = get_children()
	camera = get_parent()
	viewportSize = get_viewport().get_rect().size
	MoveBeansInit()

func _process(delta):
	#print(camera.get_camera_screen_center())
	for beam in beams:
		var beam_pos = beam.get_global_pos()
		var beam_new_pos
		if(beam_pos.x < camera.get_camera_screen_center().x - viewportSize.x / 2):
			beam_new_pos = Vector2(camera.get_camera_screen_center().x + viewportSize.x / 2, beam_pos.y)
		else:
			beam_new_pos = Vector2(beam_pos.x + (speed * delta), beam_pos.y)
		beam.set_global_pos(beam_new_pos)
		
func MoveBeansInit():
	for beam in beams:
		beam.move_local_x(viewportSize.x / 2, false)