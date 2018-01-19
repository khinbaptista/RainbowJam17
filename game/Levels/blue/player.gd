extends KinematicBody2D

##########

export(bool) var can_move = true
export(int, FLAGS, "None", "Red", "Orange", "Yellow", "Green", "Blue", "Purple") var colors_learned = 1

##########

signal death
signal new_color_learned(color)

########## Movement + Dash

onready var dash_action = get_node("Actions/dash")
var last_movement = Vector2(0, 1)
var dashing = false  # is the player dashing?
var grounded = false # is the player standing on ground?
var dead = false     # is the player dead?
var falling = false  # is the player falling?
var hasting = false  # is the player using the haste upgrade?

########## Variables for death

onready var lastCheckpoint = get_global_pos()
var bufferY = 0			# this variable is a buffer for the player Y

export var fall_height = 50
export var fall_speed = 350

########## Misc

var coins = 0
var moveDir = "down"		# the direction in which the player is moving (animation)
var haste_ratio = 1.5		# haste upgrade ratio to increase player speed

########## Nodes

onready var sound = get_node("SamplePlayer2D")
onready var timer_fall = get_node("timer_fall")
onready var move_action = get_node("Actions/move")
onready var haste_action = get_node("Actions/haste")

########## Helper funcs

func fall_timer_counting(): return timer_fall.get_time_left() > 0

func set_can_move(enable):
	can_move = enable
	move_action.enabled = enable

func forget_last_movement():
	last_movement = Vector2(0, 1)
	moveDir = "down"

func align_last_movement():
	if moveDir == "up":
		last_movement = Vector2(0, -1)
	elif moveDir == "down":
		last_movement = Vector2(0, 1)
	elif moveDir == "right":
		if last_movement.x > 0:
			last_movement = Vector2(1, 0)
		else:
			last_movement = Vector2(-1, 0)
	else:
		forget_last_movement()	# shouldn't happen ever

func apply_force(vect):
	move_action.execute(vect)

########## Funcs

func _ready():
	Globals.set("player_path", get_path())

	set_process(true)
	set_process_input(true)

	set_can_move(can_move)

#	get_node("/root/save").load_saved(self)
	self.set_global_pos(lastCheckpoint)
	timer_fall.connect("timeout", self, "death")
	dash_action.get_node("cooldown").connect("timeout", self, "set_can_move", [true])

	get_node("FSM/idle").connect("idle_anim_start", self, "forget_last_movement")

	advertise_colors()

func _input(event):
	if event.is_action_pressed("exit") and not event.is_echo():
		get_node("/root/loader").change_scene("res://Menu/start_menu.tscn")
	elif event.is_action_pressed("dash") and not event.is_echo():
		dash(last_movement)
	elif event.is_action_pressed("haste") and not event.is_echo():
		haste()

func _process(delta):
	if not grounded and not fall_timer_counting() and not dashing and not dead and not falling:
		timer_fall.start()
	elif grounded and fall_timer_counting():
		timer_fall.stop()

	if dead:
		if get_pos().y < bufferY + fall_height and not grounded:
			set_pos(Vector2(get_pos().x, get_pos().y + fall_speed * delta))
		else:
			emit_signal("death")

	input_movement(delta)

func input_movement(delta):
	if not move_action.can_execute() or not can_move or dashing or dead:
		return

	var movement = Vector2()
	var moved = false

	# INPUT
	if Input.is_action_pressed("move_right"):
		movement.x += 1
	if Input.is_action_pressed("move_left"):
		movement.x -= 1
	if Input.is_action_pressed("move_up"):
		movement.y -= 1
	if Input.is_action_pressed("move_down"):
		movement.y += 1

	# DIRECTION
	if movement == Vector2(0, 0): moved = false
	else:
		moved = true

		get_node("Sprite").set_flip_h(false)
		if movement.x < 0 and movement.y == 0: get_node("Sprite").set_flip_h(true)

		if movement.x != 0:  moveDir = "right"
		if movement.y > 0:   moveDir = "down"
		elif movement.y < 0: moveDir = "up"

	# MOVEMENT STATE MACHINE
	if moved:
		get_node("FSM").make_transition("move")
	else:
		align_last_movement()
		get_node("FSM").make_transition("idle")
		return

	# CONTROLLER INPUT
	movement = check_controller_input(movement.normalized())
	if movement.length() != 0: last_movement = movement

	# APPLY MOVEMENT
	move_action.execute(movement)

func check_controller_input(dir):
	var axis = Vector2(Input.get_joy_axis(0, 0), Input.get_joy_axis(0, 1))

	if sign(axis.x) == sign(dir.x) and sign(axis.y) == sign(dir.y):
		return axis

	return dir

func dash(direction):
	if not dash_action.can_execute(): return

	set_can_move(false)

	timer_fall.stop()
	dashing = true
	sound.play("dash1")

	get_node("FSM").make_transition("dash")

#	var timer = 0.0	# timer value never changes....
#	if !dashing and timer<0.1:	Input.start_joy_vibration(0, 0.6, 0.4, 0.1)
#	else:				Input.start_joy_vibration(0, 0.6 - 0.6 * timer, 0.2, 0.25)
	Input.start_joy_vibration(0, 0.6, 0.4, 0.1)

	if dash_action.execute(direction):
		yield(dash_action, "done")

	dashing = false

func set_walk_slow(walk_slow):
	get_node("FSM").walking = walk_slow

func get_walking_slow():
	return get_node("FSM").walking

func set_speed(speed):
	get_node("Actions/move").speed = speed
	
########## Upgrades

func haste():
	if hasting: return
	
	hasting = true
	
	if haste_action.execute():
		yield(haste_action, "done")
		
	hasting = false
	
########## Color stuff

func advertise_colors():
	if colors_learned & 2:  emit_signal("new_color_learned", 2)   # red
	if colors_learned & 4:  emit_signal("new_color_learned", 4)   # orange
	if colors_learned & 8:  emit_signal("new_color_learned", 8)   # yellow
	if colors_learned & 16: emit_signal("new_color_learned", 16)  # green
	if colors_learned & 32: emit_signal("new_color_learned", 32)  # blue
	if colors_learned & 64: emit_signal("new_color_learned", 64)  # purple

func knows_color(color):
	return colors_learned & color

func learn_color(color):
	Input.start_joy_vibration(0, 0.2, 0.4, 0.3)
	if colors_learned & color: return	# color is aleady known
	colors_learned += color
#	get_node("/root/save").save_file(self)
	emit_signal("new_color_learned", color)

########## Death

func update_checkpoint(pos):
	lastCheckpoint = pos
#	get_node("/root/save").save_file(self)

func death():
	Input.start_joy_vibration(0, 0.2, 0.4, 0.3)
	dead = true

	set_can_move(false)
	dash_action.enabled = false

	get_node("FSM").make_transition("dead")
	bufferY = get_pos().y


########## Money

func add_coins(amount):
	coins = coins + amount

func spend_coins(amount):
	coins = coins - amount
