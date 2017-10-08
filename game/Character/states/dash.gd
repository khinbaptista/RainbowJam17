extends "res://Tools/FSM.gd".State

export(NodePath) var player_path = @"../.."
onready var player = get_node(player_path)

export(NodePath) var player_sprite = @"../../Sprite"
onready var sprite = get_node(player_sprite)

var is_dashing = false

func can_exit():
	return not is_dashing

func enter():
	var direction = player.moveDir
	
	is_dashing = true
	
	sprite.play("dash-" + direction + "-begin")
	yield(sprite, "finished")
	
	sprite.play("dash-" + direction + "-loop")
	yield(sprite, "finished")
	
	sprite.play("dash-" + direction + "-stop")
	yield(sprite, "finished")
	
	is_dashing = false
	fsm.make_transition("finished")
