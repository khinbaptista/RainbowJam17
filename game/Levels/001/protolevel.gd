extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	var music = get_node("SamplePlayer2D").get_sample_library().get_sample("Iris (Continuous Loop)")
	music.set_loop_format(music.LOOP_FORWARD)
	music.set_loop_begin(0)
	music.set_loop_end(music.get_length())
	get_node("SamplePlayer2D").play("Iris (Continuous Loop)")
