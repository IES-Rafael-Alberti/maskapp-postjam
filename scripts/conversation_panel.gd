class_name ConversationPanel
extends TextureRect

signal emojis_selected

@onready var emojis_panel = $Emojis_panel
@onready var emoji_selected_ui = $Emoji_selected
@onready var emoji_selected_trans = $ColorRect2
@onready var typing_timer = $Timer
@onready var typing_timer_lbl = $TimerLbl
@onready var panel_container = $Panel/TextContainer

var emojis_selection: bool = false
var timeout: bool = true
var time_left: float = 0
var emoji_mult: float = 1.0
var meca_score: int = 0
var libre_score: float = 0.0
var emoji_scores = {
			"yes1": 1.5,
			"loving1": 2.0,
			"cheerful1": 1.6,
			"laughing1": 2.0,
			"downcast1": -1.5,
			"enthusiastic1": 1.2,
			"helpful2": 1.0,
			"welcoming2": 1.0,
			"surprised2": 1.3,
			"laughing2": 0.9,
			"confused1": 2.1,
			"no1": -2.0
		}

func _ready() -> void:
	call_deferred("_update_scroll")

func _update_scroll():
	get_tree().current_scene.update_scroll()

func _process(_delta: float) -> void:
	if timeout and typing_timer:
		typing_timer_lbl.text = "%.2f" % typing_timer.time_left

func _on_emoji_selected(_emoji):
	if _emoji.name in emoji_scores:
		emoji_mult = emoji_scores[_emoji.name]
	emojis_selection = false
	show_emojis(false)
	emoji_selected_ui.texture = _emoji.texture
	emoji_selected_ui.activate()
	emoji_selected_trans .visible = true
	get_tree().create_timer(1.5).timeout.connect(_on_highlight_end)



func _on_highlight_end():
	emoji_selected_trans.visible = false
	call_deferred("emojis_selected_emit")

func emojis_selected_emit():
	emojis_selected.emit()

func get_panel():
	return $Panel/TextContainer
	
func show_emojis(_visible:bool = true):
	emojis_panel.visible = _visible
	emojis_selection = _visible

func stop_timer():
	time_left = typing_timer.time_left
	typing_timer.stop()
	timeout = false
	typing_timer_lbl.visible = false
	#$ColorRect.visible = false

func restart_timer(is_meca: bool = false):
	var remaining = typing_timer.time_left
	if is_meca:
		meca_score += int(remaining)
	else:
		libre_score += remaining
	typing_timer.stop()
	typing_timer.start()
	timeout = true
	typing_timer_lbl.visible = true
	#$ColorRect.visible = true


func restart_timer_no_score():
	typing_timer.stop()
	typing_timer.start()
	timeout = true
	typing_timer_lbl.visible = true
	#$ColorRect.visible = true

func capture_last_field(is_meca: bool):
	var remaining = typing_timer.time_left
	if is_meca:
		meca_score += int(remaining)
	else:
		libre_score += remaining

func get_time_left():
	return time_left

func next_action():
	get_parent().get_parent().get_parent().next_action()

func _on_timer_timeout() -> void:
	Global.next_text.emit()
