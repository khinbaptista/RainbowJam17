extends Area2D

var active = false

onready var animations = get_node("animations")

export(Array) var target_path
export(NodePath) var stopper

func interaction():
	var target
	for t in target_path:
		target = get_node(t)
		if target.has_method("activate"):
			target.activate()
	if stopper:
		get_node(stopper).active = false
	animations.play("on")
	active = true

	