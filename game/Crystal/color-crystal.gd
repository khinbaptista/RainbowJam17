extends StaticBody2D

export(int, FLAGS, "None", "Red", "Orange", "Yellow", "Green", "Blue", "Purple") var crystal_color = 1

export(NodePath) var player_path = @""
onready var player = get_node(player_path)
onready var sprite = get_node("sprite")
onready var press_e = get_node("press_e")

var layer = "behind"

func _ready():
	set_process(true)
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
