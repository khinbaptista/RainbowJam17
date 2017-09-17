extends Node

func _on_Checkpoint_checkpoint_activated():
	yield(get_node("platforms/tempPlatforms/platform13/sprite"), "finished")
	get_node("platforms/tempPlatforms").queue_free()
	get_node("Checkpoint1").enabled = true
	get_node("Checkpoint3").enabled = true


func _on_Checkpoint9_body_enter( body ):
	get_node("Checkpoint6").enabled = true
