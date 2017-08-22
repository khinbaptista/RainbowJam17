extends CanvasLayer

export(float) var speed = 50.0
export(float) var limit = 300.0

func _ready():
	set_offset(Vector2(limit, 0))
	set_process(true)

func _process(delta):
	var offset = get_offset()
	offset.x -= speed
	
	if offset.x <= -limit:
		offset.x = limit
	
	set_offset(offset)
