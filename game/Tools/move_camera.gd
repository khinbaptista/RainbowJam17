extends Area2D

export var active = true
export(float, 0, 10, 0.001) var speed = 2
export var wait_time = 2

var return_speed = 0

var wait = false
var waiting = false

onready var target = get_node("target")
onready var player = get_node(Globals.get("player_path"))
onready var camera = player.get_node("Camera2D")

func _ready():
	target.hide()
	return_speed = camera.get_follow_smoothing()

func _process(delta):
	if wait:
		_wait()
	elif waiting:
		camera.set_global_pos(target.get_global_pos())

func _wait():
	get_node("Timer").set_wait_time(wait_time)
	get_node("Timer").set_timer_process_mode(0)
	get_node("Timer").start()
	wait = false
	waiting = true

func _timeout():
	get_node("Timer").stop()
	camera.set_follow_smoothing(return_speed)
	camera.set_global_pos(player.get_global_pos())
	camera.align()
	queue_free()

func _on_body_enter( body ):
	if body.get_name() == "player" and active:
		set_process(true)
		camera.set_enable_follow_smoothing(true)
		camera.set_follow_smoothing(speed)
		wait = true

func _set_active(active_):
	active = active_