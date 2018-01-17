extends KinematicBody2D

export(NodePath) var target_path = @"../player"
export(int) var speed = 100
export var distance = 100
export(bool) var active = false

onready var sight_area = get_node("sight")
onready var ground_check = get_node("groundcheck")
onready var sprite = get_node("AnimatedSprite")

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
		sprite.play("walk right")
	else:
		active = false
		sprite.play("default")

	final_pos = target.get_pos()
	final_pos.y -= 170
	
	var vect = final_pos - get_pos()
	var direction = (Vector2(0,0))
	if vect.x > distance or vect.x < -distance: direction.x=(vect).normalized().x
	if vect.y > distance or vect.y < -distance: direction.y=(vect).normalized().y
	
	if direction == Vector2(0,0):
		active = false
		sprite.play("default")
	
	print(distance)
	print(vect.x)
	print(vect.y)
	
	if direction.x < 0: sprite.set_flip_h(true)
	elif direction.x > 0 and sprite.is_flipped_h(): sprite.set_flip_h(false)
	
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