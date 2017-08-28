extends Node

export(int, FLAGS, "None", "Red", "Orange", "Yellow", "Green", "Blue", "Violet") var color = 1

export(NodePath) var player_path = @""
onready var player = get_node(player_path)

func activate():
	var sprite = get_node("Sprite")
	if sprite.has_method("play"):
		sprite.play("break")
		yield(sprite, "finished")
	player.learn_color(color)
	#queue_free()
