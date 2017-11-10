tool

extends "res://Beams/color_alignment.gd"

export var can_move = false
export var affected_by_beam = false
export(int, "red", "orange", "yellow", "green", "blue", "purple") var type = 0

onready var player

var active = false
var sprite

func _ready():
	if can_move:
		get_node("AnimationPlayer").play_backwards("wake up")
		get_node("AnimationPlayer").seek(0)
	elif not get_tree().is_editor_hint():
		get_node("player_trigger").queue_free()
		
	if affected_by_beam:
		set_collision_mask_bit(0, false)
		set_layer_mask_bit(0, false)
	
	_hide()
	if type == 0:
		sprite = get_node("sprite/red")
	elif type == 1:
		sprite = get_node("sprite/orange")
	elif type == 2:
		sprite = get_node("sprite/yellow")
	elif type == 3:
		sprite = get_node("sprite/green")
	elif type == 4:
		sprite = get_node("sprite/blue")
	elif type == 5:
		sprite = get_node("sprite/purple")
	if not affected_by_beam:
		sprite.show()
	sprite.set_light_mask(color_mask)
	#---------------------- EDITOR ONLY ----------------------
	if get_tree().is_editor_hint():
		set_process(true)
		if not can_move:
			get_node("player_trigger").hide()
		else:
			get_node("player_trigger").show()
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
	
func spawn():
	if sprite:
		sprite.show()

	set_collision_mask_bit(0, true)
	set_layer_mask_bit(0, true)

func _hide():
	get_node("sprite/red").hide()
	get_node("sprite/orange").hide()
	get_node("sprite/yellow").hide()
	get_node("sprite/green").hide()
	get_node("sprite/blue").hide()
	get_node("sprite/purple").hide()
	
func _on_platform_area_enter( area ):
	if color_alignment != 0:	# has a color
		if area.get_name() == "beams_coming":
			sprite.show()

func _on_platform_area_exit( area ):
	if color_alignment != 0:	# has a color
		if area.get_name() == "beams_coming":
			sprite.hide()


func _on_player_trigger_body_enter( body ):
	if body == player and not active:
		active = true
		get_node("AnimationPlayer").play("wake up")
