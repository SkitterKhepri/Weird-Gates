class_name TurnController extends Node2D


func add_player(player:Player) -> void:
	add_child(player)
	player.add_to_group("players")
	player.turn_end.connect(_on_turn_end)
	
func remove_player(tbrem_player:Player) -> void:
	tbrem_player.remove_from_group("palyers")
	remove_child(tbrem_player)

#not tested
func remove_all_players() -> void:
	get_tree().call_group("players", "remove_player")

func _on_turn_end():
	print("fuck yeah, turn ended")


func _init():
	var player1 = Player.new()
	add_player(player1)
	var player2 = Player.new()
	add_player(player2)
