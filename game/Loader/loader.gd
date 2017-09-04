extends Node

onready var anim = get_node("AnimationPlayer")

func change_scene( path ):
	anim.play("load_begin")
	yield(anim, "finished")
	
#	var new_scene = load(path)
	get_tree().change_scene(path)
	
	anim.play("load_finished")
