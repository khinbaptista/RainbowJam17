extends KinematicBody2D

##################################################

export var player_safe = false
export var running = false
export var speed = 100.0
export var direction = Vector2(1.0, 0.0) setget set_direction

func set_direction(dir): direction = dir.normalized()
func set_running(value): running = value

##################################################

func _ready():
	get_node("Reach").connect("body_enter", self, "on_body_enter_reach")
	set_process(true)

func _process(delta):
	if running: run(delta)

func run(delta):
	move(direction * speed * delta)

func on_body_enter_reach(body):
	if not body.is_in_group("player"): return
	
	if player_safe:
		dissolve()
	else:
		attack()

func dissolve():
	# play anim?
	pass

func attack():
	pass

##################################################
