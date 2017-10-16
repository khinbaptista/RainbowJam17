tool
extends Light2D

export(int, FLAGS, "None", "Red", "Orange", "Yellow", "Green", "Blue", "Violet") var beam_color = 1 setget changed_color
export(Color, RGBA) var color_value setget changed_color_value
var learned = false


func _ready():
	changed_color(beam_color)
	changed_color_value(color_value)
	
	var color_string = color_index2string(beam_color)
	if color_string: add_to_group(color_string)
	
	#print(get_node("sprite").get_light_mask())

func changed_color_value(value):
	color_value = value
	
	#get_node("light").set_color(color_value)
	if has_node("sprite"):
		get_node("sprite").set_modulate(color_value)
	
	if has_node("sprite_over"):
		var color_over = color_value
		color_over.a *= 0.5
		get_node("sprite_over").set_modulate(color_over)

func changed_color(new_color):
	beam_color = new_color
	
	if has_node("sprite"):
		get_node("sprite").set_light_mask(beam_color * pow(2, 13))
		
	if has_node("sprite_over"):
		get_node("sprite_over").set_light_mask(beam_color * pow(2, 13))
	
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
	#show()
	learned = true
	
	var duration = 2.0
	var timer = 0.0
	var modulation = get_node("sprite").get_modulate()
	var max_alpha = modulation.a
	
	while timer < duration:
		modulation.a = (timer / duration) * max_alpha
		get_node("sprite").set_modulate(modulation)
		timer += get_process_delta_time()
		yield(get_tree(), "idle_frame")
