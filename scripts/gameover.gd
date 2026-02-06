extends Node2D

func _ready() -> void:
	$Player1.text = "%.00f" % Global.scores[0]
	$Player2.text = "%.00f" % Global.scores[1]
	if Global.current_text_file >= Global.conversations_size-1:
		$Button.text = "Salir"

func _on_button_pressed() -> void:
	if Global.current_text_file >= Global.conversations_size-1:
		get_tree().quit()
	else:
		Global.current_text_file += 1
		get_tree().change_scene_to_file("res://scenes/game.tscn")
