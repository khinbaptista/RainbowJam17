extends Node2D

onready var player = get_node(Globals.get("player_path"))
onready var light = player.get_node("Light2D")
onready var player_start_pos = Vector2()
onready var player_movement = player.get_node("Actions/move")
onready var player_speed = player_movement.speed
var player_dash

var darken_screen = false
var player_moved = false
var last_vector = 0

func _ready():
	set_process(true)

func _process(delta):
#	if player_speed == 0:
#		player_speed = player_movement.speed
	if darken_screen:
		_darken_screen(delta)

func _darken_screen(delta):
#	print("  energy: ", light.get_energy(), "  vector: ", player.get_global_pos().x - player_start_pos.x, "  last_vector: ", last_vector)
	var vector = player.get_global_pos().x - player_start_pos.x
	if vector != last_vector:	player_moved = true

	if light.get_energy() >= 0 and light.get_energy() <= 1 and player_moved:
		light.set_energy(vector / 2400)
	elif light.get_energy() > 1:
		player.get_node("Sprite").play("death-kneel")
		player_movement.multiplier = 0
		player_dash.speed_multiplier = 0
		yield(player.get_node("Sprite"), "finished")
		get_node("/root/loader").change_scene("res://Menu/start_menu.tscn")
	elif light.get_energy() < 0:	light.set_energy(0)

	last_vector = vector
	player_moved = false

func _on_darken_screen_body_enter( body ):
	if body == player:
		darken_screen = true

		player_start_pos = player.get_global_pos()
		player_movement = body.get_node("Actions/move")
		player_dash = body.get_node("Actions/dash")

		light.show()
#		player.set_walk_slow(true)
		player.set_speed(200)
		get_node("island3/darken_screen").queue_free()


func _on_hidden_platforms_1_body_enter( body ):
	get_node("island3/move_camera")._set_active(true)
	get_node("platforms/hiddenPlatforms/hidden_4").set_collision_mask_bit(0, 1)
	get_node("platforms/hiddenPlatforms/hidden_4").set_layer_mask_bit(0, 1)
	for N in get_node("platforms/hiddenPlatforms/1").get_children():
		if N.has_method("spawn"):
			N.spawn()
	get_node("platforms/hiddenPlatforms/hidden_1").queue_free()


func _on_hidden_2_body_enter( body ):
	for N in get_node("platforms/hiddenPlatforms/2").get_children():
		if N.has_method("spawn"):
			N.spawn()
	get_node("platforms/hiddenPlatforms/hidden_2").queue_free()


func _on_hidden_3_body_enter( body ):
	for N in get_node("platforms/hiddenPlatforms/3").get_children():
		if N.has_method("spawn"):
			N.spawn()
	get_node("platforms/hiddenPlatforms/hidden_3").queue_free()

func _on_hidden_4_body_enter( body ):
	for N in get_node("platforms/hiddenPlatforms/4").get_children():
		if N.has_method("spawn"):
			N.spawn()
		elif N.has_method("set_enabled"):
			N.set_enabled(true)
	get_node("platforms/hiddenPlatforms/hidden_4").queue_free()

func _on_Checkpoint13_body_enter( body ):
	get_node("island2/move_camera1")._set_active(true)

func _on_move_camera_body_enter( body ):
	if get_node("island3/move_camera").active:
		player.set_speed(player_speed)
		darken_screen = false
		light.set_energy(0)
