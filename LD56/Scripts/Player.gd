extends CharacterBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var move_dir = Vector3.ZERO
	move_dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	move_dir.z = Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")
	move_dir.y += 1 if Input.is_physical_key_pressed(KEY_Q) else 0
	move_dir.y -= 1 if Input.is_physical_key_pressed(KEY_E) else 0
	position += move_dir * delta
