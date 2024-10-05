extends CharacterBody3D

@onready
var footPrefab = preload("res://Scene/Prefabs/Foot.tscn")

var feet = []
var foot_index = []

var stepping = false
var minimum_step_speed = 1

var speed = 3

var is_hold

@onready
var nav_agent = get_node("NavigationAgent3D")
var target_timer = 99999

# Called when the node enters the scene tree for the first time.
func _ready():
	nav_agent.path_desired_distance = scale.x
	nav_agent.target_desired_distance = scale.x * 1.1
	nav_agent.path_height_offset = 0.5 - scale.x/2
	
	var offsets = [
		Vector3.FORWARD + Vector3.DOWN / 3, 
		Vector3.RIGHT + Vector3.DOWN / 3, 
		Vector3.BACK + Vector3.DOWN / 3, 
		Vector3.LEFT + Vector3.DOWN / 3]
	var foot_count = 0
	for offset in offsets:
		var foot = footPrefab.instantiate()
		add_child(foot)
		foot.init(0.5, offset, scale.x, 0.8 / speed, 1, Vector3(0.2, 0.2, 3))
		feet.append(foot)
		foot_index.append(foot_count)
		foot_count += 1
		
	speed *= scale.x
	actor_setup.call_deferred()
	
func actor_setup():
	await get_tree().physics_frame
	nav_agent.set_target_position(Vector3.RIGHT * randf_range(-10, 10) + Vector3.FORWARD * randf_range(-10, 10))
	target_timer = 5 + randf() * 10

func _process(delta):
	target_timer -= delta
	if target_timer <= 0:
		#nav_agent.set_target_position(Vector3.RIGHT * randf_range(-10, 10) + Vector3.FORWARD * randf_range(-10, 10))
		nav_agent.set_target_position(Vector3.RIGHT * randf_range(-10, 10) + Vector3.FORWARD * randf_range(-10, 10))
		target_timer = 5 + randf() * 10

func _physics_process(delta):
	if is_hold:
		global_position.y += delta
	else:
		# Move
		var move_dir = Vector3.ZERO
		var step_speed = minimum_step_speed
		if !nav_agent.is_navigation_finished():
			move_dir = (nav_agent.get_next_path_position() - global_position).normalized()
			step_speed = max(minimum_step_speed, speed) # ???
			velocity = move_dir * speed
			move_and_slide()
		
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
