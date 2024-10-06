class_name Face
extends MeshInstance3D

@export
var face : Texture2D
@export
var blink : Texture2D

var blink_duration = 0.15
var base_blink_cooldown = 0.5
var blink_cooldown_variance = 5

var blink_timer = 0
var blink_stop = 0

@onready
var hat = get_node("../Hat")

var look_target

func _ready():
	set_surface_override_material(0, get_surface_override_material(0).duplicate())
	get_surface_override_material(0).albedo_texture = face
	get_surface_override_material(0).texture_filter = 0

func _physics_process(delta):
	
	# Looking
	look_target = Player.eye_contact()
	hat.look_target = look_target
	var look_dir = Face.get_look_direction(global_position, look_target, 1000, 1)
	if look_dir:
		look_at(look_dir + global_position)

	# Blinking
	if blink_timer > 0:
		blink_timer -= delta
		if blink_timer < blink_stop:
			blink_stop = 0
			get_surface_override_material(0).albedo_texture = face
	else:
		blink_stop = base_blink_cooldown + randf() * blink_cooldown_variance
		blink_timer = blink_duration + blink_stop
		get_surface_override_material(0).albedo_texture = blink
		
static func get_look_direction(position, target_position, height_ratio_max, height_multiplier):
	var flat_look_dir = target_position - position
	var look_y = flat_look_dir.y * height_multiplier
	flat_look_dir.y = 0
	var look_flat_length = flat_look_dir.length()
	if look_flat_length > 0.01:
		if abs(look_y / look_flat_length) > height_ratio_max:
			look_y = look_flat_length * height_ratio_max * sign(look_y)
		return flat_look_dir + Vector3.UP * look_y
	else:
		return false

func set_color(color):
	get_surface_override_material(0).albedo_color = color
