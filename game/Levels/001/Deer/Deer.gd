extends Path2D

var awake = false
var running = false

onready var follow = get_node("PathFollow2D")
onready var sprite = get_node("PathFollow2D/Sprite")

func _ready():
	set_process(true)


func _process(delta):
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