tool
extends StaticBody2D

export(int, "1", "2", "3", "4") var type = 1

var player

func _ready():
	get_node("sprite/coin1").hide()
	get_node("cracks/coin1").hide()
	get_node("shadows/coin1").hide()
	get_node("sprite/coin2").hide()
	get_node("cracks/coin2").hide()
	get_node("shadows/coin2").hide()
	get_node("sprite/coin3").hide()
	get_node("cracks/coin3").hide()
	get_node("shadows/coin3").hide()
	get_node("sprite/coin4").hide()
	get_node("cracks/coin4").hide()
	get_node("shadows/coin4").hide()
	#---------------------- EDITOR ONLY ----------------------
	if get_tree().is_editor_hint():
		set_process(true)
	#---------------------------------------------------------
	else:
		player = get_node(Globals.get("player_path"))
		if type == 0:
			get_node("sprite/coin1").show()
			get_node("cracks/coin1").show()
			get_node("shadows/coin1").show()
		elif type == 1:
			get_node("sprite/coin2").show()
			get_node("cracks/coin2").show()
			get_node("shadows/coin2").show()
		elif type == 2:
			get_node("sprite/coin3").show()
			get_node("cracks/coin3").show()
			get_node("shadows/coin3").show()
		elif type == 3:
			get_node("sprite/coin4").show()
			get_node("cracks/coin4").show()
			get_node("shadows/coin4").show()

func _process(delta):
	#---------------------- EDITOR ONLY ----------------------
	if get_tree().is_editor_hint():
		get_node("sprite/coin1").hide()
		get_node("cracks/coin1").hide()
		get_node("shadows/coin1").hide()
		get_node("sprite/coin2").hide()
		get_node("cracks/coin2").hide()
		get_node("shadows/coin2").hide()
		get_node("sprite/coin3").hide()
		get_node("cracks/coin3").hide()
		get_node("shadows/coin3").hide()
		get_node("sprite/coin4").hide()
		get_node("cracks/coin4").hide()
		get_node("shadows/coin4").hide()
		if type == 0:
			get_node("sprite/coin1").show()
			get_node("cracks/coin1").show()
			get_node("shadows/coin1").show()
		elif type == 1:
			get_node("sprite/coin2").show()
			get_node("cracks/coin2").show()
			get_node("shadows/coin2").show()
		elif type == 2:
			get_node("sprite/coin3").show()
			get_node("cracks/coin3").show()
			get_node("shadows/coin3").show()
		elif type == 3:
			get_node("sprite/coin4").show()
			get_node("cracks/coin4").show()
			get_node("shadows/coin4").show()
	#---------------------------------------------------------

func interaction():
	player.add_coins(1)
	get_node("sprite/Particles2D").set_emitting(false)
	get_node("shadows").hide()
	get_node("sprite").hide()
	get_node("z_depth").queue_free()
	get_node("vibration_radial").queue_free()
	get_node("CollisionShape2D").queue_free()
