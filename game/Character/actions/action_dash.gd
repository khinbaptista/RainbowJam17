extends "action.gd"

export(float) var dash_speed	= 800
export(float) var dash_duration	= 0.3

onready var cooldown = get_node("cooldown")

signal done

func can_execute():
	return cooldown.get_time_left() == 0 and .can_execute()

func _execute(direction):
	cooldown.start()
	_dash(direction.normalized())
	return true

func _dash(direction):
	var timer = 0.0
	
	while timer < dash_duration:
		var delta = get_process_delta_time()
		
		player.move(direction * dash_speed * delta)
		
		timer += delta
		yield(get_tree(), "idle_frame")
	
	emit_signal("done")
