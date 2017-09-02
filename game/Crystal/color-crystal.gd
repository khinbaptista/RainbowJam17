extends StaticBody2D

export(int, FLAGS, "None", "Red", "Orange", "Yellow", "Green", "Blue", "Violet") var color = 1

export(NodePath) var player_path = @""
onready var player = get_node(player_path)

func interaction():
#	var sprite = get_node("sprite");if sprite.has_method("play"):sprite.play("break");yield(sprite, "finished")
	player.learn_color(color)
	
#	var scale = get_scale() * 0.5; set_scale(scale)
	queue_free()
