class_name Player
extends CharacterBody3D

static var instance

var speed = 4
var throw_force = 20
var gravity = 0

@onready
var camera = get_node("Camera3D")
@onready
var shapecast = get_node("Camera3D/ShapeCast3D")
var holding
var charge_timer = 0
var max_charge = 1

var spawn_timer = 0

func _ready():
	instance = self

func _physics_process(delta):
	if global_position.y < -20:
		global_position = Vector3.UP * 30
	var move_dir = Vector3.ZERO
	var camera_right = camera.basis.x
	camera_right.y = 0
	camera_right = camera_right.normalized()
	var camera_back = camera.basis.z
	var forward_y = -camera_back.normalized().y
	camera_back.y = 0
	camera_back = camera_back.normalized()
	move_dir += (Input.get_action_strength("Player_Right") - Input.get_action_strength("Player_Left")) * camera_right
	move_dir += (Input.get_action_strength("Player_Back") - Input.get_action_strength("Player_Forward")) * camera_back
	gravity += delta * 15
	if is_on_floor():
		gravity = 0
		if Input.is_action_just_pressed("Jump"):
			gravity = -10
	velocity = move_dir * speed + gravity * Vector3.DOWN
	move_and_slide()
	
	if spawn_timer > 0:
		spawn_timer -= delta
	elif Input.is_physical_key_pressed(KEY_1):
		spawn_timer = 0.05
		Food.spawn_food(get_tree().root, 0, 0, World.creature_colors[0], global_position + (camera_right - camera_back) * 0.5 + Vector3.UP * (forward_y + 1), -camera.basis.z.normalized() * throw_force * 25)
	elif Input.is_physical_key_pressed(KEY_2):
		spawn_timer = 0.05
		Food.spawn_food(get_tree().root, 1, 1, World.creature_colors[1], global_position + (camera_right - camera_back) * 0.5 + Vector3.UP * (forward_y + 1), -camera.basis.z.normalized() * throw_force * 25)
	elif Input.is_physical_key_pressed(KEY_3):
		spawn_timer = 0.05
		Food.spawn_food(get_tree().root, 2, 2, World.creature_colors[2], global_position + (camera_right - camera_back) * 0.5 + Vector3.UP * (forward_y + 1), -camera.basis.z.normalized() * throw_force * 25)
	elif Input.is_physical_key_pressed(KEY_4):
		spawn_timer = 0.05
		Food.spawn_food(get_tree().root, 3, 3, World.creature_colors[3], global_position + (camera_right - camera_back) * 0.5 + Vector3.UP * (forward_y + 1), -camera.basis.z.normalized() * throw_force * 25)
	elif Input.is_physical_key_pressed(KEY_5):
		spawn_timer = 0.05
		Food.spawn_food(get_tree().root, 4, 4, World.creature_colors[4], global_position + (camera_right - camera_back) * 0.5 + Vector3.UP * (forward_y + 1), -camera.basis.z.normalized() * throw_force * 25)
	elif Input.is_physical_key_pressed(KEY_6):
		spawn_timer = 0.05
		Food.spawn_food(get_tree().root, 5, 5, World.creature_colors[5], global_position + (camera_right - camera_back) * 0.5 + Vector3.UP * (forward_y + 1), -camera.basis.z.normalized() * throw_force * 25)
	
	if charge_timer > 0:
		charge_timer += delta
		charge_timer = min(max_charge, charge_timer)
		if Input.is_action_just_released("Left_Click"):
			holding.throw(-camera.basis.z.normalized() * throw_force * charge_timer)
			holding = null
			charge_timer = 0
	elif Input.is_action_just_pressed("Left_Click"):
		if holding != null:
			#charge_timer += delta
			holding.throw(-camera.basis.z.normalized() * throw_force)
			holding = null
		else:
			var collision_count = shapecast.get_collision_count()
			if collision_count > 0:
				holding = shapecast.get_collider(0)
				holding.is_hold = true
			
static func get_held_position(size):
	var camera_right = instance.camera.basis.x
	camera_right.y = 0
	camera_right = camera_right.normalized()
	var camera_back = instance.camera.basis.z
	var forward_y = -camera_back.normalized().y
	camera_back.y = 0
	camera_back = camera_back.normalized()
	return instance.global_position + (camera_right - camera_back) * (size / 2 + 0.5) + Vector3.UP * (forward_y + 1) + camera_back * instance.charge_timer * 0.25

static func eye_contact():
	return instance.global_position + Vector3.UP
