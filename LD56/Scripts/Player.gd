class_name Player
extends CharacterBody3D

static var instance

var speed = 4

@onready
var camera = get_node("Camera3D")

func _ready():
	instance = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var move_dir = Vector3.ZERO
	move_dir += (Input.get_action_strength("Player_Right") - Input.get_action_strength("Player_Left")) * camera.basis.x.normalized()
	move_dir += (Input.get_action_strength("Player_Back") - Input.get_action_strength("Player_Forward")) * camera.basis.z.normalized()
	move_dir.y = Input.get_action_strength("Player_Up") - Input.get_action_strength("Player_Down")
	position += move_dir * delta * speed
