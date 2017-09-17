extends Particles2D

export(int, FLAGS, "None", "Red", "Orange", "Yellow", "Green", "Blue", "Purple") var last_color = 16

func _ready():
	get_node("Area2D").connect("body_enter", self, "_on_body_enter")

func _on_new_color_learned( color ):
	if color & last_color:
		self.set_emitting(true)
		get_node("Area2D/CollisionShape2D").set_trigger(false)

func _on_body_enter( body ):
	if body.get_name() == "player" and self.is_emitting():
		get_node("/root/loader").change_scene("res://Menu/Credits.tscn")
