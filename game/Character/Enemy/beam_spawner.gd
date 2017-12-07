extends Node

export(PackedScene) var ring_scene
export(float, 0.0, 60.0, 0.1) var wait_time = 0.5
export(Vector2) var offset = Vector2()

onready var character = get_parent()

func spawn():
	var ring = ring_scene.instance()
	add_child(ring)
	ring.set_global_pos(character.get_global_pos() + offset)
	ring.spawn()
