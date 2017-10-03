extends "action.gd"

export(float) var speed = 350

func _execute(direction):
	var remaining = player.move(direction * speed * get_process_delta_time())
	if player.is_colliding():
		var normal = player.get_collision_normal()
		remaining = remaining.slide(normal)
		player.move(remaining)
