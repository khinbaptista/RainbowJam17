extends Node2D

func _ready():
	var music = get_node("player/SamplePlayer2D").get_sample_library().get_sample("Iris (Continuous Loop)")
	music.set_loop_format(music.LOOP_FORWARD)
	music.set_loop_begin(0)
	music.set_loop_end(music.get_length())
	get_node("player/SamplePlayer2D").play("Iris (Continuous Loop)")
