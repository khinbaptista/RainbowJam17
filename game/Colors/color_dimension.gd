tool
extends CanvasItem

export(int, FLAGS, "None", "Red", "Orange", "Yellow", "Green", "Blue", "Violet") var color = 1 setget set_color

export(NodePath) var physics_body_path setget set_physics_body

func _ready():
	var colors = get_node("/root/colors")
	
	if colors.player_path == null or not has_node(colors.player_path):
		colors.connect("player_set", self, "on_player_set")
	else:
		on_player_set(colors.player_path)

func on_player_set(path):
	# with the player reference we can check which colors the player has already learned and get access to the color beams
	# (all color beams are located at @"player/camera/beam"
	pass

func set_color(new_color):
	color = new_color
	set_light_mask(color)
	update_physics_body()

func set_physics_body(path):
	physics_body_path = path
	update_physics_body()

func update_physics_body():
	if not has_node(physics_body_path): return
	
	var body = get_node(physics_body_path)
	body.set_collision_mask_bit(0, true)	# if the user has the value and this object is colliding with this color
