extends Node

var filename = "user://savefile.txt"

func save_file(player):
	var dict = {}
	dict["checkpoint_x"]	= player.lastCheckpoint.x
	dict["checkpoint_y"]	= player.lastCheckpoint.y
	dict["colors"]		= player.colors_learned
	
	var file = File.new()
	file.open(filename, File.WRITE)
	file.store_line(dict.to_json())
	
	file.close()

func load_saved(player):
	var savefile = File.new()
	if not savefile.file_exists(filename):
		printerr("Save file doesn't exist")
		return
	
	savefile.open(filename, File.READ)
	
	var dict = {}
	dict.parse_json(savefile.get_line())
	
	savefile.close()
	
	player.lastCheckpoint = Vector2(dict["checkpoint_x"], dict["checkpoint_y"])
	player.colors_learned = int(dict["colors"])

func delete_save():
	var dir = Directory.new()
	dir.remove(filename)
