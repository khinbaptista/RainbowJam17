extends Area2D

onready var player = get_parent()

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	var areas = get_overlapping_areas()
	var beams = []
	var ground = []
	
	for area in areas:
		if area.get_name() == "beam_area":
			beams.append(area.get_parent())
		elif area.is_in_group("platform") or area.is_in_group("ground"):
			ground.append(area)
	
	if ground.empty():
		player.grounded = false
		return
	
	var grounded = false
	for tile in ground:
		if not tile.has_node("sprite"): continue
		var ground_mask = tile.get_node("sprite").get_light_mask()
		
		if ground_mask >= 2 and ground_mask <= 64: 	# has a color
			if not beams.empty():
				for beam in beams:
					if ground_mask & beam.beam_color:
						print(beam.get_name())
						grounded = true
						break
		else:
			grounded = true		# ground has no color
			break
	
	player.grounded = grounded
