tool
extends CanvasItem

# 0, 1, 2 ...
export(int, "Normal", "Red", "Orange", "Yellow", "Green", "Blue", "Purple") var color_alignment = 0 setget set_color
var color_mask

func _ready():
	set_color(color_alignment)

func set_color(color):
	color_alignment = color
	color_mask = (1 << color_alignment)
	set_light_mask(color_mask)
	manage_groups()

func manage_groups():
	if color_mask & Globals.get("Beams/RedMask"): add_to_group("red")
	elif is_in_group("red"): remove_from_group("red")

	if color_mask & Globals.get("Beams/OrangeMask"): add_to_group("orange")
	elif is_in_group("orange"): remove_from_group("orange")

	if color_mask & Globals.get("Beams/YellowMask"): add_to_group("yellow")
	elif is_in_group("yellow"): remove_from_group("yellow")

	if color_mask & Globals.get("Beams/GreenMask"): add_to_group("green")
	elif is_in_group("green"): remove_from_group("green")

	if color_mask & Globals.get("Beams/BlueMask"): add_to_group("blue")
	elif is_in_group("blue"): remove_from_group("blue")

	if color_mask & Globals.get("Beams/PurpleMask"): add_to_group("purple")
	elif is_in_group("purple"): remove_from_group("purple")
