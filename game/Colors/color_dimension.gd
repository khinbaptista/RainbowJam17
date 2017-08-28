extends CanvasItem

export(int, FLAGS, "None", "Red", "Orange", "Yellow", "Green", "Blue", "Violet") var color_dimension = 1

func _ready():
	var colors = get_node("/root/colors")
	set_light_mask(color_dimension)
