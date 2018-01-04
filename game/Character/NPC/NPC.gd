extends KinematicBody2D

var lines = []
var currentLine = 0
var help_icon

func _ready():
	lines = get_node("text").get_children()
	help_icon = get_node("press_space")
	hide_all()

func hide_all():
	for line in lines:
		line.hide()
	
func interaction():
	currentLine += 1
	currentLine = currentLine % (lines.size() + 1)
	show_line(currentLine)
	
func show_line(lineid):
	if lineid == 0:
		hide_all()
		return
	
	help_icon.hide()
	
	var i = 0
	for line in lines:
		i += 1
		if i == lineid:
			line.show()
		else:
			line.hide()