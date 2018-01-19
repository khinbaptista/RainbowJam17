extends StaticBody2D

var layer = "behind"

onready var sprite = get_node("orange bush")
onready var player = get_node(Globals.get("player_path"))

func _ready():
	set_process(true)
	
func _process(delta):
	process_layer()	

func process_layer():
	if layer == "front" and player.get_global_pos().y > get_global_pos().y:
		sprite.set_z(1)
		layer = "behind"
	if layer == "behind" and player.get_global_pos().y < get_global_pos().y:
		sprite.set_z(3)
		layer = "front"