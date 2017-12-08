extends "Enemy.gd"

export(float, 0, 1, 0.01) var beam_chance = 0.2

func _ready():
	if player.has_node("spawner"):
		player.get_node("spawner").connect("spawning_beams", self, "spawn_beam_chance")

func spawn_beam_chance():
	if randf() > beam_chance: return
	get_node("spawner").spawn()
