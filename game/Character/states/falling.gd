extends "res://Tools/FSM.gd".State

export(NodePath) var player_path = @"../.."
onready var player = get_node(player_path)

export(NodePath) var player_sprite = @"../../Sprite"
onready var sprite = get_node(player_sprite)

func enter():
	player.falling = true
	sprite.play("death-down")
	set_process(true)

func exit():
	sprite.stop()
	set_process(false)

func _process(delta):
	print("grounded: ", player.grounded)
	if not player.grounded:
		player.set_pos(Vector2(player.get_pos().x, player.get_pos().y + player.fall_speed * delta))
	else:
		player.falling = false
		fsm.make_transition("idle")
