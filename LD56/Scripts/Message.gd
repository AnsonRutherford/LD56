class_name Message
extends Control

var timer = 0
var max_timer = 0
var fade = 0

@onready
var label = get_node("CanvasLayer/Label")

static func spawn_message(root, text, timer, fade):
	var message_prefab = preload("res://Scene/Message.tscn")
	var message = message_prefab.instantiate()
	root.add_child(message)
	message.label.text = text
	message.timer = timer
	message.max_timer = timer
	message.fade = fade
	
func _process(delta):
	timer -= delta
	label.add_theme_color_override("font_color", Color(1, 1, 1, min(1, timer / fade)))
	if timer <= 0:
		queue_free()
	
