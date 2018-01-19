extends Node2D

export(Array) var observers

func activate():
	for obs in observers:
		get_node(obs).activate()
