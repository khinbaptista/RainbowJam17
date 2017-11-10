extends Node2D

func _on_hidden_platforms_1_body_enter( body ):
	get_node("island3/move_camera")._set_active(true)
	get_node("platforms/hiddenPlatforms/hidden_4").set_collision_mask_bit(0, 1)
	get_node("platforms/hiddenPlatforms/hidden_4").set_layer_mask_bit(0, 1)
	for N in get_node("platforms/hiddenPlatforms/1").get_children():
		if N.has_method("spawn"):
			N.spawn()
	get_node("platforms/hiddenPlatforms/hidden_1").queue_free()


func _on_hidden_2_body_enter( body ):
	for N in get_node("platforms/hiddenPlatforms/2").get_children():
		if N.has_method("spawn"):
			N.spawn()
	get_node("platforms/hiddenPlatforms/hidden_2").queue_free()


func _on_hidden_3_body_enter( body ):
	for N in get_node("platforms/hiddenPlatforms/3").get_children():
		if N.has_method("spawn"):
			N.spawn()
	get_node("platforms/hiddenPlatforms/hidden_3").queue_free()

func _on_hidden_4_body_enter( body ):
	for N in get_node("platforms/hiddenPlatforms/4").get_children():
		if N.has_method("spawn"):
			N.spawn()
		elif N.has_method("set_enabled"):
			N.set_enabled(true)
	get_node("platforms/hiddenPlatforms/hidden_4").queue_free()

func _on_Checkpoint13_body_enter( body ):
	get_node("island2/move_camera1")._set_active(true)
