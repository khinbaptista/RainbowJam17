extends Area2D

signal interacted

func interaction():
	emit_signal("interacted")
