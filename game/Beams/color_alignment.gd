extends CanvasItem

export(String, "Normal", "Red", "Orange", "Yellow", "Green", "Blue", "Purple") var color_string = "Normal"
var color_mask

func _ready():
	set_color(color_string)

func set_color(color):
	var prev_color = color_string
	color_string = color
	color_mask = Globals.get("Beams/" + color_string + "Mask")

	set_light_mask(color_mask)

	if is_in_group(prev_color.to_lower()): remove_from_group(prev_color.to_lower())
	if not is_in_group(color_string.to_lower()): add_to_group(color_string.to_lower())
