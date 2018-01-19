extends Node

var player
#export(int, FLAGS, "None", "Red", "Orange", "Yellow", "Green", "Blue", "Purple")
var colors_learned = 1

var levels = StringArray()
var current_level = 0

func _ready():
	levels.append("res://Levels/plaza/plaza.tscn")
	levels.append("res://Levels/world_new.tscn")
	levels.append("res://Levels/orange/02-orange.tscn")
	levels.append("res://Levels/yellow/trailer-yellow.tscn")
	#levels.append("res://Levels/green/")
	levels.append("res://Levels/blue/blue trailer.tscn")
	##levels.append("res://Levels/purple/")

func advance_level():
	current_level = (current_level + 1) % levels.size()
	get_node("/root/loader").change_scene(levels[current_level])

func set_player(p):
	player = p
	#player.colors_learned = colors_learned
	player.connect("new_color_learned", self, "on_new_color")

func on_new_color(color):
	if colors_learned & color: return	# color is aleady known
	colors_learned += color
