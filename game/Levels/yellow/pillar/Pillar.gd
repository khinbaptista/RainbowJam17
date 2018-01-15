extends Node

signal changed

export(String, "sun", "moon", "ouroboros") var face = "sun"
export(String, "sun", "moon", "ouroboros") var correct_face = "sun"

onready var sprite = get_node("Sprite")
var rotating = false

func _ready():
	var area = get_node("Area") # activation area
	area.connect("interacted", self, "on_activated")
	sprite.play(face)

func on_activated():
	if rotating: return
	rotating = true
	if   face == "sun": face = "moon"
	elif face == "moon": face = "ouroboros"
	elif face == "ouroboros": face = "sun"
	sprite.play(face)
	
	yield(sprite, "finished")
	emit_signal("changed")
	rotating = false

func is_correct():
	return face == correct_face
