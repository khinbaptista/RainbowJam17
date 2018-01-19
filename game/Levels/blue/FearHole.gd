extends Node2D

func _ready():
	get_tree().set_pause(false)
	get_node("WaitReload").connect("timeout", self, "reload")
	get_node("player").connect("death", self, "on_player_death")
	get_node("Monster").connect("player_killed", self, "on_player_death")

func on_player_death():
	get_tree().set_pause(true)
	get_node("WaitReload").start()

func reload():
	get_tree().reload_current_scene()
