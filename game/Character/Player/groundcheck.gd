extends Area2D

onready var player = get_parent()

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	var overlap = get_overlapping_areas()
	var ground = []
	var standing_colors = []
	
	for area in overlap:
		if area.is_in_group("positive_beam"):
			if area.get_parent().is_inside(self): # check if inside hole
				standing_colors.append(area.get_parent().color_string)
		elif area.is_in_group("ground"):
			ground.append(area)
	
	if ground.empty():
		player.grounded = false
		return
	
	for tile in ground:
		if not tile.has_method("get_color"):
			player.grounded = true
			return
		
		var color = tile.get_color()
		
		if color == "Normal":
			player.grounded = true
			return
		
		if color in standing_colors:
			player.grounded = true
			return
	
	player.grounded = false
