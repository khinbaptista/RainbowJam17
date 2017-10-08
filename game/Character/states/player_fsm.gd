extends "res://Tools/FSM.gd"

func _ready():
	._ready()
	# idle <-> move
	add_transition("idle", "move-begin", "move")
	add_transition("move-begin", "move-loop", "finished")
	add_transition("move-loop", "move-stop", "idle")
	add_transition("move-stop", "idle", "finished")
	
	# idle <-> dash
	add_transition("idle", "dash", "dash")
	add_transition("dash", "idle", "finished")
	
	# move -> dash
	add_transition("move-begin", "dash", "dash")
	add_transition("move-loop", "dash", "dash")
	add_transition("move-stop", "dash", "dash")

	# x -> dead
	add_transition("idle", "dead", "dead")
	add_transition("move-begin", "dead", "dead")
	add_transition("move-loop", "dead", "dead")
	add_transition("move-stop", "dead", "dead")
	
	add_transition("dead", "idle", "finished")
