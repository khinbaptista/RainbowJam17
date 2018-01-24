extends StaticBody2D

export(int, "Normal", "Red", "Orange", "Yellow", "Green", "Blue", "Purple") var crystal_color = 0
export(float, 0, 1000, 1) var vibration_distance = 300

onready var player = get_node(Globals.get("player_path"))
onready var sprite = get_node("sprite")
onready var press_e = get_node("sprite/press_e")

var layer = "behind"

signal caught

func _ready():
	set_process(false)
	if player.knows_color(1 << crystal_color):
		queue_free()	# the crystal is useless

func _process(delta):
	process_layer()

func interaction():
	if not is_hidden():
		player.learn_color(1 << crystal_color)
		emit_signal("caught")
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
		
func activate():
	show()
