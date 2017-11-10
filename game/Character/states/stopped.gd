extends "res://Tools/FSM.gd".State

export(NodePath) var player_sprite = @"../../Sprite"
onready var sprite = get_node(player_sprite)

func enter():
	sprite.play("stopped")

func exit():
	sprite.stop()