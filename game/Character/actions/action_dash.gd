extends "action.gd"

export(float) var dash_speed	= 800
export(float) var dash_duration	= 0.3

export(float) var speed_bonus = 0
export(float) var speed_multiplier = 1

onready var cooldown = get_node("cooldown")

signal done

func can_execute():
	return cooldown.get_time_left() == 0 and .can_execute()

func _execute(direction):
	cooldown.start()
	_dash(direction.normalized())
	return true

func get_final_speed():
	return dash_speed * speed_multiplier + speed_bonus

func _dash(direction):
	var timer = 0.0

	while timer < dash_duration:
		var speed = get_final_speed()
		var delta = get_process_delta_time()

		player.move(direction * speed * delta)

		timer += delta
		yield(get_tree(), "idle_frame")

	emit_signal("done")
