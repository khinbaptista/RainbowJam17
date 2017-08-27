tool
extends CanvasItem

export(int, FLAGS, "None", "Red", "Orange", "Yellow", "Green", "Blue", "Violet") var color_dimension = 1 setget set_color

var player

func _ready():
	var colors = get_node("/root/colors")
	
	if colors.player_path == null or not has_node(colors.player_path):
		colors.connect("player_set", self, "on_player_set")
	else:
		on_player_set(colors.player_path)

func on_player_set(path):
	# with the player reference we can check which colors the player has already learned and get access to the color beams
	# (all color beams are located at @"player/camera/beam"
	if not has_node(path):
		return
	player = get_node(path)

func set_color(new_color):
	color_dimension = new_color
	set_light_mask(color_dimension)
	update_physics_body()

func update_physics_body():
	if not player: return 
	#body.set_collision_mask_bit(0, player.colors_learned & color_dimension)	# if the user has the value and this object is colliding with this color
	if has_method("update_physics"):
		#var pl = self.get_parent().get_node("player")
		update_physics(player, player.colors_learned & color_dimension)