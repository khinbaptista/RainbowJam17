extends Node

var beams
var speed = -100
var camTopLeft = Vector2(0, 0)
var camBottomRight = Vector2(1000, 0)

func _ready():
	set_process(true)
	beams = get_children()

func _process(delta):
	for beam in beams:
		var beam_pos = beam.get_pos()
		var beam_new_pos
		if(beam_pos.x < camTopLeft.x):
			beam_new_pos = Vector2(1000, 300)
		else:
			beam_new_pos = Vector2(beam_pos.x + (speed * delta), beam_pos.y)
		beam.set_pos(beam_new_pos)