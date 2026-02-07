extends TextureRect


func activate(_visibility: bool = true):
	var tween = get_tree().create_tween()
	#tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_method(set_scale, Vector2(0.9,0.9), Vector2(1,1), 0.05)
	visible = true

#func set_scale(value: Vector2):
	#scale = value	
