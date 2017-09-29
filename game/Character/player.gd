extends KinematicBody2D

export(bool) var can_move = true
export(float, 0.0, 1500.0, 0.1) var movement_speed = 100
export(float, 0.0, 1500.0, 0.1) var dash_speed = 120
export(float, 0.0, 10.0, 0.1) var dash_duration = 0.3
export(float, 0.0, 10.0, 0.1) var dash_interval = 0.2
export(float, 0.0, 10.0, 0.1) var ledge_forgiveness = 0.1

var dashing = false			# is the player dashing?
var grounded = false		# is the player standing on ground?
var can_dash = true			# can the player dash?
var dead = false			# is the player dead?

# Variables for death
var bufferY = 0				# this variable is a buffer for the player Y
export var fall_height = 50
export var fall_speed = 350

var lastCheckpoint = Vector2(0, 0)	# location to respawn
var lastDash = 0.0					# timer to control interval between dashes

var coins = 0

export(int, FLAGS, "None", "Red", "Orange", "Yellow", "Green", "Blue", "Purple") var colors_learned = 1
signal new_color_learned(color)
signal death

var animState = "idle"	# the state of the animation state machine
var moveDir = ""		# the direction in which the player is moving (animation)

onready var sound = get_node("SamplePlayer2D")
onready var timer_fall = get_node("timer_fall")
onready var dash_cooldown = get_node("dash_cooldown")

func _ready():
	set_process(true)
	set_process_input(true)
	
	lastCheckpoint = self.get_global_pos()
	
#	get_node("/root/save").load_saved(self)
	self.set_global_pos(lastCheckpoint)
	
	timer_fall.connect("timeout", self, "timeout_fall")
	dash_cooldown.connect("timeout", self, "dash_clear")
	
	advertise_colors()

func timeout_fall():
	death()

func fall_timer_counting():
	return timer_fall.get_time_left() > 0

func _process(delta):
	if not grounded and not fall_timer_counting() and not dashing and not dead:
		timer_fall.start()
	elif grounded:
		timer_fall.stop()
	
	var debug = get_node("/root/Debug").get_node("Label")
	debug.set_text("Able to dash: " + str(can_dash).to_lower())
	debug.set_text(debug.get_text() + "\nDash cooldown: " + str(dash_cooldown.get_time_left()) + "s")
	debug.set_text(debug.get_text() + "\nFalling in " + str(timer_fall.get_time_left()) + "s")

	if dead:
		if get_pos().y < bufferY + fall_height and not grounded:
				set_pos(Vector2(get_pos().x, get_pos().y+fall_speed*delta))
		else:	death()
	else:
		if can_move:		input_movement(delta)
		if lastDash > 0:	lastDash -= delta
		else:				can_move = true
	
	process_shadow()

func input_movement(delta):
	var movement = Vector2()
	var moved = false
	
	if Input.is_action_pressed("exit"):
		get_node("/root/loader").change_scene("res://Menu/start_menu.tscn")
	if not dashing and not dead and can_move:
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
		if movement == Vector2(0,0):
			moved = false
		else:
			get_node("Sprite").set_flip_h(false)
			if movement.x < 0 and movement.y == 0: get_node("Sprite").set_flip_h(true)
			
			if movement.x != 0:		moveDir = "right"
			if movement.y > 0:		moveDir = "down"
			elif movement.y < 0:	moveDir = "up"
			moved = true
		
		# MOVEMENT STATE MACHINE
		if dead: animState = "death"
		elif Input.is_action_pressed("dash") and can_dash:
			dash(self.get_travel().normalized())
			animState = "dash"
		elif animState == "runStart" and get_node("Sprite").get_frame()==2:
			animState = "runLoop"
		elif moved:
			get_node("timer_idle").stop()
			can_dash = true
			if animState == "dash":			animState = "runStart"
			if animState == "idle":			animState = "runStart"
			elif animState == "dash":		animState = "runStart"
			elif animState == "runStop":	animState = "runStart"
		elif animState == "runLoop":
				animState = "runStop"
				can_dash = false
		
		if fall_timer_counting(): can_dash = true
		
		# APPLY MOVEMENT
		if not dead:
			movement = check_controller_input(movement.normalized())
			apply_movement(movement, delta)

func dash_clear():
	can_move = true

func process_shadow():
	if not grounded: get_node("shadow").hide()
	else: get_node("shadow").show()

func check_controller_input(dir):
	var axis = Vector2(Input.get_joy_axis(0, 0), Input.get_joy_axis(0, 1))
	
	if sign(axis.x) == sign(dir.x) and sign(axis.y) == sign(dir.y):
		return axis
	
	return dir

func apply_movement(direction, delta):
	var sprite = get_node("Sprite")
	var anim = sprite.get_animation().basename()
	var moved = ( direction.length() != 0 )
	
	# ANIMATION. Continues state machine
	if animState == "runStart":
		if anim != ("run-" + moveDir + "-begin"):
			sprite.play("run-" + moveDir + "-begin")
	elif animState == "runLoop":
		if anim != ("run-" + moveDir + "-loop"):
			sprite.play("run-" + moveDir + "-loop")
	elif animState == "runStop":
		if anim != ("run-" + moveDir + "-stop") and anim != "idle":
			get_node("timer_idle").start()
			sprite.play("run-" + moveDir + "-stop")
	
	# MOVEMENT
	if moved:
		var remaining = self.move(direction * movement_speed * delta)
		if self.is_colliding():
			var normal = self.get_collision_normal()
			remaining = remaining.slide(normal)
			self.move(remaining)

func dash(direction):
	dashing = true
	can_dash = false
	sound.play("dash1")
	
	var sprite = get_node("Sprite")
	
	var anim = "dash-" + moveDir + "-loop"
	sprite.play(anim)
	
	var timer = 0.0
	if !dashing and timer<0.1:	Input.start_joy_vibration(0, 0.6, 0.4, 0.1)
	else:						Input.start_joy_vibration(0, 0.6 - 0.6 * timer, 0.2, 0.25)
	
	while timer < dash_duration:
		var delta = get_process_delta_time()
		self.move(direction * dash_speed * get_process_delta_time())
		
		timer += delta
		yield(get_tree(), "idle_frame")
	
	if grounded:
		anim = anim.replace("-loop", "-stop")
		sprite.play(anim)
		get_node("timer_idle").start()
	
	lastDash = dash_interval
	dash_cooldown.start()
	timer_fall.stop()
	can_dash = false
	can_move = false
	dashing = false

func advertise_colors():
	if colors_learned & 2:	emit_signal("new_color_learned", 2)		# red
	if colors_learned & 4:	emit_signal("new_color_learned", 4)		# orange
	if colors_learned & 8:	emit_signal("new_color_learned", 8)		# yellow
	if colors_learned & 16:	emit_signal("new_color_learned", 16)	# green
	if colors_learned & 32:	emit_signal("new_color_learned", 32)	# blue
	if colors_learned & 64:	emit_signal("new_color_learned", 64)	# purple

func knows_color(color):
	return colors_learned & color

func learn_color(color):
	Input.start_joy_vibration(0, 0.2, 0.4, 0.3)
	if colors_learned & color: return	# color is aleady known
	colors_learned += color
#	get_node("/root/save").save_file(self)
	emit_signal("new_color_learned", color)
	
func update_checkpoint(pos):
	lastCheckpoint = pos
#	get_node("/root/save").save_file(self)
	
func death():
	var sprite = get_node("Sprite")
	
	if not dead:
		Input.start_joy_vibration(0, 0.2, 0.4, 0.3)
		dead = true
		can_dash = false
		var anim_name = sprite.get_animation()
		
		if anim_name == "idle":	anim_name = "death-down"
		else:			anim_name = "death-" + moveDir
		
		sprite.play(anim_name)
		bufferY = get_pos().y
	
	else:
		sprite.play("run-down-stop")
		self.set_global_pos(lastCheckpoint)
		can_dash = false
		can_move = true
		dead = false
		emit_signal("death")

func add_coin(amount):
	coins = coins + amount
	
func spend_coins(amount):
	coins = coins - amount
