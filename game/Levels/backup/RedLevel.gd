extends Node2D

func _ready():
	var music = get_node("player/SamplePlayer2D").get_sample_library().get_sample("Iris (Continuous Loop)")
	music.set_loop_format(music.LOOP_FORWARD)
	music.set_loop_begin(0)
	music.set_loop_end(music.get_length())
	get_node("player/SamplePlayer2D").play("Iris (Continuous Loop)")

func _on_Checkpoint_checkpoint_activated():
	yield(get_node("platforms/tempPlatforms/platform13/sprite"), "finished")
	get_node("platforms/tempPlatforms").queue_free()
	get_node("Checkpoint1").enabled = true
	get_node("Checkpoint3").enabled = true


func _on_Checkpoint9_body_enter( body ):
	get_node("Checkpoint6").enabled = true
