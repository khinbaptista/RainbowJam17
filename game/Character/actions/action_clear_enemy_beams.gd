extends "action.gd"

func _ready():
	set_process_input(true)

func _input(event):
	if event.type == InputEvent.KEY:
		if not event.echo and event.pressed and event.scancode == KEY_Z:
			execute()

func _execute(params):
	if has_node("cooldown"):
		set_action_enabled(false)
		get_node("cooldown").start()
	
	get_tree().call_group(0, "enemy_ring", "despawn")
