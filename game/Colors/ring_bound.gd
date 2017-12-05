extends Area2D

func _ready():
	connect("area_enter", self, "on_area_enter")
	connect("area_exit", self, "on_area_exit")

func fade():
	var others = get_overlapping_areas() + get_overlapping_bodies()
	for other in others:
		on_area_exit(other)

func on_area_enter(area):
	if area.get_name() == "negative": return
	
	if area.is_in_group(get_parent().color_string.to_lower()):
		if area.is_in_group("platform"):
			area.get_node("sprite").show()

func on_area_exit(area):
	if area.get_name() == "negative": return
	
	if area.is_in_group(get_parent().color_string.to_lower()):
		if area.is_in_group("platform"):
			area.get_node("sprite").hide()
