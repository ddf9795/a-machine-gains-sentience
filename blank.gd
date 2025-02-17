extends Node2D

var frame = 0

func _process(delta):
	frame += delta
	if frame >= 2:
		get_tree().change_scene("res://Scene.tscn")
