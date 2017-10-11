extends "res://Tools/FSM.gd".State

export(NodePath) var player_path = @"../.."
onready var player = get_node(player_path)

export(NodePath) var player_sprite = @"../../Sprite"
onready var sprite = get_node(player_sprite)

func enter():
	var animation = "dash-" + player.moveDir + "-stop"
	sprite.stop()
	sprite.play(animation)
	sprite.connect("finished", self, "on_finish")

func exit():
	if sprite.is_connected("finished", self, "on_finish"):
		sprite.disconnect("finished", self, "on_finish")

func on_finish():
	fsm.make_transition("finished")
