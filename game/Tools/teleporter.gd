extends Node2D

export(String, FILE, "*.tscn") var nextScene
export(bool) var active = false

onready var player = get_node(Globals.get("player_path"))

func _ready():
	if not active:
		hide()
	set_process(true)
	player.connect("new_color_learned", self, "activate")
	
func activate():
	active = true
	show()

func _on_Area2D_body_enter( body ):
	if active and body.is_in_group("player"):
		get_node("/root/loader").change_scene(nextScene)
		
