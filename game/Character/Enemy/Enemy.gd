extends KinematicBody2D

export var can_move = true
export var move_speed = 80
export var distance_to_player = 80

onready var player = get_node(Globals.get("player_path"))
onready var sprite = get_node("sprite/Sprite")

var direction = Vector2()
var normalized = 0

var grounded = true
var moving = false

func _ready():
	pass

func _process(delta):
	process_direction()
	move_to_player()
	process_anim()

func activate(body):
	if player == body and can_move:
		set_process(true)

func process_direction():
	direction = player.get_global_pos() - get_global_pos()
	normalized = sqrt(direction.x*direction.x + direction.y*direction.y)
	direction.x /= normalized
	direction.y /= normalized

func move_to_player():
	get_node("groundcheck").set_pos(Vector2(0, 0))
	
	moving = false
	if(normalized > distance_to_player and grounded and can_move):
		move(direction * move_speed * get_process_delta_time())
		moving = true
	
	get_node("groundcheck").set_pos(get_node("groundcheck").get_pos() + direction * move_speed * get_process_delta_time() * 100)

func process_anim():
	if direction.x*direction.x > direction.y*direction.y:
		if direction.x > 0:
			if sprite.get_animation().basename() != "walking-right":
				sprite.play("walking-right")
			sprite.set_flip_h(false)
		else:
			if sprite.get_animation().basename() != "walking-right":
				sprite.play("walking-right")
			sprite.set_flip_h(true)
	
	elif direction.x == 0 and direction.y == 0:
		if sprite.get_animation().basename() != "idle-down":
			sprite.play("idle-down")
	
	else:
		if direction.y > 0:
			if sprite.get_animation().basename() != "walking-down":
				sprite.play("walking-down")
		else:
			if sprite.get_animation().basename() != "walking-up":
				sprite.play("walking-up")
