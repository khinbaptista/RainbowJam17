extends "action.gd"

export(float) var speed = 350
export(float) var bonus = 0
export(float) var multiplier = 1

func get_final_speed():
	return speed * multiplier + bonus

func _execute(direction):
	var _speed = get_final_speed()
	var remaining = player.move(direction * _speed * get_process_delta_time())
	if player.is_colliding():
		var normal = player.get_collision_normal()
		remaining = remaining.slide(normal)
		player.move(remaining)
