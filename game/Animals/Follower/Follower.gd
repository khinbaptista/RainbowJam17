extends KinematicBody2D

export(NodePath) var target_path = @"../player"
export(int) var speed = 1
export(bool) var active = false

var target
var final_pos
var grounded = true
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

	if active and target and grounded:
		final_pos = target.get_pos()
		var direction = final_pos - get_pos()
		var remaining = move(direction * speed * delta)
		if is_colliding():
			var normal = get_collision_normal()
			remaining = remaining.slide(normal)
			move(remaining)
