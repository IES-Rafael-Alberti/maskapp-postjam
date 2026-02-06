class_name ConversationPanel
extends TextureRect

signal emojis_selected

var emojis_selection: bool = false
var timeout: bool = true
var time_left: float = 0
var emoji_mult: float = 1.0
var emoji_scores = {"yes1": 1.5,
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
"no1": -2.0}

func _process(_delta: float) -> void:
	if timeout and $Timer:
		$Label.text = "%.2f" % $Timer.time_left

func _on_emoji_selected(_emoji):
	if _emoji.name in emoji_scores:
		emoji_mult = emoji_scores[_emoji.name]
	emojis_selection = false
	show_emojis(false)
	$Emoji_selected.texture = _emoji.texture
	$Emoji_selected.visible = true
	emojis_selected.emit()

func get_panel():
	return $Panel/TextContainer
	
func show_emojis(_visible:bool = true):
	$Emojis_panel.visible = _visible
	emojis_selection = _visible

func stop_timer():
	time_left = $Timer.time_left
	$Timer.stop()
	timeout = false
	$Label.visible = false

func get_time_left():
	return time_left

func next_action():
	stop_timer()
	get_parent().get_parent().get_parent().next_action()

func _on_timer_timeout() -> void:
	stop_timer()
	next_action()
