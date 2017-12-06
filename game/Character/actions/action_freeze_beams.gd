extends "action.gd"

export(NodePath) var spawner_path
export(float) var freeze_duration

func _ready():
	set_process_input(true)

func _input(event):
	if event.type == InputEvent.KEY:
		if not event.echo and event.pressed and event.scancode == KEY_X:
			execute()

func _execute(params):
	if has_node("cooldown"):
		self.set_action_enabled(false) # wait cooldown
		get_node("cooldown").start()
	
	get_node(spawner_path).freeze(freeze_duration)

