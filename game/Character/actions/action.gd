extends Node

export(bool) var enabled = true

export(NodePath) var player_path = @"../.."
onready var player = get_node(player_path)

func can_execute():
	return enabled

func execute(params = null):
	if not can_execute(): return false
	return _execute(params)

func _execute(params):
	return true
