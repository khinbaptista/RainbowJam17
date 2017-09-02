extends StaticBody2D

export(int, FLAGS, "None", "Red", "Orange", "Yellow", "Green", "Blue", "Violet") var color = 1

export(NodePath) var player_path = @""
onready var player = get_node(player_path)

func _ready():
	if player.colors_learned & color:
		queue_free()	# if the player already knows this color, the crystal is useless

func interaction():
#	var sprite = get_node("sprite");if sprite.has_method("play"):sprite.play("break");yield(sprite, "finished")
	player.learn_color(color)
	queue_free()
