extends "res://Tools/FSM.gd".State

export(NodePath) var player_path = @"../.."
onready var player = get_node(player_path)

export(NodePath) var player_sprite = @"../../Sprite"
onready var sprite = get_node(player_sprite)

export(String, "begin", "loop", "stop") var stage = "begin"

func enter():
	set_process(true)
	if stage == "begin" or stage == "stop":
		sprite.connect("finished", fsm, "make_transition", ["finished"])

func exit():
	set_process(false)
	if stage == "begin" or stage == "stop":
		sprite.disconnect("finished", fsm, "make_transition")

func overwrite_animation():	# required for death anim to play when running
	var animation = sprite.get_animation()
	return not animation.begins_with("death")

func _process(delta):
	var animation = "run-" + player.moveDir + "-" + stage
	if sprite.get_animation() != animation and overwrite_animation():
		printt(stage, sprite.get_animation())
		sprite.play(animation)
