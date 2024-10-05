extends CharacterBody3D

@onready
var footPrefab = preload("res://Scene/Prefabs/Foot.tscn")

var feet = []
var foot_index = []

var stepping = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var offsets = [Vector3.FORWARD, Vector3.RIGHT, Vector3.BACK, Vector3.LEFT]
	var foot_count = 0
	for offset in offsets:
		var foot = footPrefab.instantiate()
		add_child(foot)
		foot.init(0.5, offset, scale.x, 0.1, 1, Vector3(0.1, 0.1, 0.75))
		feet.append(foot)
		foot_index.append(foot_count)
		foot_count += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# Move
	var move_dir = Vector3.ZERO
	move_dir.x += 1 if Input.is_physical_key_pressed(KEY_D) else 0
	move_dir.x -= 1 if Input.is_physical_key_pressed(KEY_A) else 0
	move_dir.z += 1 if Input.is_physical_key_pressed(KEY_W) else 0
	move_dir.z -= 1 if Input.is_physical_key_pressed(KEY_S) else 0
	var velocity = move_dir.length()
	position += move_dir * delta
	
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
