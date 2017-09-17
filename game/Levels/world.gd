extends Node

func _ready():
	var music = get_node("SamplePlayer").get_sample_library().get_sample("Iris (Continuous Loop)")
	music.set_loop_format(music.LOOP_FORWARD)
	music.set_loop_begin(0)
	music.set_loop_end(music.get_length())
	get_node("SamplePlayer").play("Iris (Continuous Loop)")
