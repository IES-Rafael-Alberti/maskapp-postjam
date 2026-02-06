extends Node2D

@export var text_files: Array[String]

@export var normal_text_scene: PackedScene
@export var masked_text_scene: PackedScene
@export var typed_text_scene: PackedScene

@export var text_container_p1: PackedScene
@export var text_container_p2: PackedScene

@onready var conversations_panel = $ScrollContainer/Conversations
@onready var scroll_container = $ScrollContainer

var container_margin = 10.0 
var current_conversation: Conversation

var players: Array[PackedScene]
var dialogs: PackedStringArray
var current_dialog = 0
var current_player = 0
var current_phase = 0

#var reachy_emojis = ["yes1", "loving1", "laughing1", "surprised2", "downcast1", "helpful2", "laughing2", "enthusiastic2", "cheerful1", "confused1", "enthusiastic1", "welcoming2", "welcoming1"]

func _ready() -> void:
	if FileAccess.file_exists("res://config/reachy.txt"):
		Global.reachy_present = true
		var file_ip = FileAccess.open("res://config/reachy.txt", FileAccess.READ)
		Global.reachy_ip = file_ip.get_as_text().strip_edges()
	Global.http = $HTTPRequest
	Global.init_reachy()
	players = [text_container_p1, text_container_p2]
	Global.conversations_size = text_files.size()
	var file_dialogs = FileAccess.open(text_files[Global.current_text_file], FileAccess.READ)
	var content:String = file_dialogs.get_as_text()
	dialogs = content.split("\n", false)
	next_player(true)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if event.is_action_pressed("next") and not current_phase and not current_conversation.is_meca_text():
		current_conversation.conversation_panel.stop_timer()
		next_action()
	if event.is_action_pressed("next_text") and not current_phase and not current_conversation.is_meca_text():
		current_conversation.next_text()
	scroll_container.set_deferred("scroll_vertical", scroll_container.get_v_scroll_bar().max_value)

func next_action():
	if current_phase:
		next_player()
		current_phase = 0
	else:
		current_conversation.conversation_panel.show_emojis()
		current_phase = 1
		current_conversation.conversation_panel.emojis_selected.connect(next_action)

func next_player(first: bool = false):
	if not first:
		Global.scores[current_player] += current_conversation.score()
		current_player += 1
		current_player %= 2
		current_dialog += 1
		if current_dialog >= dialogs.size():
			await get_tree().create_timer(3).timeout
			get_tree().change_scene_to_file("res://scripts/gameover.tscn")
			return
	Global.disconnect_next_text()
	var conversation = players[current_player].instantiate()
	conversations_panel.add_child(conversation)
	current_conversation = Conversation.new(dialogs[current_dialog], conversation)
