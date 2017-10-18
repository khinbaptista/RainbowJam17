extends StaticBody2D

export(int, FLAGS, "None", "Red", "Orange", "Yellow", "Green", "Blue", "Purple") var crystal_color = 1
export(float, 0, 1000, 1) var vibration_distance = 300

export(NodePath) var player_path = @""
var player# = get_node(player_path)
onready var sprite = get_node("sprite")
onready var press_e = get_node("sprite/press_e")

var layer = "behind"

func _ready():
	if Globals.has("player_path"):
		player = get_node(Globals.get("player_path"))
	else:
		print("Player not loaded")

	set_process(false)
	if player.knows_color(crystal_color):
		queue_free()	# the crystal is useless

func _process(delta):
	process_layer()

func interaction():
	player.learn_color(crystal_color)
	queue_free()

func process_layer():
	if layer == "front" and player.get_global_pos().y > get_global_pos().y:
		sprite.set_z(1)
		press_e.set_z(1)
		layer = "behind"
	if layer == "behind" and player.get_global_pos().y < get_global_pos().y:
		sprite.set_z(3)
		press_e.set_z(3)
		layer = "front"
