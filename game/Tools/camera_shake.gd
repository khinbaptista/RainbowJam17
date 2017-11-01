extends Node2D

export var time = 1
export var strength = 8
export var is_one_shot = true

onready var player = get_node(Globals.get("player_path"))
var camera

var active = false
var timer

func _ready():
	timer = time
	camera = player.get_node("Camera2D")

func _process(delta):
	if timer > 0:
		timer -= delta
		camera.set_offset(Vector2(rand_range(-1.0, 1.0) * strength * timer, rand_range(-1.0, 1.0) * strength * timer))
	else:
		if is_one_shot:
			queue_free()
		timer = time
		set_process(false)
		camera.set_offset(Vector2(0, 0))

func activate(body):
	if body == player:
		set_process(true)
		camera.set_offset(Vector2(strength, strength))
