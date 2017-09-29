tool
extends Path2D

export(String, "Deer", "Birds") var type = "Deer"

var awake = false
var running = false

onready var player = get_node("/root/world/player")
onready var follow = get_node("PathFollow2D")
onready var sprite = get_node("PathFollow2D/Deer")

func _ready():
	set_process(true)
	
	if type == "Deer":
		sprite = get_node("PathFollow2D/Deer")
		sprite.show()
		sprite.set_z(0)
		get_node("PathFollow2D/Birds").hide()
		
	elif type == "Birds":
		sprite = get_node("PathFollow2D/Birds")
		sprite.show()
		sprite.set_z(10)
		get_node("PathFollow2D/Deer").hide()


func _process(delta):
	#---------------------- EDITOR ONLY ----------------------
	if get_tree().is_editor_hint():
		if type == "Deer":
			sprite = get_node("PathFollow2D/Deer")
			sprite.show()
			sprite.set_z(0)
			get_node("PathFollow2D/Birds").hide()
			
		elif type == "Birds":
			sprite = get_node("PathFollow2D/Birds")
			sprite.show()
			sprite.set_z(10)
			get_node("PathFollow2D/Deer").hide()
			get_node("PathFollow2D").hide()
	#---------------------------------------------------------
	
	if type == "Deer":
		if awake and !running:
			if sprite.get_frame() == sprite.get_sprite_frames().get_frame_count("wake up")-1:
				sprite.play("run")
				running = true
		if running:
			follow.set_offset(follow.get_offset()+get_process_delta_time()*300)
			if follow.get_offset() >= 281:
				get_parent().queue_free()

func _on_Deer_body_enter( body ):
	if(!awake):
		if body.get_name() == "player":
			sprite.play("wake up")
			awake = true