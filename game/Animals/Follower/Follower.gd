extends KinematicBody2D

export(NodePath) var target_path = @"../player"
export(int) var speed = 1
export(bool) var active = false

onready var sight_area = get_node("sight")
onready var ground_check = get_node("groundcheck")

onready var left_mark = get_node("left")
onready var right_mark = get_node("right")
onready var up_mark = get_node("front")
onready var down_mark = get_node("back")

var target
var cliff_stopper
var final_pos
var grounded = true

func _ready():
	if target_path:
		target = get_node(target_path)
	set_process(true)
	
func _process(delta):
	if sight_area.overlaps_body(target):
		active = true
	else:
		active = false

	final_pos = target.get_pos()
	var direction = (final_pos - get_pos()).normalized()
	
	if active and target:
		if ground_check.can_walk(direction):
			var remaining = move(direction * speed * delta)
			if is_colliding():
				var normal = get_collision_normal()
				remaining = remaining.slide(normal)
				move(remaining)
				
func get_mark_pos(mark):
	if mark == "right":
		return right_mark.get_pos()
	elif mark == "left":
		return left_mark.get_pos()
	elif mark == "up":
		return up_mark.get_pos()
	elif mark == "down":
		return down_mark.get_pos()