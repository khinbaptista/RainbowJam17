extends "res://Tools/FSM.gd".State

export(NodePath) var player_sprite = @"../../Sprite"
onready var sprite = get_node(player_sprite)

signal idle_anim_start
export(float) var wait_time = 2.0
var timer = 0.0

func enter():
	timer = 0.0
	set_process(true)

func exit():
	sprite.stop()
	set_process(false)

func _process(delta):
	timer += delta
	if timer >= wait_time:
		sprite.play("idle")
		emit_signal("idle_anim_start")
		set_process(false)
