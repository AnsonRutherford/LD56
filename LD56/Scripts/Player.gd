class_name Player
extends CharacterBody3D

static var instance

var speed = 4

@onready
var camera = get_node("Camera3D")
@onready
var raycast = get_node("Camera3D/RayCast3D")

func _ready():
	instance = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	var move_dir = Vector3.ZERO
	var camera_right = camera.basis.x
	camera_right.y = 0
	camera_right = camera_right.normalized()
	var camera_forward = camera.basis.z
	camera_forward.y = 0
	camera_forward = camera_forward.normalized()
	move_dir += (Input.get_action_strength("Player_Right") - Input.get_action_strength("Player_Left")) * camera_right
	move_dir += (Input.get_action_strength("Player_Back") - Input.get_action_strength("Player_Forward")) * camera_forward
	velocity = move_dir * speed
	move_and_slide()
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and raycast.is_colliding():
		raycast.get_collider().is_hold = true
