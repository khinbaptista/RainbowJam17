extends "res://Tools/FSM.gd".State

export(NodePath) var player_path = @"../.."
onready var player = get_node(player_path)

export(NodePath) var player_sprite = @"../../Sprite"
onready var sprite = get_node(player_sprite)

export(String, "begin", "loop", "stop") var stage

func enter():
	if stage != "loop":
		sprite.connect("finished", fsm, "make_transition", ["finished"])
	set_process(true)

func _process(delta):
	var direction = player.moveDir
	
	if sprite.get_animation() != ("run-" + direction + "-" + stage):
		sprite.play("run-" + direction + "-" + stage)
