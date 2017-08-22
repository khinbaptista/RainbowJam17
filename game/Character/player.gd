extends KinematicBody2D

export(bool) var can_move = true
export(float, 0.0, 500.0, 0.1) var movement_speed = 100
export(float, 0.0, 500.0, 0.1) var dash_speed = 120
export(float, 0.0, 10.0, 0.1) var dash_duration = 0.3

var moved = false	# has the player moved in this frame?

func _ready():
	set_process(true)
	set_process_input(true)
	
func _process(delta):
	if can_move:
		input_movement(delta)
		

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
	
	moved = movement.length() != 0
	
	if moved:
		self.move(movement.normalized() * movement_speed * delta)
	

func input_dash(input_event):
	if not moved: return
	if input_event.is_action_pressed("dash") and not input_event.is_echo():
		dash(self.get_travel().normalized())

func dash(direction):
	var timer = 0.0
	
	while timer < dash_duration:
		var delta = get_process_delta_time()
		self.move(direction * dash_speed * get_process_delta_time())
		
		timer += delta
		yield(get_tree(), "idle_frame")
