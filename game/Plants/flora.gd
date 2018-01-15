tool
extends StaticBody2D

export(String, "Tree", "Bush", "Cactus") var type = "Tree"
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

	if type == "Tree":
		get_node("Plants/Tree").show()
		get_node("Shadows/Tree_shadow").show()
		get_node("Tree_collisionShape").set_trigger(false)
		get_node("Tree_particles").set_emitting(true)
		get_node("Tree_particles").show()
		sprite = get_node("Plants/Tree")
		shadowSprite = get_node("Shadows/Tree_shadow")

		get_node("Plants/Bush").hide()
		get_node("Shadows/Bush_shadow").hide()
		get_node("Plants/cactus").hide()
		get_node("Bush_collisionShape").set_trigger(true)

	elif type == "Bush":
		get_node("Plants/Bush").show()
		get_node("Shadows/Bush_shadow").show()
		get_node("Bush_collisionShape").set_trigger(false)
		sprite = get_node("Plants/Bush")
		shadowSprite = get_node("Shadows/Bush_shadow")

		get_node("Plants/Tree").hide()
		get_node("Shadows/Tree_shadow").hide()
		get_node("Tree_collisionShape").set_trigger(true)
		get_node("Plants/cactus").hide()
		get_node("Tree_particles").set_emitting(false)
		get_node("Tree_particles").hide()
		
	elif type == "Cactus":
		get_node("Plants/cactus").show()
		sprite = get_node("Plants/cactus")
		shadowSprite = get_node("Shadows/Bush_shadow")

		get_node("Plants/Tree").hide()
		get_node("Shadows/Bush_shadow").hide()
		get_node("Shadows/Tree_shadow").hide()
		get_node("Tree_collisionShape").set_trigger(true)
		get_node("Tree_particles").set_emitting(false)
		get_node("Bush_collisionShape").set_trigger(false)
		get_node("Tree_particles").hide()

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
		if type == "Tree":
			get_node("Plants/Tree").show()
			get_node("Shadows/Tree_shadow").show()
			get_node("Tree_particles").set_emitting(true)
			shadowSprite = get_node("Shadows/Tree_shadow")
			sprite = get_node("Plants/Tree")

			get_node("Plants/Bush").hide()
			get_node("Plants/cactus").hide()
			get_node("Shadows/Bush_shadow").hide()

		elif type == "Bush":
			get_node("Plants/Bush").show()
			get_node("Shadows/Bush_shadow").show()
			shadowSprite = get_node("Shadows/Bush_shadow")
			sprite = get_node("Plants/Bush")

			get_node("Plants/Tree").hide()
			get_node("Plants/cactus").hide()
			get_node("Shadows/Tree_shadow").hide()
			get_node("Tree_particles").set_emitting(false)
			
		elif type == "Cactus":
			get_node("Plants/cactus").show()
			shadowSprite = get_node("Shadows/Bush_shadow")
			sprite = get_node("Plants/cactus")

			get_node("Plants/Tree").hide()
			get_node("Shadows/Bush_shadow").hide()
			get_node("Shadows/Tree_shadow").hide()
			get_node("Tree_particles").set_emitting(false)

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
