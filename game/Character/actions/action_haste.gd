extends "action.gd"

export(float) var haste_ratio = 5
export(float) var haste_duration = 10
onready var player_move = player.get_node("Actions/move")
onready var cooldown = get_node("cooldown")

var timer = 0

func can_execute():
	return cooldown.get_time_left() == 0 and .can_execute()

func _ready():
	set_process_input(true)

func _input(event):
	if event.type == InputEvent.KEY:
		if not event.echo and event.pressed and event.scancode == KEY_C:
			execute()

func _execute(params):
	cooldown.start()
	player_move.set_multiplier(haste_ratio)
	
	timer = 0
	while timer < haste_duration:
		timer += get_process_delta_time()
		yield(get_tree(), "idle_frame")
	timer = 0
	player_move.set_multiplier(1)
