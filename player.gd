class_name Player extends Node2D

signal turn_end



func end_turn() -> void:
	turn_end.emit()
	#TODO reset ship thrust

func add_ship_control(ship:Ship) -> void:
	add_child(ship)
	ship.add_to_group("ships")
	
func remove_ship_control(tbrem_ship:Ship):
	tbrem_ship.remove_from_group("ships")
	remove_child(tbrem_ship)
