extends MeshInstance3D

var look_target = Vector3.ZERO

func _ready():
	set_surface_override_material(0, get_surface_override_material(0).duplicate())

func _physics_process(delta):
	var look_dir = Face.get_look_direction(global_position, look_target, 0.5, 0.4)
	if look_dir:
		look_at(look_dir + global_position)

func set_color(color):
	get_surface_override_material(0).albedo_color = color
