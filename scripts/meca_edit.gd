class_name MecaEdit
extends LineEdit

@export var meca_text: String
var next_text: String
var current_char_index: int

var container_margin = 10.0

func is_empty():
	return meca_text != $LineEdit.text

func set_meca_text(_text: String):
	meca_text = _text
	placeholder_text = "_".repeat(meca_text.length())
	current_char_index = 1
	next_text = meca_text.substr(0, current_char_index)

func activate():
	$LineEdit.editable = true
	$LineEdit.grab_focus()
	
func deactivate():
	$LineEdit.editable = false

func _on_text_changed(_new_text: String) -> void:
	if _new_text != next_text:
		$LineEdit.text = $LineEdit.text.substr(0, current_char_index-1)
		$LineEdit.caret_column = current_char_index
	else:
		current_char_index += 1
		if current_char_index > meca_text.length():
			deactivate()
			Global.next_text.emit()
		else:
			next_text = meca_text.substr(0, current_char_index)

func _on_editing_toggled(_toggled_on: bool) -> void:
	if _toggled_on:
		text = meca_text

#
#func _on_resized() -> void:
	#var line_edit = get_viewport().gui_get_focus_owner()
	#if line_edit:
		#var container = line_edit.get_parent()
		#if container.size.x - line_edit.size.x < container_margin:
			#line_edit.max_length = line_edit.text.length()
			#line_edit.caret_column = line_edit.max_length


func _on_line_edit_resized() -> void:
	pass # Replace with function body.
