extends "res://Tools/FSM.gd".State

export(NodePath) var player_path = @"../.."
onready var player = get_node(player_path)

export(NodePath) var player_sprite = @"../../Sprite"
onready var sprite = get_node(player_sprite)

export(NodePath) var dash_action = @"../../Actions/dash"
onready var action = get_node(dash_action)

var is_dashing = false

func can_exit():
	return not is_dashing

func enter():
	var loop_time = action.dash_duration
	var direction = player.moveDir

	is_dashing = true

	var animation = "dash-" + direction + "-loop"
	sprite.play(animation)

	var timer = 0.0
	while timer < loop_time:
		timer += get_process_delta_time()
		yield(get_tree(), "idle_frame")

	animation = animation.replace("-loop", "-stop")
	sprite.play(animation)
	yield(sprite, "finished")

	is_dashing = false
	fsm.make_transition("finished")
