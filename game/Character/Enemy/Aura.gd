extends Area2D

export(float) var threshold = 30

var radius
var player
var player_movement
var player_dash

func _ready():
	radius = get_node("CollisionShape2D").get_shape().get_radius() + threshold

	connect("body_enter", self, "on_body_enter")
	connect("body_exit", self, "on_body_exit")

func on_body_enter(body):
	if not body.is_in_group("player"): return

	player = body
	player_movement = body.get_node("Actions/move")
	player_dash = body.get_node("Actions/dash")
	
	player.set_walk_slow(true)

	set_fixed_process(true)

func on_body_exit(body):
	if player != null and player == body:
		player_movement.multiplier = 1
		player_dash.speed_multiplier = 1
		player.set_walk_slow(false)

		player = null
		player_movement = null
		player_dash = null
		

		set_fixed_process(false)

func _fixed_process(delta):
	var distance = (player.get_global_pos() - self.get_global_pos()).length()
	var relative = distance / radius

	if relative < 0.001: relative = 0.001

	player_movement.multiplier = relative
	player_dash.speed_multiplier = sqrt(relative)
