extends Node

func _ready():
	get_node("/root/progress").current_level = 4
	
	var music = get_node("SamplePlayer").get_sample_library().get_sample("Iris (Continuous Loop)")
	music.set_loop_format(music.LOOP_FORWARD)
	music.set_loop_begin(0)
	music.set_loop_end(music.get_length())
	get_node("SamplePlayer").play("Iris (Continuous Loop)")

func _on_player_new_color_learned( color ):
	get_node("player/camera/Node2D/AnimatedSprite").play("transition")
