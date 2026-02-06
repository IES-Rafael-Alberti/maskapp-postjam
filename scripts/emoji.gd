extends TextureRect

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			Global.envia_reachy(name)
			get_parent().get_parent().get_parent()._on_emoji_selected(self)
			#print(event.position)
			#var rect: Rect2 = $Emojis_panel.get_global_rect()
			#rect.size.x -= _margin.x*2
			#rect.size.y -= _margin.y*2
			#rect.position.x += _margin.x
			#rect.position.y += _margin.y
			#print(rect)
			#var mouse_position = $Emojis_panel.get_global_mouse_position()
			#if rect.has_point(mouse_position):
				#emojis_selection = false
				#show_emojis(false)
				#emojis_selected.emit()


func _on_mouse_entered() -> void:
	scale = Vector2(1.1, 1.1)


func _on_mouse_exited() -> void:
	scale = Vector2(1, 1)
