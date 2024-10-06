class_name Creature
extends CharacterBody3D

@onready
var footPrefab = preload("res://Scene/Prefabs/Foot.tscn")

var feet = []
var foot_index = []

var stepping = false
var minimum_step_speed = 1

var speed = 3

var is_hold
var thrown
var stun_timer = 0

var food_match = null

@onready
var nav_agent = get_node("NavigationAgent3D")
var target_timer = 99999
@onready
var region = get_node("/root/Node3D/NavigationRegion3D")

var face_color
var hat_color
var size

var food_type1
var food_type2

var is_collected

static func spawn_creature(node, params, position):
	var creature_prefab = preload("res://Scene/Prefabs/Creature.tscn")
	var creature = creature_prefab.instantiate()
	node.add_child(creature)
	creature.global_position = position
	creature.init(params)

# Called when the node enters the scene tree for the first time.
func init(params):
	size = params["size"]
	
	scale = Vector3.ONE * size
	speed *= size
	
	nav_agent.path_desired_distance = size
	nav_agent.target_desired_distance = size * 1.1
	#nav_agent.path_height_offset = 0.5 - size/2
	
	face_color = params["face_color"]
	hat_color = params["hat_color"]
	
	get_node("Face").set_color(face_color)
	get_node("Hat").set_color(hat_color)
	
	food_type1 = params["food_type1"]
	food_type2 = params["food_type2"]
	
	var leg_height = params["leg_height"] * size
	var leg_splay = params["leg_splay"] * size
	var leg_scale = params["leg_scale"]
	
	var offsets = [
		(Vector3.FORWARD + Vector3.RIGHT) * leg_splay, 
		(Vector3.FORWARD + Vector3.LEFT) * leg_splay, 
		(Vector3.BACK + Vector3.RIGHT) * leg_splay, 
		(Vector3.BACK + Vector3.LEFT) * leg_splay]
	var bone_length = (leg_height + leg_splay) * 0.8
	var foot_count = 0
	for offset in offsets:
		var foot = footPrefab.instantiate()
		add_child(foot)
		# Too many parameters, using a dict so I can easily remember which is which (ugly)
		foot.init({
			"foot_scale" = leg_scale,
			"offset" = offset,
			"max_step_distance" = 0.5 * size / speed, 
			"step_duration" = 0.2 * size / speed, 
			"step_height" = leg_height, 
			"start_offset" = Vector3.UP * leg_height,
			"bone_length" = bone_length,
			"bone_scale" = Vector3(0.2, 0.2, bone_length / (size * leg_scale))
		})
		feet.append(foot)
		foot_index.append(foot_count)
		foot_count += 1
		
		nav_agent.set_target_position(NavigationServer3D.region_get_random_point(region, 1, true))
		target_timer = 5 + randf() * 10

func _process(delta):
	if food_match != null and is_instance_valid(food_match):
		food_match = null
	target_timer -= delta
	if target_timer <= 10:
		if food_match == null:
			food_match = Food.food_match(position, food_type1, food_type2)
		if food_match == null:
			target_timer = 0
		else:
			nav_agent.set_target_position(food_match.global_position)
	if target_timer <= 0:
		nav_agent.set_target_position(NavigationServer3D.region_get_random_point(region, 1, true))
		#nav_agent.set_target_position(Player.instance.global_position)
		target_timer = 5 + randf() * 10

func _physics_process(delta):
	if food_match != null and (food_match.global_position - global_position).length() < size * 3:
		food_match.despawn()
	if global_position.y < -2:
		if !is_collected and World.collect(self):
			is_collected = true
	if global_position.y < -10:
		queue_free()
	if is_hold:
		global_position = Player.get_held_position(size)
	elif thrown:
		velocity += Vector3.DOWN * delta * 25
		move_and_slide()
		if is_on_floor():
			velocity = Vector3.ZERO
			thrown = false
			for foot in feet:
				foot.reset_position()
			stun_timer = 2
	else:
		# Move
		stun_timer -= delta
		var move_dir = Vector3.ZERO
		var step_speed = minimum_step_speed
		if stun_timer <= 0 and !nav_agent.is_navigation_finished():
			move_dir = (nav_agent.get_next_path_position() - global_position).normalized()
			step_speed = max(minimum_step_speed, speed) # ???
		velocity = move_dir * speed
		move_and_slide()
		if !is_on_floor():
			throw(Vector3.ZERO)
			
		# Step with feet
		var step = false
		var stepping_foot = -1
		for foot in foot_index:
			if feet[foot].update(delta * max(step_speed, 1), move_dir * speed, step or stepping):
				step = true
				stepping_foot = foot
		stepping = step
		
		# Update feet index
		if stepping_foot != -1 and stepping_foot != foot_index[-1]:
			var new_index = []
			for foot in foot_index:
				if foot != stepping_foot:
					new_index.append(foot)
			new_index.append(stepping_foot)
			foot_index = new_index
			
func throw(throw_vector):
	is_hold = false
	thrown = true
	velocity = throw_vector
