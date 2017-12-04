extends "res://Beams/color_alignment.gd"

export(bool) var active = true
export(bool) var use_timers = false
export(bool) var destructible = false
export(float) var duration_on = 5.0
export(float) var duration_off = 3.0

onready var sprite = get_node("sprite")
onready var anim = get_node("AnimationPlayer")

var activated = true

func set_color(color):
	.set_color(color)

	set_layer_mask(color_mask)
	set_collision_mask(color_mask)
	if sprite: sprite.set_light_mask(color_mask)

func _ready():
	sprite.set_light_mask(color_mask)

	set_process(true)

	if destructible:
		activated = false

	if use_timers and !destructible:
		get_node("timer_on").set_wait_time(duration_on)
		get_node("timer_off").set_wait_time(duration_off)
		get_node("timer_on").connect("timeout", get_node("timer_off"), "start")
		get_node("timer_on").start()

	if color_string != "Normal":	# has a color
		sprite.hide()
		set_collision_mask_bit(0, false)
		set_layer_mask_bit(0, false)
	elif active:
		spawn()
	else:
		destroy()

func _process(delta):
	if sprite.get_animation().basename() == "destroy" and sprite.get_frame() == sprite.get_sprite_frames().get_frame_count("destroy")-1:
		sprite.hide()
		set_collision_mask_bit(0, false)
		set_layer_mask_bit(0, false)

func color_revealed():	# called from the group by the beam manager when the player learns the color
	spawn()

func spawn():
	sprite.show()
	sprite.play("spawn")
	anim.play_backwards("destroy_collider")

	set_collision_mask_bit(0, true)
	set_layer_mask_bit(0, true)

	if destructible:
		activated = false
		yield(anim, "finished")
		if not anim.is_playing():
			anim.play("hint")

func destroy():
	if activated: # if the platform is destructible, only destroy when activated
		sprite.play("destroy")
		anim.play("destroy_collider")

func _on_platform_area_enter( area ):
	if destructible and area.get_name() == "groundcheck":
		var player = area.get_parent()
		if not player.is_connected("death", self, "spawn"):
			player.connect("death", self, "spawn")

		get_node("timer_on").set_wait_time(duration_on)
		get_node("timer_on").start()
		activated = true

func activate():
	set_process(true)
	active = true
	spawn()
