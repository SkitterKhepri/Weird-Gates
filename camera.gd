class_name Camera extends Camera2D

@export var camera : Camera

#seems to work, dunno been a while

var target_zoom : float = 1.0
const MIN_ZOOM : float = 0.1
const MAX_ZOOM : float = 1.5
const ZOOM_INCREMENT : float = 0.1
const ZOOM_RATE : float = 8.0


func _physics_process(delta : float):
	zoom = lerp(zoom, target_zoom * Vector2.ONE, ZOOM_RATE * delta)
	set_physics_process(not is_equal_approx(zoom.x, target_zoom))


func _input(event : InputEvent) -> void:
	if event is InputEventMouseMotion:
			if event.button_mask == MOUSE_BUTTON_MASK_LEFT:
					position -=event.relative * zoom
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_out()
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			#print(zoom)
			zoom_in()

func zoom_out() -> void:
	target_zoom = max(target_zoom - ZOOM_INCREMENT, MIN_ZOOM)
	set_physics_process(true)

func zoom_in() -> void:
	target_zoom = min(target_zoom + ZOOM_INCREMENT, MAX_ZOOM)
	set_physics_process(true)
