extends AnimatedSprite

var crystals = []
export(NodePath) var player_path = @"../player"
onready var player = get_node(player_path)

enum colors {
	red = 2,
	orange = 4,
	yellow = 8,
	green = 16,
	blue = 32,
	purple = 64
}

func _ready():
	set_process(true)
	
	crystals.append(get_node("red"))
	crystals.append(get_node("orange"))
	crystals.append(get_node("yellow"))
	crystals.append(get_node("green"))
	crystals.append(get_node("blue"))
	crystals.append(get_node("purple"))
	
	for crystal in crystals:
		crystal.hide()

func _process(delta):
	if player.knows_color(colors.red):
		show_crystal(0)
	if player.knows_color(colors.orange):
		show_crystal(1)
	if player.knows_color(colors.yellow):
		show_crystal(2)
	if player.knows_color(colors.green):
		show_crystal(3)
	if player.knows_color(colors.blue):
		show_crystal(4)
	if player.knows_color(colors.purple):
		show_crystal(5)

func show_crystal(color):
	if crystals[color].is_hidden():
		crystals[color].show()
