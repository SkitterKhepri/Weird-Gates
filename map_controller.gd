class_name MapController extends Node2D

var map = preload("res://map.tscn")

func _ready() -> void:
	add_child(map.instantiate())
	get_node("Map/Grid")
