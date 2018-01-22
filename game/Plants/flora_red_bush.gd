tool
extends StaticBody2D

export var flip = false
export(Color) var modulate = Color("ffffff")
export var reachable = true

var layer = "behind"
var sprite = Node
var shadowSprite = Node

onready var player = get_node(Globals.get("player_path"))
onready var particles = get_node("Tree_particles")

func _ready():
	if reachable:
		set_process(true)
		
	get_node("Plants/Bush").show()
	get_node("Shadows/Bush_shadow").show()
	get_node("Bush_collisionShape").set_trigger(false)
	sprite = get_node("Plants/Bush")
	shadowSprite = get_node("Shadows/Bush_shadow")

	if flip:
		shadowSprite.set_flip_h(true)
		sprite.set_flip_h(true)
	else:
		shadowSprite.set_flip_h(false)
		sprite.set_flip_h(false)

	sprite.set_modulate(modulate)
	shadowSprite.set_modulate(modulate)

func _process(delta):
	#---------------------- EDITOR ONLY ----------------------
	if get_tree().is_editor_hint():
		get_node("Plants/Bush").show()
		get_node("Shadows/Bush_shadow").show()
		shadowSprite = get_node("Shadows/Bush_shadow")
		sprite = get_node("Plants/Bush")

		if flip:
			shadowSprite.set_flip_h(true)
			sprite.set_flip_h(true)
		else:
			shadowSprite.set_flip_h(false)
			sprite.set_flip_h(false)

		sprite.set_modulate(modulate)
		shadowSprite.set_modulate(modulate)
	#---------------------------------------------------------
	else:
		process_layer()

func process_layer():
	if layer == "front" and player.get_global_pos().y > get_global_pos().y:
		sprite.set_z(1)
		particles.set_z(1)
		layer = "behind"
	if layer == "behind" and player.get_global_pos().y < get_global_pos().y:
		sprite.set_z(3)
		particles.set_z(3)
		layer = "front"
