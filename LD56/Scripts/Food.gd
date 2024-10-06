class_name Food
extends RigidBody3D

static var food_list = []

var food_type1
var food_type2

var death_timer = -1
var death_time = 0.2

var lifetime = 30

@onready
var mesh = get_node("MeshInstance3D")
@onready
var base_scale = mesh.scale.x

func _ready():
	food_list.append(self)
	
func _process(delta):
	if death_timer > 0:
		mesh.scale = Vector3.ONE * base_scale * death_timer / death_time
		death_timer -= delta
		if death_timer <= 0:
			queue_free()
	else:
		lifetime -= delta
		if lifetime < 0 or global_position.y < -3:
			despawn()
	
func despawn():
	food_list.erase(self)
	death_timer = death_time

static func spawn_food(node, type1, type2, color, position, force):
	var food = preload("res://Scene/Prefabs/Food.tscn").instantiate()
	node.add_child(food)
	food.global_position = position
	food.apply_force(force)
	food.food_type1 = type1
	food.food_type2 = type2
	food.mesh.set_surface_override_material(0, food.mesh.get_surface_override_material(0).duplicate())
	food.mesh.get_surface_override_material(0).albedo_color = color
	
static func food_match(position, type1, type2):
	var best_food = null
	var best_dist = 0
	for food in food_list:
		if food.food_type1 == type1 or food.food_type2 == type2:
			var dist = (food.global_position - position).length()
			if best_food == null or best_dist > dist:
				best_food = food
				best_dist = dist
	return best_food
