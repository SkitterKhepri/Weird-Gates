class_name Ship extends Node2D

signal done_moving

var dictionaries = Dictionaries.new()

#Ship Properties
#Misc
var ship_name : String
var faction : Player = null

#Stats
var hull : int
var max_shield : int
var current_shields : Array
var inertial_dampeners : int
var max_thrust : int
var curr_thrust : int
var remaining_thrust : int
var facing : String
var inertia = {}

#weapons?
#var weapon_mounts : Array

#Movement
var speed : float = 1
var currentVelocity := Vector2()
var startPos : Vector2
var t : float = 0.0
var state : Movement_State
enum Movement_State{
	Idle,
	Moving
}

func _ready():
	set_facing("south_right")
	curr_thrust = max_thrust

#todo: unsafe, direction can be w/e, good enough for now
func set_facing(direction:String):
	if dictionaries.facings.has(direction):
		match direction:
			"north":
				facing = "north"
				global_rotation_degrees = dictionaries.FACING_DIC.north
			"north_right":
				facing = "north_right"
				global_rotation_degrees = dictionaries.FACING_DIC.north_right
			"south_right":
				facing = "south_right"
				global_rotation_degrees = dictionaries.FACING_DIC.south_right
			"south":
				facing = "south"
				global_rotation_degrees = dictionaries.FACING_DIC.south
			"south_left":
				facing = "south_left"
				global_rotation_degrees = dictionaries.FACING_DIC.south_left
			"north_left":
				facing = "north_left"
				global_rotation_degrees = dictionaries.FACING_DIC.north_left
	else:
		push_error("Invalid facing set here")
		#todo getting error, dont know where from (prob _ready), also ship too big(done, scale), and camera...



#possible todo: ezt egész szart interpolationnel sokkal(?) egyszerűbben megcsinálni
#fuck yes! - now just need to do something about speed, so different sized ships will have different speeds
#also done, just needed "* speed"
func move_to(target, delta) -> void:
	t += delta * speed
	position = startPos.lerp(target, t)
	#TODO this thing. need to figure out, how to modify the target with the inertia, to get what i want
	#??? fuck does that mean?? "what i want"???
	#got it, so depending on inertia, figure out how to move target where it actually should be. still, wtf?
	var target_velocity : Vector2 = (target - position).normalized()
	currentVelocity += target_velocity
	rotation = currentVelocity.angle() + deg_to_rad(90)
	if is_equal_approx(t, 1.0):
		change_state()
		currentVelocity = Vector2()
		position = target
		inertia = inertia
		startPos = Vector2()
		curr_thrust -= 1
		done_moving.emit()
		t = 0.0


func change_state() -> void:
	if state == Movement_State.Moving:
		state = Movement_State.Idle
	else:
		state = Movement_State.Moving

func take_dmg() -> void:
	pass
