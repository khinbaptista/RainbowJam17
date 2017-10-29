extends Node

export(String, FILE, "*.tscn") var first_scene

func _ready():
	get_node("/root/loader").change_scene(first_scene)
