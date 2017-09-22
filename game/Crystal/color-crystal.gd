extends StaticBody2D

export(int, FLAGS, "None", "Red", "Orange", "Yellow", "Green", "Blue", "Purple") var crystal_color = 1
export(float, 0, 1000, 1) var vibration_distance = 300

export(NodePath) var player_path = @""
onready var player = get_node(player_path)
onready var sprite = get_node("sprite")
onready var press_e = get_node("press_e")

var layer = "behind"

func _ready():
	set_process(true)
	if player.knows_color(crystal_color):
		queue_free()	# the crystal is useless

func _process(delta):
	process_layer()
	proximity_vibration()

func interaction():
	player.learn_color(crystal_color)
	queue_free()

func process_layer():
	if layer == "front" and player.get_global_pos().y > get_global_pos().y:
		sprite.set_z(1)
		press_e.set_z(1)
		layer = "behind"
	if layer == "behind" and player.get_global_pos().y < get_global_pos().y:
		sprite.set_z(3)
		press_e.set_z(3)
		layer = "front"

# This function makes the controller vibrate more the closer you are to the crystal
func proximity_vibration():
	var dist = get_global_pos().distance_to(player.get_global_pos())
	var attenuation = 1-dist/vibration_distance
	
	if attenuation < 0:
		attenuation = 0
	else:
		Input.stop_joy_vibration(0)
		Input.start_joy_vibration(0, 0.4*attenuation, 0.6*attenuation, 0.1)
