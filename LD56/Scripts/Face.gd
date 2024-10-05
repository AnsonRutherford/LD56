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

func _ready():
	set_surface_override_material(0, get_surface_override_material(0).duplicate())
	get_surface_override_material(0).albedo_texture = face
	get_surface_override_material(0).texture_filter = 0

func _process(delta):
	
	# Looking
	var player_position = Player.instance.global_position
	if abs(player_position.x - global_position.x) > 0.1 or abs(player_position.z - global_position.z) > 0.1:
		look_at(player_position)
	else:
		look_at(Vector3.UP, global_position - player_position)

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
