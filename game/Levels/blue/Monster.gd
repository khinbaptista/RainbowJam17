extends KinematicBody2D

##################################################

export(NodePath) var player_path = @"../player"
onready var player = get_node(player_path)

export var player_safe = false
export var running = false
export var speed = 100.0
#export var direction = Vector2(1.0, 0.0) setget set_direction

var direction

func set_direction(dir): direction = dir.normalized()
func set_running(value): running = value

##################################################

signal player_killed
signal dissolved

##################################################

func _ready():
	get_node("Reach").connect("body_enter", self, "on_body_enter_reach")
	set_process(true)

func _process(delta):
	if running:
		update_direction()
		run(delta)

func update_direction():
	direction = (player.get_pos() - get_pos()).normalized()

func run(delta):
	move(direction * speed * delta)

func on_body_enter_reach(body):
	if not body.is_in_group("player"): return
	
	if player_safe:
		dissolve()
	else:
		attack()

func dissolve():
	running = false
	get_node("anim").play("dissolve")
	
	yield(get_node("anim"), "finished")
	print("Monster dissolved")
	emit_signal("dissolved")

func attack():
	emit_signal("player_killed")
	#get_tree().reload_current_scene()

##################################################
