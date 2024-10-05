extends CharacterBody3D

@onready
var footPrefab = preload("res://Scene/Prefabs/Foot.tscn")

var feet = []
var foot_index = []

var stepping = false

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
		foot.init(0.5, offset, scale.x, 0.3, 1, Vector3(0.2, 0.2, 2))
		feet.append(foot)
		foot_index.append(foot_count)
		foot_count += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# Move
	var move_dir = Vector3.ZERO
	move_dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	move_dir.z = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	var velocity = move_dir.length()
	position += move_dir * delta * scale.x
	
	# Step with feet
	var step = false
	var stepping_foot = -1
	for foot in foot_index:
		if feet[foot].update(delta * max(velocity, 1), stepping or step):
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
