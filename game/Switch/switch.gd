extends Area2D

var active = false

onready var animations = get_node("animations")

export(NodePath) var target_path

func interaction():
	var target = get_node(target_path)
	animations.play("on")
	active = true
	if target.has_method("activate"):
		target.activate()
	