extends "res://Tools/FSM.gd".State

export(NodePath) var player_path = @"../.."
onready var player = get_node(player_path)

export(NodePath) var player_sprite = @"../../Sprite"
onready var sprite = get_node(player_sprite)

func enter():
	var animation = "death-" + player.moveDir
	sprite.play(animation)
