tool
extends Light2D

export(int, FLAGS, "None", "Red", "Orange", "Yellow", "Green", "Blue", "Violet") var beam_color = 1 setget changed_color
export(Color, RGBA) var color_value setget changed_color_value
var distance_to_red = 0.0


func _ready():
	changed_color(beam_color)
	changed_color_value(color_value)

func changed_color_value(value):
	color_value = value
	
	if not has_node("light"): return
	get_node("light").set_color(color_value)

func changed_color(new_color):
	beam_color = new_color
	
	if not has_node("light"): return
	
	if beam_color == 1:
		set_item_mask(0)
		get_node("light").set_item_mask(1)
	else:
		get_node("light").set_item_mask(beam_color + 1)
		set_item_mask(beam_color)
		
func check_color():
	return beam_color
