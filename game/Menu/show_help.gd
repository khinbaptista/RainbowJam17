extends Node2D

onready var sprite = get_node("Sprite")

func _ready():
	get_node("Area2D").connect("body_enter", self, "show_help")
	get_node("Area2D").connect("body_exit", self, "hide_help")
	sprite.hide()

func show_help(body):
	if (body.get_type() == "KinematicBody2D"):
		sprite.show()

func hide_help(body):
	if (body.get_type() == "KinematicBody2D"):
		sprite.hide()