extends Label

func _process(delta):
	if Player.instance.holding == null:
		add_theme_color_override("font_color", Color(1, 1, 1, 0))
	else:
		add_theme_color_override("font_color", Color(1, 1, 1, 1))
