extends Node

export(int, FLAGS, "None", "Red", "Orange", "Yellow", "Green", "Blue", "Violet") var color = 0

export(NodePath) var player_path = @""
onready var player = get_node(player_path)

func activate():
	player.learn_color(color)
