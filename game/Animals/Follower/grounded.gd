extends Area2D

onready var follower = get_parent()

var can_walk = true

func can_walk(direction):
	var current_pos = get_pos()
	
	var overlap = get_overlapping_areas()
	can_walk = true
	
	for area in overlap:
		if area.is_in_group("stop"):
			can_walk = false
		else:
			can_walk = true
	
	return can_walk