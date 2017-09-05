extends KinematicBody2D

export(bool) var can_move = true
export(float, 0.0, 1500.0, 0.1) var movement_speed = 100
export(float, 0.0, 1500.0, 0.1) var dash_speed = 120
export(float, 0.0, 10.0, 0.1) var dash_duration = 0.3
export(float, 0.0, 10.0, 0.1) var dash_interval = 0.2

var moved = false	# has the player moved in this frame?
var dashing = false	# is the player dashing?
var grounded = false	# is the player standing on ground?
var canDash = true
var dead = false # is the player dead?

# Variables for death
var bufferY = 0 # this variable is a buffer for the player Y
export var fall_height = 50
export var fall_speed = 350

var lastCheckpoint = Vector2(0, 0)	# location to respawn
var lastDash = 0.0 # timer to control interval between dashes

var sound

export(int, FLAGS, "None", "Red", "Orange", "Yellow", "Green", "Blue", "Purple") var colors_learned = 1
signal new_color_learned(color)
signal death

func _ready():
	set_process(true)
	set_process_input(true)
	sound = get_node("SamplePlayer2D")
	
	lastCheckpoint = self.get_global_pos()
	
#	get_node("/root/save").load_saved(self)
	self.set_global_pos(lastCheckpoint)
	
	advertise_colors()
	
func _process(delta):
	if dead:
		if get_pos().y < bufferY + fall_height and not grounded:
			set_pos(Vector2(get_pos().x, get_pos().y+fall_speed*delta))
		else:
			death()
	else:
		if not grounded and not dashing: death()
		if can_move:
			input_movement(delta)
		if not grounded: get_node("shadow").hide()
		else: get_node("shadow").show()
		
		if lastDash > 0: lastDash -= delta
		else: canDash = true

func _input(event):
	if can_move:
		input_dash(event)

func input_movement(delta):
	var movement = Vector2()
	
	if Input.is_action_pressed("move_up"):
		movement.y -= 1
	if Input.is_action_pressed("move_down"):
		movement.y += 1
	if Input.is_action_pressed("move_left"):
		movement.x -= 1
	if Input.is_action_pressed("move_right"):
		movement.x += 1

	movement = check_controller_input(movement.normalized())

	if not dashing and not dead:
		apply_movement(movement, delta)

func check_controller_input(dir):
	var axis = Vector2(Input.get_joy_axis(0, 0), Input.get_joy_axis(0, 1))
	
	if sign(axis.x) == sign(dir.x) and sign(axis.y) == sign(dir.y):
		return axis
	
	return dir

func apply_movement(direction, delta):
	var sprite = get_node("Sprite")
	var moved = ( direction.length() != 0 )
	
	if moved and not self.moved:
		if direction.y >= 1:	play_anim_beginloop("run-down")
		elif direction.y <= -1:	play_anim_beginloop("run-up")
		if direction.x >= 1:
			sprite.set_flip_h(false)
			play_anim_beginloop("run-right")
		elif direction.x <= -1:
			sprite.set_flip_h(true)
			play_anim_beginloop("run-right")
	elif moved and self.moved:
		if direction.y >= 1:	sprite.play("run-down-loop")
		elif direction.y <= -1:	sprite.play("run-up-loop")
		if direction.x >= 1:
			sprite.set_flip_h(false)
			sprite.play("run-right-loop")
		elif direction.x <= -1:
			sprite.set_flip_h(true)
			sprite.play("run-right-loop")
	
	self.moved = moved
	if self.moved:
		var remaining = self.move(direction * movement_speed * delta)
		if self.is_colliding():
			var normal = self.get_collision_normal()
			remaining = remaining.slide(normal)
			self.move(remaining)
#		self.move_and_slide(direction * movement_speed)# * delta)
	else: play_anim_stop()

func play_anim_beginloop(anim, only_if_moved = true):
	var sprite = get_node("Sprite")
	sprite.play(anim + "-begin")
	
	yield(sprite, "finished")
	
	if not only_if_moved or (only_if_moved and self.moved):
		sprite.play(anim + "-loop")

func play_anim_stop():
	var sprite = get_node("Sprite")
	var anim_name = sprite.get_animation()
	
	if anim_name.ends_with("-loop"):	anim_name = anim_name.replace("-loop", "-stop")
	elif anim_name.ends_with("-begin"):	anim_name = anim_name.replace("-begin", "-stop")
	
	sprite.play(anim_name)
	yield(sprite, "finished")
	get_node("timer_idle").start()

func input_dash(input_event):
	if not moved or not canDash: return # cannot dash if you're not walking
	if input_event.is_action_pressed("dash") and not input_event.is_echo() and !dashing:
		dash(self.get_travel().normalized())
		sound.play("dash1")

func dash(direction):
	if !dashing:
		dashing = true
		
		var sprite = get_node("Sprite")
		
		var anim = sprite.get_animation().replace("run-", "dash-")
		anim = anim.replace("-loop", "").replace("-begin", "")
		anim = anim+"-loop"
		sprite.play(anim)
		
		var timer = 0.0
		while timer < dash_duration:
			var delta = get_process_delta_time()
			self.move(direction * dash_speed * get_process_delta_time())
			
			timer += delta
			yield(get_tree(), "idle_frame")
		
		play_anim_stop()
		dashing = false
		
		lastDash = dash_interval
		canDash = false

func advertise_colors():
	if colors_learned & 2:	emit_signal("new_color_learned", 2)	# red
	if colors_learned & 4:	emit_signal("new_color_learned", 4)	# orange
	if colors_learned & 8:	emit_signal("new_color_learned", 8)	# yellow
	if colors_learned & 16:	emit_signal("new_color_learned", 16)	# green
	if colors_learned & 32:	emit_signal("new_color_learned", 32)	# blue
	if colors_learned & 64:	emit_signal("new_color_learned", 64)	# purple

func knows_color(color):
	return colors_learned & color

func learn_color(color):
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
		var anim_name = sprite.get_animation()
		
		if anim_name.ends_with("-loop"):	anim_name = anim_name.replace("-loop", "")
		elif anim_name.ends_with("-begin"):	anim_name = anim_name.replace("-begin", "")
		elif anim_name.ends_with("-stop"):	anim_name = anim_name.replace("-stop", "")
		if anim_name.begins_with("run"):	anim_name = anim_name.replace("run", "death")
		elif anim_name.begins_with("dash"):	anim_name = anim_name.replace("dash", "death")
		print(anim_name)
		sprite.play(anim_name)
		dead = true
		bufferY = get_pos().y
	else:
		sprite.play("idle")
		emit_signal("death")
		self.set_global_pos(lastCheckpoint)
		dead = false
