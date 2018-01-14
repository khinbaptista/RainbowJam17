extends Area2D

onready var follower = get_parent()
var found_ground

func _ready():
	set_process(true)

func _process(delta):
	if follower.active:
		var overlap = get_overlapping_areas()
		found_ground = false
		
		for area in overlap:
			if area.is_in_group("ground"):
				found_ground = true
			elif area.is_in_group("platform"):
				found_ground = true
			else:
				found_ground = false or found_ground
		
		if found_ground:
			follower.grounded = true
		else:
			follower.grounded = false