tool
extends "color_alignment.gd"

func set_color(color):
	.set_color(color)

	yield(self, "enter_tree")
	get_node("mask").set_item_mask(mask)

func spawn():
	get_node("AnimationPlayer").play("spawn")
	yield(get_node("AnimationPlayer"), "finished")
	queue_free()
