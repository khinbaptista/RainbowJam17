extends StaticBody2D

onready var player = get_node(Globals.get("player_path"))

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func interaction():
	get_node("/root/loader").change_scene("res://Levels/world_new.tscn")
