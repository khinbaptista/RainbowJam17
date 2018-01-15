extends Node

signal changed

export(String, "sun", "moon", "ouroboros") var face = "sun"
export(String, "sun", "moon", "ouroboros") var correct_face = "sun"

onready var sprite = get_node("Sprite")

func _ready():
	var area = get_node("Area") # activation area
	area.connect("interacted", self, "on_activated")
	sprite.play(face)

func on_activated():
	if   face == "sun": face = "moon"
	elif face == "moon": face = "ouroboros"
	elif face == "ouroboros": face = "sun"
	sprite.play(face)
	
	emit_signal("changed")

func is_correct():
	return face == correct_face
