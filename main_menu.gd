extends Control

var main_menu

func _ready():
	main_menu = $MainMenu
	main_menu.set_size(get_viewport().size)


func _on_play_pressed():
	#var map_controller = MapController.new()
	#get_parent().add_child(map_controller)
	get_tree().change_scene_to_file("res://main_controller.tscn")


func _on_options_pressed():
	get_tree().change_scene_to_file("res://options.tscn")


func _on_quit_pressed():
	get_tree().quit()
