extends Node3D

@export
var distance : float
@onready
var wall = get_node("../Wall")

var toggle = true

func _process(delta):
	var flat_pos = Player.instance.global_position
	flat_pos.y = global_position.y
	var flat_dir = flat_pos - global_position
	if Input.is_action_just_pressed("Interact"):
		if flat_dir.length() < 4 and flat_dir.dot(basis.z) > 0:
			toggle_button()

func toggle_button():
	var tween = get_tree().create_tween()
	if toggle:
		tween.tween_property(wall, "position", Vector3.DOWN * distance, 0.4)
	else:
		tween.tween_property(wall, "position", Vector3.ZERO, 0.4)
	toggle = !toggle
