extends Area2D

export(NodePath) var observer
export(NodePath) var target_path

var receiver
var target
var active = true
var notify = false

func _ready():
	if observer:
		receiver = get_node(observer)
	if target_path:
		target = get_node(target_path)
		print(target)
	set_process(true)
	
func _process(delta):
	if observer and notify:
		if receiver.has_method("activate"):
			receiver.activate()
			notify = false