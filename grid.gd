class_name Grid extends TileMapLayer

signal right_click(location)
signal left_click(location)


func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.is_released():
			var click_coords = make_input_local(event).position
			var cell_clicked = local_to_map(to_local(click_coords))
			right_click.emit(cell_clicked)
			#cell_clicked a térkép egy hex koordinátája, Vector2
			get_viewport().set_input_as_handled()
		elif event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			var click_coords = make_input_local(event).position
			var cell_clicked = local_to_map(to_local(click_coords))
			left_click.emit(cell_clicked)
			get_viewport().set_input_as_handled()
