extends Area2D

export(int, FLAGS, "None", "Red", "Orange", "Yellow", "Green", "Blue", "Violet") var color_dimension = 1
onready var sprite = get_node("sprite")

func _ready():
	sprite.set_light_mask(color_dimension)
	sprite.hide()
	spawn()

func spawn():
	sprite.show()
	sprite.play("spawn")

func destroy():
	sprite.play("destroy")
#	sprite.get_sprite_frames().get_animation_speed("destroy")
	yield(sprite, "finished")
	sprite.hide()
