extends Node

signal completed

var PillarClass = preload("pillar/Pillar.gd")
var pillars = []

func _ready():
	find_pillars()
	connect_pillar_signals()

func find_pillars():
	for child in get_children():
		if child extends PillarClass:
			pillars.append(child)

func connect_pillar_signals():
	for pillar in pillars:
		pillar.connect("changed", self, "on_pillar_change")

func disconnect_pillar_signals():
	for pillar in pillars:
		pillar.disconnect("changed", self, "on_pillar_change")

func on_pillar_change():
	for pillar in pillars:
		if not pillar.is_correct():
			return
	
	emit_signal("completed")
