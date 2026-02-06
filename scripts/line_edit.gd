extends LineEdit

var container_margin = 10.0

func activate():
	editable = true
	grab_focus()

func deactivate():
	editable = false

func is_empty() -> bool:
	return text == ""

func _on_resized() -> void:
	var line_edit = get_viewport().gui_get_focus_owner()
	if line_edit:
		var container = line_edit.get_parent()
		if container.size.x - line_edit.size.x < container_margin:
			line_edit.max_length = line_edit.text.length()
			line_edit.caret_column = line_edit.max_length
