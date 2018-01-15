extends Area2D

func _ready():
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("interact") and not event.is_echo():
		var bodies = self.get_overlapping_bodies()
		for body in bodies:
			if body.has_method("interaction"): body.interaction()
		var areas = self.get_overlapping_areas()
		for area in areas:
			if area.has_method("interaction"): area.interaction()
