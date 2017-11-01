tool

extends Area2D

export var can_move = false
export(int, "red", "orange", "yellow", "green", "blue", "purple") var type = 0

onready var player

var active = false

func _ready():
	if can_move:
		get_node("AnimationPlayer").play_backwards("wake up")
		get_node("AnimationPlayer").seek(0)
	elif not get_tree().is_editor_hint():
		get_node("player_trigger").queue_free()
	
	_hide()
	if type == 0:
		get_node("sprite/red").show()
	elif type == 1:
		get_node("sprite/orange").show()
	elif type == 2:
		get_node("sprite/yellow").show()
	elif type == 3:
		get_node("sprite/green").show()
	elif type == 4:
		get_node("sprite/blue").show()
	elif type == 5:
		get_node("sprite/purple").show()
	#---------------------- EDITOR ONLY ----------------------
	if get_tree().is_editor_hint():
		set_process(true)
		if not can_move:
			get_node("player_trigger").hide()
	#---------------------------------------------------------
	else:
		player = get_node(Globals.get("player_path"))

func _process(delta):
	#---------------------- EDITOR ONLY ----------------------
	if get_tree().is_editor_hint():
		_hide()
		if type == 0:
			get_node("sprite/red").show()
		elif type == 1:
			get_node("sprite/orange").show()
		elif type == 2:
			get_node("sprite/yellow").show()
		elif type == 3:
			get_node("sprite/green").show()
		elif type == 4:
			get_node("sprite/blue").show()
		elif type == 5:
			get_node("sprite/purple").show()
	#---------------------------------------------------------

func _hide():
	get_node("sprite/red").hide()
	get_node("sprite/orange").hide()
	get_node("sprite/yellow").hide()
	get_node("sprite/green").hide()
	get_node("sprite/blue").hide()
	get_node("sprite/purple").hide()


func _on_player_trigger_body_enter( body ):
	if body == player and not active:
		active = true
		get_node("AnimationPlayer").play("wake up")
