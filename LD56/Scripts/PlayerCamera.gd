extends Camera3D

var mouse_input = true

var vert_look = 0
var vert_max = 70
var vert_min = -70

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _process(_delta):
	if Input.is_physical_key_pressed(KEY_ESCAPE):
		mouse_input = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		mouse_input = true
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):  		
	if mouse_input and event is InputEventMouseMotion:
		rotate(Vector3.UP, -deg_to_rad(event.relative.x))
		var v = -event.relative.y
		v = min(vert_max - vert_look, v)
		v = max(vert_min - vert_look, v)
		vert_look += v
		rotate(basis.x.normalized(), deg_to_rad(v))
