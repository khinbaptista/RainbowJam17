extends Node

onready var anim = get_node("AnimationPlayer")

func change_scene( path ):
	anim.play("load_begin")
	yield(anim, "finished")

#	get_tree().change_scene(path)

	# testing new multi-threaded loader
	var loader = get_node("multithread")
	loader.queue_resource(path)

	var timer = Timer.new()
	timer.set_autostart(true)
	timer.set_one_shot(false)
	timer.set_wait_time(0.005)
	add_child(timer)

	while not loader.is_ready(path):
		var progress = "Progress: " + loader.get_progress_string(path)
		yield(timer, "timeout")

	get_tree().change_scene_to(loader.get_resource(path))

	anim.play("load_finished")
