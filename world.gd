class_name World extends Node2D

var gridLayer : TileMapLayer
var overlayLayer : TileMapLayer
var objectsLayer : TileMapLayer
var tilesLayer : TileMapLayer
var start_pos : Vector2
var movement_tile_coords := Array()
var selected_ship : Ship
var selected_ship_movement_tile : Vector2

var camera : Camera2D

func _init() -> void:
	#camera = $Camera

	gridLayer = $Map/Grid
	overlayLayer = $Map/Overlay
	objectsLayer = $Map/Objects
	tilesLayer = $Map/Areas

func _ready():
	
	camera = Camera.new()
	
	camera.zoom = Vector2(1.2, 1.2)
	
	
	gridLayer.right_click.connect(_on_map_right_click)
	
	start_pos = Vector2(1, 1)
	$Alkesh.position = gridLayer.map_to_local(start_pos)
	selected_ship = $Alkesh
	set_movement_overlay()


#todo these 2 functions mean, in ship.gd movement is fucked with interpolation,
# b/c startPos is only passed after state has been changed.
#could redo states.... or could just pass a startPos from here, but that seems inelegant, 
#to not have a single movement function do everything movement related
#done. one line. "selected_ship.startPos = selected_ship.position"
func _physics_process(_delta):
	if selected_ship.state == selected_ship.Movement_State.Moving:
		selected_ship.move_to(tilesLayer.map_to_local(selected_ship_movement_tile), _delta)

#location_gl (global coords) ---> Vector2i type
func _on_map_right_click(location_gl):
	if movement_tile_coords.has(location_gl):
		if selected_ship.state == selected_ship.Movement_State.Idle:
			change_overlay_visibility()
			selected_ship_movement_tile = location_gl as Vector2
			selected_ship.startPos = selected_ship.position
			selected_ship.change_state()


#create movement tile overlay
func get_movement_tiles() -> void:
	movement_tile_coords = []
	var neighbours = gridLayer.get_surrounding_cells(gridLayer.local_to_map(selected_ship.position))
	for tileCoords in neighbours:
		if tileCoords.x >= 0 and tileCoords.y >= 0:
			if not objectsLayer.get_used_cells().has(tileCoords):
				movement_tile_coords.append(tileCoords)

#display movement overlay, idk if tying movement to this is good idea
func set_movement_overlay() -> void:
	clear_overlay()
	get_movement_tiles()
	for tileCoords in movement_tile_coords:
		var overlay = Vector2i(0, 0)
		overlayLayer.set_cell(tileCoords, 0, overlay, 0)

#might not need this, should delete if in the end i dont use it elsewhere
func clear_overlay() -> void:
	overlayLayer.clear()

#valid movement tiles visibility
func change_overlay_visibility() -> void:
	if overlayLayer.enabled:
		overlayLayer.enabled = false
	else:
		overlayLayer.enabled = true

#done moving, alkesh specific, TODO: should (probably) DEFINITELY fix that
func _on_alkesh_done_moving():
	set_movement_overlay()
	change_overlay_visibility()
