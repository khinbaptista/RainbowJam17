extends Node2D

var vect = Vector2(0, 0)
onready var background_speed = get_node("background").get_param(2)
onready var foreground_speed = get_node("foreground").get_param(2)
onready var background_amount = get_node("background").get_amount()
onready var foreground_amount = get_node("foreground").get_amount()

export var max_strength = 4
export var min_strength = 2
export var max_wait = 15
export var min_wait = 5
export var max_duration = 10
export var min_duration = 5

onready var timer_wait = get_node("timer_wait")
onready var timer_work = get_node("timer_work")
onready var player = get_parent()
onready var background = get_node("background")
onready var foreground = get_node("foreground")

func _ready():
	wait()

func _process(delta):
	apply_force()

func wait():
	set_process(false)
	
	background.set_param(2, background_speed*0.1)
	background.set_amount(background_amount*0.1)
	foreground.set_param(2, foreground_speed*0.1)
	foreground.set_amount(foreground_amount*0.1)
	
	get_random_direction()
	timer_wait.set_wait_time(get_random_time(min_wait, max_wait))
	timer_wait.start()

func work():
	background.set_param(2, background_speed)
	background.set_amount(background_amount)
	foreground.set_param(2, foreground_speed)
	foreground.set_amount(foreground_amount)
	
	timer_work.set_wait_time(get_random_time(min_duration, max_duration))
	timer_work.start()
	set_process(true)

func apply_force():
	player.apply_force(vect)

func get_random_direction():
	randomize()
	var x = float((randi()%max_strength+1 + min_strength))/10
	var y = float((randi()%max_strength+1 + min_strength))/10
	
	var negative = bool(randi()%2+0)  # 0 or 1
	if negative: x = -x
	var negative = bool(randi()%2+0)  # 0 or 1
	if negative: y = -y
	
	vect = Vector2(x, y)
	
	get_node("background").set_param(0, rad2deg(vect.angle()))
	get_node("foreground").set_param(0, rad2deg(vect.angle()))

func get_random_time(min_, max_):
	randomize()
	return randi()%max_+1 + min_
