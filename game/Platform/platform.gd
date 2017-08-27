extends "res://Colors/color_dimension.gd"

var area

func _ready():
	area = get_node("area")
	area.connect("body_enter", self, "_on_body_enter")
	area.connect("body_exit", self, "_on_body_exit")

func _on_body_enter(body):
	if body.has_method("entered_platform"):
		body.entered_platform()
		
func _on_body_exit(body):
	if body.has_method("left_platform"):
		body.left_platform()
		
func update_physics(player, exec):
	if exec:
		area.set_monitorable(true)
	else:
		area.set_monitorable(false)
		
	if area.overlaps_body(player):
		if exec:
			player.entered_platform()
		else:
			player.left_platform()