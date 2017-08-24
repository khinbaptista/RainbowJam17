tool
extends Node

enum Colors {
	None	= 0,
	Red		= 1,
	Orange	= 2,
	Yellow	= 4,
	Green	= 8,
	Blue	= 16,
	Violet	= 32
}

var player_path = null setget set_player
signal player_set(path)

func set_player(path):
	player_path = path
	emit_signal("player_set", player_path)
