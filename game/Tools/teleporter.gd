extends Node2D

export(String, FILE, "*.tscn") var nextScene


func _on_Area2D_body_enter( body ):
	if body.is_in_group("player"):
		get_node("/root/loader").change_scene(nextScene)
		
