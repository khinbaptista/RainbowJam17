extends Node

var beams
var speed = -80
var camTopLeft
var camBottomRight

func _ready():
	set_process(true)
	beams = get_children()

func _process(delta):
	for beam in beams:
		var beam_pos = beam.get_pos()
		var beam_new_pos
		if(beam_pos.x < camTopLeft.get_pos().x):
			beam_new_pos = Vector2(0, 0)
		else:
			beam_new_pos = Vector2(beam_pos.x + (speed * delta), beam_pos.y)
		beam.set_pos(beam_new_pos)