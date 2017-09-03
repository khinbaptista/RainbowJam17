extends StaticBody2D

export(int, FLAGS, "None", "Red", "Orange", "Yellow", "Green", "Blue", "Purple") var crystal_color = 1

export(NodePath) var player_path = @""
onready var player = get_node(player_path)

func _ready():
	if player.knows_color(crystal_color):
		queue_free()	# the crystal is useless

func interaction():
#	var sprite = get_node("sprite");if sprite.has_method("play"):sprite.play("break");yield(sprite, "finished")
	player.learn_color(crystal_color)
	queue_free()
