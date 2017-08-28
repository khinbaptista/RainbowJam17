extends Area2D

onready var player = get_parent()

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	var areas = get_overlapping_areas()
	for area in areas:
		pass
