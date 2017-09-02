extends Node

func save_file(player):
	var dict = {}
	dict["checkpoint"]	= player.lastCheckpoint
	dict["colors"]		= player.colors_learned
	
	var file = File.new()
	file.open("user://savefile.txt", File.WRITE)
	file.store_line(dict.to_json())
	
	file.close()

func load_saved(player):
	var savefile = File.new()
	if not savefile.file_exists("user://savefile.txt"):
		printerr("Save file doesn't exist")
		return
	
	file.open("user://savefile.txt", File.READ)
	
	var dict = {}
	dict.parse_json(savefile.get_line())
	
	savefile.close()
	
	player.lastCheckpoint = dict["checkpoint"]
	player.colors_learned = dict["colors"]
