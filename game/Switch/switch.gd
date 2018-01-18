extends Area2D

var active = false

onready var animations = get_node("animations")

signal switch_activated

func interaction():
	animations.play("on")
	active = true
	emit_signal("switch_activated")
	