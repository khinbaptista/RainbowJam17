extends Area2D

func _ready():
	self.connect("body_enter", self, "_on_body_enter")
	self.connect("body_exit", self, "_on_body_exit")

func _on_body_enter(body):
	if body.has_method("set_grounded"):
		body.set_grounded(true)
		
func _on_body_exit(body):
	if body.has_method("set_grounded"):
		body.set_grounded(false)