extends Node2D

onready var player = get_node(Globals.get("player_path"))
onready var light = player.get_node("Light2D")
onready var player_start_pos = Vector2()

var darken_screen = false
var player_moved = false
var last_vector = 0

func _ready():
	set_process(true)

func _process(delta):
	if darken_screen:
		_darken_screen(delta)

func _darken_screen(delta):
	print("  energy: ", light.get_energy(), "  vector: ", player.get_global_pos().x - player_start_pos.x, "  last_vector: ", last_vector)
	var vector = player.get_global_pos().x - player_start_pos.x
	if vector != last_vector:	player_moved = true
	
	if light.get_energy() >= 0 and light.get_energy() <= 1 and player_moved:
		light.set_energy(vector * delta / 40)
	elif light.get_energy() > 1:	light.set_energy(1)
	elif light.get_energy() < 0:	light.set_energy(0)
	
	last_vector = vector
	player_moved = false

func _on_darken_screen_body_enter( body ):
	darken_screen = true
	player_start_pos = player.get_global_pos()
	light.show()
#	player.set_walk_slow(true)
	player.set_speed(150)
