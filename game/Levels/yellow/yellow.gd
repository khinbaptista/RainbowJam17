extends Node

func _on_Checkpoint9_body_enter( body ):
	get_node("../red/Checkpoint6").enabled = true
