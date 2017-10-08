extends Node

##################################################

class State extends Node:
	onready var fsm = get_parent()
	
	func can_enter(): return true
	func can_exit(): return true
	
	func enter(): pass
	func exit(): pass
	
##################################################

var states = {}
var transitions = {}

var current = ""

func _ready():
	var children = get_children()
	for child in children:
		if child extends State:
			states[child.get_name()] = child
			if current == "": current = child.get_name()
	
	states[current].enter()

func add_transition(from, to, key):
	transitions[from] = { key : to }

func make_transition(key):
	var next			= transitions[current][key]
	var next_state		= states[next]
	var current_state	= states[current]

	if current_state.can_exit() and next_state.can_enter():
		current_state.exit()
		current = next
		next_state.enter()
		return true
	
	return false
