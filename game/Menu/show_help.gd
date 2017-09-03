extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	get_node("Area2D").connect("body_enter", self, "show_help")
	get_node("Area2D").connect("body_exit", self, "hide_help")
	
func show_help(body):
	if (body.get_type() == "KinematicBody2D"):
		self.show()
	
func hide_help(body):
	if (body.get_type() == "KinematicBody2D"):
		self.hide()