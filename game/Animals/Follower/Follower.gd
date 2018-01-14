extends KinematicBody2D

export(NodePath) var target_path = @"../player"
export(int) var speed = 1
export(bool) var active = false

var target
var final_pos
var grounded = true
onready var up_area = get_node("front")
onready var down_area = get_node("back")
onready var right_area = get_node("right")
onready var left_area = get_node("left")
onready var sight_area = get_node("sight")

func _ready():
	if target_path:
		target = get_node(target_path)
	set_process(true)
	
func _process(delta):
	if sight_area.overlaps_body(target):
		active = true
	else:
		active = false

	if active and target:
		if can_walk():
			final_pos = target.get_pos()
			var direction = final_pos - get_pos()
			var remaining = move(direction * speed * delta)
			if is_colliding():
				var normal = get_collision_normal()
				remaining = remaining.slide(normal)
				move(remaining)
			
func can_walk():
	if not target: return false
	
	var can = false
	var direction = target.get_pos() - get_pos()
	
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
		if a.is_in_group("ground"):
			can_go = true
		elif a.is_in_group("platform"):
			can_go = true
	return can_go
