extends Node2D

export(NodePath) var crystal_path
onready var crystal = get_node(crystal_path)

func _ready():
	get_tree().set_pause(false)
	get_node("WaitReload").connect("timeout", self, "reload")
	get_node("player").connect("death", self, "on_player_death")
	get_node("Monster").connect("player_killed", self, "on_player_death")
	get_node("Monster").connect("dissolved", self, "on_victory")
	get_node("Monster/sprite").play("transform")
	yield(get_node("Monster/sprite"), "finished")
	get_node("Monster/sprite").play("run")

func on_player_death():
	get_tree().set_pause(true)
	get_node("WaitReload").start()

func reload():
	get_tree().reload_current_scene()

func on_victory():
	crystal.set_hidden(false)

func finished():
	get_node("/root/progress").advance_level()
