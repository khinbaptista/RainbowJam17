tool
extends Light2D

export(int, FLAGS, "None", "Red", "Orange", "Yellow", "Green", "Blue", "Violet") var beam_color = 1 setget changed_color
export(Color, RGBA) var color_value setget changed_color_value
var distance_to_red = 0.0

func _ready():
	changed_color(beam_color)
	changed_color_value(color_value)
	
	var color_string = color_index2string(beam_color)
	if color_string: add_to_group(color_string)

func changed_color_value(value):
	color_value = value
	
	#get_node("light").set_color(color_value)
	if has_node("sprite"):
		get_node("sprite").set_modulate(color_value)

func changed_color(new_color):
	beam_color = new_color
	
	if not has_node("light"): return
	
	if beam_color <= 1:
		set_item_mask(0)
		get_node("light").set_item_mask(1)
	else:
		get_node("light").set_item_mask(beam_color + 1)
		set_item_mask(beam_color)
		
func check_color():
	return beam_color

func color_index2string(index):
	if index & 2:	return "red"
	if index & 4:	return "orange"
	if index & 8:	return "yellow"
	if index & 16:	return "green"
	if index & 32:	return "blue"
	if index & 64:	return "purple"

func color_revealed():
	show()
	
	var duration = 2.0
	var timer = 0.0
	var max_alpha = get_node("sprite").get_modulate().a
	
	while timer < duration:
		var modulation = get_node("sprite").get_modulate()
		modulation.a = (timer / duration) * max_alpha
		get_node("sprite").set_modulate(modulation)
		timer += get_process_delta_time()
		yield(get_tree(), "idle_frame")
