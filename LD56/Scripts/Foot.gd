extends Node3D

var offset
var max_offset_squared
var step_duration
var step_height

var step = false
var step_timer = 0
var pre_step
var post_step

var parent

@onready
var fk_bone = preload("res://Scene/Prefabs/FKBone.tscn")

var bone_length
var first_bone
var second_bone

func init(init_foot_scale, init_offset, init_scale, init_step_duration, init_step_height, init_bone_scale):
	scale = Vector3.ONE * init_foot_scale
	offset = init_offset * init_scale
	max_offset_squared = pow(init_scale, 2)
	step_duration = init_step_duration
	step_height = init_step_height * init_scale
	
	bone_length = init_bone_scale.z
	
	first_bone = fk_bone.instantiate()
	first_bone.scale = init_bone_scale
	add_child(first_bone)
	
	second_bone = fk_bone.instantiate()
	second_bone.scale = init_bone_scale
	add_child(second_bone)
	
	parent = get_parent_node_3d()
	global_position = parent.global_position + offset
	top_level = true
	
func update(delta, stepping):
	var parent_pos = parent.global_position
	var target = parent_pos + offset
	if step:
		step_timer += delta / step_duration
		if step_timer >= 1:
			global_position = post_step
			step = false
		else:
			global_position = lerp(pre_step, post_step, step_timer)
			global_position.y += step_height * (1 - pow(((2 * (step_timer)) - 1), 2)) # 1 - (2x - 1)^2
	elif !stepping and (global_position - target).length() > max_offset_squared:
		step = true
		step_timer = 0
		pre_step = global_position
		post_step = target
		
	var elbow = FKBone.get_elbow(parent_pos, global_position, bone_length)
	#first_bone.update(parent_pos, global_position)
	#second_bone.update(parent_pos, global_position)
	
	return step
