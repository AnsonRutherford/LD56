extends CharacterBody3D

@onready
var footPrefab = preload("res://Scene/Prefabs/Foot.tscn")

var feet = []
var foot_index = []

var stepping = false
var minimum_step_speed = 1

var speed = 3

@onready
var target_position = Vector3.RIGHT * randf_range(-10, 10) + Vector3.FORWARD * randf_range(-10, 10)
var target_timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var offsets = [
		Vector3.FORWARD + Vector3.DOWN / 2, 
		Vector3.RIGHT + Vector3.DOWN / 2, 
		Vector3.BACK + Vector3.DOWN / 2, 
		Vector3.LEFT + Vector3.DOWN / 2]
	var foot_count = 0
	for offset in offsets:
		var foot = footPrefab.instantiate()
		add_child(foot)
		foot.init(0.5, offset, scale.x, 0.8 / speed, 1, Vector3(0.2, 0.2, 2))
		feet.append(foot)
		foot_index.append(foot_count)
		foot_count += 1

func _process(delta):
	target_timer -= delta
	if target_timer <= 0:
		target_position = Vector3.RIGHT * randf_range(-10, 10) + Vector3.FORWARD * randf_range(-10, 10)
		target_timer = 5 + randf() * 10

func _physics_process(delta):
	
	# Move
	var distance = (target_position - global_position).length()
	var move_dir = Vector3.ZERO
	var step_speed = minimum_step_speed
	if distance > 0.1:
		move_dir = (target_position - global_position) / distance
		step_speed = max(minimum_step_speed, speed) # ???
		position += move_dir * delta * scale.x * speed
	
	# Step with feet
	var step = false
	var stepping_foot = -1
	for foot in foot_index:
		if feet[foot].update(delta * max(step_speed, 1), move_dir * scale.x * speed, step or stepping):
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
