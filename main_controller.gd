class_name MainController extends Node2D

var gridLayer : TileMapLayer
var overlayLayer : TileMapLayer
var objectsLayer : TileMapLayer
var areasLayer : TileMapLayer
var start_pos : Vector2
var movement_tile_coords := Array()
var selected_ship : Ship
var moving_ship_movement_tile : Vector2
var moving_ship : Ship

#Controllers
var map_controller : MapController
var camera_controller : CameraController
var turn_controller : TurnController

#Temporary ship-spawn stuff
var pre_alkesh = preload("res://alkesh.tscn")
var pre_test_alkesh = preload("res://test_alkesh.tscn")
var loaded_ship


func _init() -> void:
	map_controller = MapController.new()
	camera_controller = CameraController.new()
	turn_controller = TurnController.new()
	map_controller.name = "MapController"
	camera_controller.name = "CameraController"
	turn_controller.name = "TurnController"
	add_child(map_controller)
	add_child(camera_controller)
	add_child(turn_controller)
	

func _ready() -> void:
	camera_controller.set_zoom(Vector2(1.2, 1.2))
	
	gridLayer = get_node("MapController/Map/Grid")
	overlayLayer = get_node("MapController/Map/Overlay")
	objectsLayer = get_node("MapController/Map/Objects")
	areasLayer = get_node("MapController/Map/Areas")
	#todo fix movement, overlay doesnt get re-done after movement ends, and its visibility is somehow fucked
	#_on_alkesh_done_moving is the issue, its never called
	#To fix that properly, first i should implement selecting ships
	#done and done
	#todo fix camera position, should be somehow tied to the map maybe? next line works, but not what i want
	#done - moved camera in camera scene
	#camera_controller.camera.position = gridLayer.map_to_local(Vector2(8, 8))
	gridLayer.right_click.connect(_on_map_right_click)
	gridLayer.left_click.connect(_on_map_left_click)
	
	#todo fix from here - (ships are children of MainController)
	loaded_ship = pre_alkesh.instantiate()
	start_pos = Vector2(1, 1)
	spawn_ship(loaded_ship, start_pos)
	loaded_ship = pre_test_alkesh.instantiate()
	start_pos = Vector2(4, 4)
	spawn_ship(loaded_ship, start_pos)
	selected_ship = loaded_ship
	set_movement_overlay()


#todo these 2 functions mean, in ship.gd movement is fucked with interpolation,
# b/c startPos is only passed after state has been changed.
#could redo states.... or could just pass a startPos from here, but that seems inelegant, 
#to not have a single movement function do everything movement related
#done. one line. "selected_ship.startPos = selected_ship.position"
func _physics_process(_delta):
	if (moving_ship != null) and (moving_ship.state == moving_ship.Movement_State.Moving):
		moving_ship.move_to(gridLayer.map_to_local(moving_ship_movement_tile), _delta)

#location_gl (global coords) ---> Vector2i type
func _on_map_right_click(location_gl):
	if selected_ship != null:
		if movement_tile_coords.has(location_gl):
			if selected_ship.state == selected_ship.Movement_State.Idle:
				moving_ship = selected_ship
				change_overlay_visibility()
				moving_ship_movement_tile = location_gl as Vector2
				moving_ship.startPos = moving_ship.position
				moving_ship.change_state()


func _on_map_left_click(location_gl):
	var ships = get_tree().get_nodes_in_group("ships")
	var correct_ship = null
	for ship in ships:
		if gridLayer.local_to_map(ship.position) == location_gl:
			correct_ship = ship
			continue
			selected_ship = ship
			if moving_ship == null:
				set_movement_overlay()
		else:
			clear_overlay()
			selected_ship = null
	if correct_ship != null:
		selected_ship = correct_ship
		if moving_ship == null:
			set_movement_overlay()
	else:
		clear_overlay()
		selected_ship = null

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
	if selected_ship != null:
		get_movement_tiles()
		for tileCoords in movement_tile_coords:
			var overlay = Vector2i(0, 0)
			overlayLayer.set_cell(tileCoords, 0, overlay, 0)


func clear_overlay() -> void:
	overlayLayer.clear()

#valid movement tiles visibility
func change_overlay_visibility() -> void:
	if overlayLayer.enabled:
		overlayLayer.enabled = false
	else:
		overlayLayer.enabled = true

#done moving, alkesh specific, todo: should (probably) DEFINITELY fix that - fixed
func _on_ship_done_moving():
	moving_ship = null
	set_movement_overlay()
	change_overlay_visibility()

func spawn_ship(ship, location:Vector2, faction:Player = null) -> void:
	add_child(ship)
	ship.position = gridLayer.map_to_local(location)
	
	ship.add_to_group("ships")
	
	ship.done_moving.connect(_on_ship_done_moving)
	if faction != null:
		ship.faction = faction
