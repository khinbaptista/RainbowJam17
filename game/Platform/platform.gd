extends Area2D

func _ready():
	self.connect("body_enter", self, "_on_body_enter")
	self.connect("body_exit", self, "_on_body_exit")

func _on_body_enter(body):
	if body.has_method("entered_platform"):
		body.entered_platform()
		
func _on_body_exit(body):
	if body.has_method("left_platform"):
		body.left_platform()