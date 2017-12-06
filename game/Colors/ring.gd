extends Node2D

##################################################
##################################################

onready var positive = get_node("positive")
onready var negative = get_node("negative")
onready var sprite   = get_node("sprite")
onready var mask     = get_node("mask")
onready var anim     = get_node("anim")

##################################################

export(String, "Red", "Orange", "Yellow", "Green", "Blue", "Purple") var color_string = "Red" setget set_color
var color_index
var color_mask

##################################################

export(float) var scale_speed = 5.0
export(float, EASE) var ease_speed = 0.0
export(float) var full_speed_timer = 5.0
export(float) var duration = 5.0
var timer
var fading

##################################################

export(Color) var red_color
export(Color) var orange_color
export(Color) var yellow_color
export(Color) var green_color
export(Color) var blue_color
export(Color) var purple_color
var colors = {}

##################################################
########## Functions (tool + gameplay)

func _ready():
	update_colors()

func update_colors():
	colors.red    = red_color
	colors.orange = orange_color
	colors.yellow = yellow_color
	colors.green  = green_color
	colors.blue   = blue_color
	colors.purple = purple_color

	sprite.set_modulate(colors[color_string.to_lower()])
	mask.set_item_mask(color_mask)

#	var mask = color_mask | Globals.get("Beams/NormalMask")
#	positive.set_layer_mask(mask)
#	negative.set_layer_mask(mask)
#	positive.set_collision_mask(mask)
#	negative.set_collision_mask(mask)

func set_color(string):
	color_string = string
	color_index = Globals.get("Beams/" + color_string)
	color_mask = Globals.get("Beams/" + color_string + "Mask")

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
		timer += delta        # freeze friendly timer!
		if timer >= duration:
			despawn()

func set_freeze(freeze):
	if not fading:
		set_process(not freeze)

func despawn():
	if fading: return
	fading = true
	
	positive.fade()
	
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
