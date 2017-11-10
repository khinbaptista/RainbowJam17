extends "res://Tools/FSM.gd"

var walking # as opposed to running (used by 'move' states)

func _ready():
	._ready()
	walking = false

#	set_process(true)

	# idle <-> move
	add_transition("idle", "move-begin", "move")
	add_transition("move-begin", "move-loop", "finished")
	add_transition("move-loop", "move-stop", "idle")
	add_transition("move-stop", "idle", "finished")
	add_transition("move-stop", "move-loop", "move")

	# idle <-> dash
	add_transition("idle", "dash", "dash")
	add_transition("dash", "dash-stop", "finished")
	add_transition("dash-stop", "idle", "finished")

	# dash-stop -> move
	add_transition("dash-stop", "move-begin", "move")
	add_transition("dash-stop", "dash", "dash")

	# move -> dash
	add_transition("move-begin", "dash", "dash")
	add_transition("move-loop", "dash", "dash")
	add_transition("move-stop", "dash", "dash")

	# x -> dead
	add_transition("idle", "dead", "dead")
	add_transition("move-begin", "dead", "dead")
	add_transition("move-loop", "dead", "dead")
	add_transition("move-stop", "dead", "dead")
	add_transition("dash-stop", "dead", "dead")

	add_transition("dead", "respawn", "respawn")
	add_transition("respawn", "idle", "finished")

	# move <-> stopped
	add_transition("move-loop", "stopped", "stop")
	add_transition("stopped", "move-begin", "move")
	
	# stopped -> dash
	add_transition("stopped", "dash", "dash")
	
	# stopped -> idle
	add_transition("stopped", "idle", "interact")
	
	# idle <-> falling
	add_transition("idle", "falling", "fall")
	add_transition("falling", "idle", "idle")

func _process(delta):
	get_node("/root/Debug/Label").set_text("FSM: " + current)
	print(current)
