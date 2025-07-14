extends Control

var options
var label

func _ready():
	options = $Container
	options.set_size(get_viewport().size)
	label = $Container/Label
	var new_sb = StyleBoxFlat.new()
	new_sb.bg_color = Color.DIM_GRAY
	label.add_theme_stylebox_override("normal", new_sb)
	label.position += Vector2(0, 30)


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
