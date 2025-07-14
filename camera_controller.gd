class_name CameraController extends Node2D

var packedCamera = preload("res://camera.tscn")
var camera = packedCamera.instantiate()

func _ready() -> void:
	add_child(camera)

func set_zoom(vector:Vector2) -> void:
	camera.zoom = vector
