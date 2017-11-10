extends Node

onready var player = get_node(Globals.get("player_path"))

func _ready():
	var music = get_node("SamplePlayer").get_sample_library().get_sample("Iris (Continuous Loop)")
	music.set_loop_format(music.LOOP_FORWARD)
	music.set_loop_begin(0)
	music.set_loop_end(music.get_length())
	get_node("SamplePlayer").play("Iris (Continuous Loop)")
	
#	set_process(true)
#
#func _process(delta):
#	print("falling: ", player.falling)
#	if not player.falling:
#		player.get_node("FSM").make_transition("fall")
#		print("teste")
#	else:
#		set_process(false)