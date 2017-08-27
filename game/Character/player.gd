extends KinematicBody2D

export(bool) var can_move = true
export(float, 0.0, 500.0, 0.1) var movement_speed = 100
export(float, 0.0, 500.0, 0.1) var dash_speed = 120
export(float, 0.0, 10.0, 0.1) var dash_duration = 0.3

var moved = false	# has the player moved in this frame?
var dashing = false
var grounded = false
var platforms = 0
var lastCheckpoint = Vector2(0, 0)
export(int, FLAGS, "None", "Red", "Orange", "Yellow", "Green", "Blue", "Violet") var colors_learned = 0

signal new_color_learned(color)

func _ready():
	set_process(true)
	set_process_input(true)
	
	get_node("/root/colors").set_player(self.get_path())
	
func _process(delta):
	if can_move:
		input_movement(delta)
	if not grounded and not dashing:
		death()

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

	apply_movement(movement.normalized(), delta)

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
	if self.moved: self.move(direction * movement_speed * delta)
	else: play_anim_stop()

func play_anim_beginloop(anim):
	var sprite = get_node("Sprite")
	sprite.play(anim + "-begin")
	yield(sprite, "finished")
	if self.moved: sprite.play(anim + "-loop")

func play_anim_stop():
	var sprite = get_node("Sprite")
	var anim_name = sprite.get_animation()
	
	if anim_name.ends_with("-loop"):	anim_name = anim_name.replace("-loop", "-stop")
	elif anim_name.ends_with("-begin"):	anim_name = anim_name.replace("-begin", "-stop")
	
	sprite.play(anim_name)
	yield(sprite, "finished")
	if not moved: sprite.play("idle")


func input_dash(input_event):
	if not moved: return
	if input_event.is_action_pressed("dash") and not input_event.is_echo():
		dash(self.get_travel().normalized())

func dash(direction):
	dashing = true
	
	var timer = 0.0
	while timer < dash_duration:
		var delta = get_process_delta_time()
		self.move(direction * dash_speed * get_process_delta_time())
		
		timer += delta
		yield(get_tree(), "idle_frame")
	dashing = false

func learn_color(color):
	colors_learned += color
	emit_signal("new_color_learned", color)
	
func set_grounded(value):
	grounded = value
	
func update_checkpoint(pos):
	lastCheckpoint = pos
	
func left_platform():
	platforms = platforms - 1
	if platforms < 1:
		set_grounded(false)

func entered_platform():
	platforms = platforms + 1
	set_grounded(true)
	
func death():
	self.set_global_pos(lastCheckpoint)
	grounded = true
