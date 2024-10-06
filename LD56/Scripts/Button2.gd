extends Node3D

@onready
var wall = get_node("../Trap Door")

var timer = 0

func _process(delta):
	var flat_pos = Player.instance.global_position
	flat_pos.y = global_position.y
	var flat_dir = flat_pos - global_position
	if timer == 0 and Input.is_physical_key_pressed(KEY_R):
		if flat_dir.length() < 4 and flat_dir.dot(basis.z) > 0:
			timer = 4
			World.lever_pulled()
	if (timer > 0):
		timer -= delta
		if timer < 0:
			timer = 0
			wall.position.x = 0
		else:
			wall.position.x = 10 * abs((timer / 4) - 0.5) - 5
