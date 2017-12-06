extends Node2D

##################################################
##################################################

onready var positive = get_node("positive")
onready var negative = get_node("negative")
onready var anim     = get_node("anim")

##################################################

export(float) var scale_speed = 5.0
export(float, EASE) var ease_speed = 0.0
export(float) var full_speed_timer = 5.0
export(float) var duration = 5.0
var timer
var fading

##################################################
########## Gameplay functions

func spawn():
	timer = 0.0
	fading = false
	anim.play("spawn")
	set_process(true)

func _process(delta):
	var ratio = scale_speed * ease(min(timer / full_speed_timer, 1.0), ease_speed) * delta
	set_scale(get_scale() + Vector2(ratio, ratio))
	
	if not fading:
		timer += delta
		if timer >= duration:
			despawn()

func despawn():
	if fading: return
	fading = true
	
	#positive.fade()
	
	anim.play("despawn")
	yield(anim, "finished")
	
	set_process(false)
	if is_inside_tree() and not is_queued_for_deletion():
		queue_free()

func is_inside(body):
	var in_pos = body in positive.get_overlapping_bodies() or body in positive.get_overlapping_areas()
	var in_not = body in negative.get_overlapping_bodies() or body in negative.get_overlapping_areas()
	return in_pos and not in_not

##################################################
##################################################
