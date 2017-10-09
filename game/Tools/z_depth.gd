extends Node2D

export(NodePath) var player_path = @""
export(NodePath) var sprite_path = @""

onready var player = get_node(player_path)
onready var sprite = get_node(sprite_path)

var layer = "behind"

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