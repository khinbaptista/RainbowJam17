extends Area2D

export(int, FLAGS, "None", "Red", "Orange", "Yellow", "Green", "Blue", "Violet") var color_dimension = 1
onready var sprite = get_node("sprite")

export(bool) var use_timers = false
export(float) var duration_on = 5.0
export(float) var duration_off = 3.0

func _ready():
	sprite.set_light_mask(color_dimension)
	
	if use_timers:
		get_node("Timer").set_wait_time(duration_on)
		get_node("Timer 2").set_wait_time(duration_off)
		get_node("Timer").start()
	
	if color_dimension >= 2:	# has a color
		sprite.hide()
		set_collision_mask_bit(0, false)
		set_layer_mask_bit(0, false)
		add_to_group(color_index2string(color_dimension))
	else:
		spawn()

func color_index2string(index):
	if index & 2:	return "red"
	if index & 4:	return "orange"
	if index & 8:	return "yellow"
	if index & 16:	return "green"
	if index & 32:	return "blue"
	if index & 64:	return "purple"

func color_revealed():	# called from the group by the beam manager when the player learns the color
	spawn()

func spawn():
	sprite.show()
	sprite.play("spawn")
	set_collision_mask_bit(0, true)
	set_layer_mask_bit(0, true)
	get_node("AnimationPlayer").play_backwards("destroy")

func destroy():
	sprite.play("destroy")
	get_node("AnimationPlayer").play("destroy")
	yield(sprite, "finished")
	
	sprite.hide()
	set_collision_mask_bit(0, false)
	set_layer_mask_bit(0, false)
	get_node("CollisionShape2D").set_scale(Vector2(1, 1))
