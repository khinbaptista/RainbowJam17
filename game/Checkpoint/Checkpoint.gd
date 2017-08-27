extends Area2D

var active = false

func _ready():
	self.connect("body_enter", self, "_on_body_enter")

func _on_body_enter(body):
	if not active and body.has_method("update_checkpoint"):
		body.update_checkpoint(self.get_global_pos())
		active = true