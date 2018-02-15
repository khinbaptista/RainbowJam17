extends Node

export var group_name = "sort_y"
export var min_z = 0
export var max_z = 10000

var nodes = []

##################################################

func _ready():
	get_tree().connect("tree_changed", self, "on_tree_changed")
	get_tree().connect("node_removed", self, "on_node_removed")
	on_tree_changed()

func on_tree_changed():
	nodes = get_tree().get_nodes_in_group(group_name)
	update_z()

func on_node_removed(node):
	if node in nodes: nodes.erase(node)

##################################################

func compare_func(a, b):
	return a.get_pos().y < b.get_pos().y

func update_z():
	nodes.sort_custom(self, "compare_func")
	
	var i = min_z
	for node in nodes:
		node.set_z(i)
		i += 1
	
	if i > max_z:
		printerr("Error: more nodes to order than ", max_z)

##################################################
