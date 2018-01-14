extends Area2D

onready var follower = get_parent()
onready var up_area = get_node("../front")
onready var down_area = get_node("../back")
onready var right_area = get_node("../right")
onready var left_area = get_node("../left")

var found_ground

func _ready():
	set_process(true)

func _process(delta):
	if follower.active:
		pass
		#can_walk()
		#if can_walk():
			#var overlap = get_overlapping_areas()
			#found_ground = false
			
			#for area in overlap:
				#if area.is_in_group("ground"):
					#found_ground = true
				#elif area.is_in_group("platform"):
					#found_ground = true
				#else:
					#found_ground = false or found_ground
			
			#if found_ground:
				#follower.grounded = true
			#else:
				#follower.grounded = false
				
func can_walk():
	if not follower.target: return false
	
	var can = false
	var direction = follower.target.get_pos() - follower.get_pos()
	
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
			
	follower.can_walk = can
	return can
	
func check_area(area):
	var areas = area.get_overlapping_areas()
	var can_go = false
	
	for a in areas:
		if a.is_in_group("ground"):
			can_go = true
		elif a.is_in_group("platform"):
			can_go = true
	return can_go