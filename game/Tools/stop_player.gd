extends Area2D

export var active = true
export(int, "dash", "interact", "timer") var unlocked_by = 0
export var time = 2.1

onready var timer = get_node("Timer")
onready var player = get_node(Globals.get("player_path"))

func _ready():
	timer.set_wait_time(time)

func _input(event):
	if active:
		if unlocked_by == 0 and Input.is_action_pressed("dash"):
			player.get_node("FSM").make_transition("dash")
			unlock()
		elif unlocked_by == 1 and Input.is_action_pressed("interact"):
			player.get_node("FSM").make_transition("interact")
			unlock()

func unlock():
	player.set_can_move(true)

func _on_stop_player_body_enter( body ):
	if body == player:
		player.set_can_move(false)
		player.get_node("FSM").make_transition("stop")
		#player.get_node("timer_idle").stop()
		#player.set_pause_mode(true)
		#player.get_node("Sprite").play("idle")
		#player.get_node("Sprite").stop()
		if unlocked_by == 2:
			timer.start()
