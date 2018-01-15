extends Area2D

onready var follower = get_parent()

export(float) var adjustment = 20

var found_ground
var can_walk = false

func can_walk(direction):
	var current_pos = get_pos()
	var next_pos
	
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			next_pos = follower.get_mark_pos("right")
		else:
			next_pos = follower.get_mark_pos("left")
	else:
		if direction.y > 0:
			next_pos = follower.get_mark_pos("down")
		else:
			next_pos = follower.get_mark_pos("up")
	
	set_pos(next_pos)
	var overlap = get_overlapping_areas()
	found_ground = false
	
	for area in overlap:
		if area.is_in_group("ground"):
			found_ground = true
		elif area.is_in_group("platform"):
			found_ground = true
		else:
			found_ground = false or found_ground
	
	if found_ground:
		can_walk = true
	else:
		can_walk = false
	set_pos(current_pos)
	return can_walk