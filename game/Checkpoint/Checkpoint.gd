extends Area2D

export var enabled = true
var active = false

signal checkpoint_activated

func _ready():
	self.connect("body_enter", self, "_on_body_enter")

func _on_body_enter(body):
	if enabled and not active and body.has_method("update_checkpoint"):
		body.update_checkpoint(get_node("spawn_location").get_global_pos())
		active = true
		emit_signal("checkpoint_activated")

func set_enabled(value):
	enabled = value
