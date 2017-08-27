extends "res://Colors/color_dimension.gd"

var area

func _ready():
	area = get_node("area")
	area.connect("body_enter", self, "_on_body_enter")
	area.connect("body_exit", self, "_on_body_exit")
	area.connect("area_enter", self, "_on_area_enter")
	area.connect("area_exit", self, "_on_area_exit")

func _on_body_enter(body):
	if body.has_method("entered_platform") and color_dimension == 1:
		body.entered_platform()
	
func _on_body_exit(body):
	if body.has_method("left_platform") and color_dimension == 1:
		body.left_platform()
		
func _on_area_enter(entered):
	if entered.get_parent().has_method("check_color"):
		var color = entered.get_parent().check_color()
		if color && color_dimension:
			update_physics(player, true)
	
func _on_area_exit(exited):
	if exited.get_parent().has_method("check_color"):
		var color = exited.get_parent().check_color()
		if color && color_dimension:
			update_physics(player, false)

func update_physics(player, exec):
	if exec:
		area.set_layer_mask(1)
		area.set_collision_mask(1)
	else:
		area.set_layer_mask(2)
		area.set_collision_mask(2)
		
	if area.overlaps_body(player):
		if exec:
			player.entered_platform()
		else:
			player.left_platform()