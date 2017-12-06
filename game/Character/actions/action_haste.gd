extends "action.gd"

export(float) var haste_ratio = 5
export(float) var haste_duration = 2.0
onready var player_move = player.get_node("Actions/move")
onready var cooldown = get_node("cooldown")

var timer = 0

signal done

func can_execute():
	return cooldown.get_time_left() == 0 and .can_execute()

func _execute(params):
	if not can_execute():
		return
	
	cooldown.start()
	var delta = get_process_delta_time()
	player_move.multiplier = haste_ratio
	
	while timer < haste_duration:
		timer += delta
	timer = 0
	player_move.multiplier = 1
	emit_signal("done")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
