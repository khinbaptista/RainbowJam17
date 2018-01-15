extends Node2D

onready var up_area = get_node("front")
onready var down_area = get_node("back")
onready var right_area = get_node("right")
onready var left_area = get_node("left")
onready var sight_area = get_node("sight")

func can_walk(direction):
	var can = false
	
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			can = check_area(right_area)
			#print("R")
		else:
			can = check_area(left_area)
			#print("L")
	else:
		if direction.y > 0:
			can = check_area(down_area)
			#print("D")
		else:
			can = check_area(up_area)
			#print("U")
	return can
	
func check_area(area):
	var areas = []
	areas = area.get_overlapping_areas()
	var can_go = false
	
	for a in areas:
		print(a.get_name())
		if a.is_in_group("ground"):
			can_go = true
		elif a.is_in_group("platform"):
			can_go = true
	return can_go