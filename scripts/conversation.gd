class_name Conversation
extends Node

@export var conversation_panel: ConversationPanel

var normal_text_scene: PackedScene = load("res://scenes/line_text.tscn")
var masked_text_scene: PackedScene = load("res://scenes/line_edit.tscn")
var meca_text_scene: PackedScene = load("res://scenes/meca_edit.tscn")

var masked_fields: Array[LineEdit]
var current_text: int = 0

enum states {NORMAL, MECA, MASKED}

func _init(dialog, _conversation_panel):
	Global.next_text.connect(next_text)
	conversation_panel = _conversation_panel
	load_file(dialog, _conversation_panel.get_panel())
	masked_fields[current_text].activate()

func next_text():
	if current_text < masked_fields.size():
		var was_meca = masked_fields[current_text] is MecaEdit
		var was_filled = not masked_fields[current_text].is_empty()
		masked_fields[current_text].deactivate()
		current_text += 1
		if current_text >= masked_fields.size():
			if was_filled:
				conversation_panel.capture_last_field(was_meca)
			conversation_panel.stop_timer()
			conversation_panel.next_action()
		else:
			if was_filled:
				conversation_panel.restart_timer(was_meca)
			else:
				conversation_panel.restart_timer_no_score()
			masked_fields[current_text].activate()

func is_meca_text():
	return masked_fields[current_text] is MecaEdit

func load_file(dialog: String, text_container):
	var current_state = states.NORMAL
	var temporal_text: String = ""
	for character in dialog:
		match character:
			"_":
				if current_state == states.NORMAL:
					current_state = states.MASKED
					add_normal_text(temporal_text, text_container)
					temporal_text = "_"
				else:
					temporal_text += "_"
			"%":
				if current_state == states.MECA:
					current_state = states.NORMAL
					add_meca_text(temporal_text, text_container)
					temporal_text = ""
				elif current_state == states.NORMAL:
					current_state = states.MECA
					add_normal_text(temporal_text, text_container)
					temporal_text = ""
				else:
					current_state = states.MECA
					add_masked_text(temporal_text, text_container)
					temporal_text = ""
			_:
				if current_state == states.MASKED:
					current_state = states.NORMAL
					add_masked_text(temporal_text, text_container)
					temporal_text = character
				else:
					temporal_text += character

	if temporal_text:
		if current_state == states.NORMAL:
			add_normal_text(temporal_text, text_container)
		else:
			add_masked_text(temporal_text, text_container)

func score() -> int:
	var emoji_bonus = int(conversation_panel.libre_score * conversation_panel.emoji_mult)
	return conversation_panel.meca_score + emoji_bonus
	
func add_normal_text(text: String, text_container):
	var instance = normal_text_scene.instantiate()
	instance.text = text
	text_container.add_child(instance)

func add_masked_text(text: String, text_container):
	var instance = masked_text_scene.instantiate()
	instance.placeholder_text = text
	masked_fields.append(instance)
	text_container.add_child(instance)

func add_meca_text(text: String, text_container):
	var instance = meca_text_scene.instantiate()
	instance.set_meca_text(text)
	masked_fields.append(instance)
	text_container.add_child(instance)
