extends KinematicBody2D

export(NodePath) var player_path = @"../../player"
export var speed = 150
export var max_distance = 1000
export var trigger_distance = 200
export var call_time = 3

var waiting  = false  # Waiting for the player
var calling  = true   # Going to the player to call them
var going    = false  # Going to the objective
var finished = false  # Loop circle animation
var moving   = false  # Is the butterfly moving?
var height_adjust = 0
var speed_buff

onready var player = get_node(player_path)
onready var timer = get_node("Timer")
onready var target = get_node("../target")
onready var animPlayer = get_node("AnimationPlayer")
onready var sprite = get_node("Sprite")

func _ready():
	target.hide()
	animPlayer.play("circle")
	animPlayer.stop(true)
	calling = true
	timer.set_wait_time(call_time)
	set_process(true)

func _process(delta):
	if !going:
		print("\nwaiting: ", waiting, "\ncalling: ", calling, "\ngoing: ", going, "\ntime: ", timer.get_time_left())
		
	if animPlayer.is_playing() and sprite.get_animation().basename() != "circle": sprite.play("circle")
	
	if calling:    calling(delta)
	elif going:    going(delta)
	elif waiting:  waiting(delta)
	elif finished: finished(delta)

func calling(delta):
	var move_vect = Vector2(player.get_global_pos().x, player.get_global_pos().y - height_adjust) - get_global_pos()
	var len = sqrt(move_vect.x * move_vect.x + move_vect.y * move_vect.y)
	
	if len > speed*delta:
		move(move_vect.normalized() * speed*delta)
		process_direction(move_vect.normalized())
		if len <= 2*speed*delta and !animPlayer.is_playing():
			timer.start()
			animPlayer.play("circle")
			speed_buff = speed
			speed = player.get_node("Actions/move").speed

func going(delta):
	speed = speed_buff
	animPlayer.stop(false)
	
	var move_vect = target.get_global_pos() - get_global_pos()
	var len = sqrt(move_vect.x * move_vect.x + move_vect.y * move_vect.y)
	
	var player_move_vect = player.get_global_pos() - get_global_pos()
	var player_len = sqrt(player_move_vect.x * player_move_vect.x + player_move_vect.y * player_move_vect.y)
	
	#print(player_len)
	if player_len > max_distance:
		going = false
		waiting = true
	elif len > speed*delta:
		move(move_vect.normalized() * speed*delta)
		process_direction(move_vect.normalized())
		if len <= 2*speed*delta:
			going = false
			finished = true

func waiting(delta):
	if ! animPlayer.is_playing():
		animPlayer.play("circle")
	var player_move_vect = player.get_global_pos() - get_global_pos()
	var player_len = sqrt(player_move_vect.x * player_move_vect.x + player_move_vect.y * player_move_vect.y)
	
	if player_len < trigger_distance:
		waiting = false
		going = true

func finished(delta):
	if ! animPlayer.is_playing():
		animPlayer.play("circle")

func set_active(activate):
	if activate: set_process(true)
	else:        set_process(false)

func _on_Timer_timeout():
	timer.stop()
	timer.set_wait_time(call_time)
	calling = false
	going = true

func process_direction(vector):
	var x = 0.0
	var y = 0.0
	if x>0: x =  vector.x
	else:   x = -vector.x
	if y>0: y =  vector.y
	else:   y = -vector.y
	
	if y > x:
		if vector.y > 0 and sprite.get_animation().basename() != "down":
			sprite.play("down")
		elif vector.y < 0 and sprite.get_animation().basename() != "up":
			sprite.play("up")
	else:
		if vector.x < 0: sprite.set_flip_h(false)
		else:            sprite.set_flip_h(true)
		if sprite.get_animation().basename() != "left":
			sprite.play("left")
