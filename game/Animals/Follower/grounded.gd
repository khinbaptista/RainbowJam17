extends Area2D

onready var follower = get_parent()

var can_walk = true

func can_walk(direction):
	var current_pos = get_pos()
	
	var overlap = get_overlapping_areas()
	can_walk = true
	
	for area in overlap:
		if area.is_in_group("stop"):
			area.notify = true
			if area.active:
				can_walk = false
	return can_walk