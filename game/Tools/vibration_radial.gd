extends Node2D

export(float, 0, 1000, 1) var vibration_distance = 300

#export(NodePath) var player_path = @""
onready var player = get_node(Globals.get("player_path"))

func _ready():
	set_process(true)

func _process(delta):
	proximity_vibration()

# This function makes the controller vibrate more the closer you are to the crystal
func proximity_vibration():
	var dist = get_global_pos().distance_to(player.get_global_pos())
	var attenuation = 1-dist/vibration_distance

	if attenuation < 0:
		attenuation = 0
	else:
		Input.stop_joy_vibration(0)
		Input.start_joy_vibration(0, 0.4*attenuation, 0.6*attenuation, 0.1)
