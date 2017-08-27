extends Node2D

func _ready():
	var area = get_node("area")
	area.connect("body_enter", self, "_on_body_enter")
	area.connect("body_exit", self, "_on_body_exit")

func _on_body_enter(body):
	if body.has_method("entered_platform"):
		body.entered_platform()
		
func _on_body_exit(body):
	if body.has_method("left_platform"):
		body.left_platform()