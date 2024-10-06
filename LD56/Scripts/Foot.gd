extends Node3D

var offset
var max_offset
var step_duration
var step_height
var start_offset

var step = false
var step_timer = 0
var pre_step
var post_step

var parent
var last_position

@onready
var fk_bone = preload("res://Scene/Prefabs/FKBone.tscn")

var bone_length
var first_bone
var second_bone

func init(params):	
	scale = Vector3.ONE * params["foot_scale"]
	offset = params["offset"]
	max_offset = params["max_step_distance"]
	step_duration = params["step_duration"]
	step_height = params["step_height"]
	start_offset = params["start_offset"]
	
	bone_length = params["bone_length"]
	
	first_bone = fk_bone.instantiate()
	first_bone.scale = params["bone_scale"]
	add_child(first_bone)
	
	second_bone = fk_bone.instantiate()
	second_bone.scale = params["bone_scale"]
	add_child(second_bone)
	
	parent = get_parent_node_3d()
	global_position = parent.global_position + offset
	last_position = global_position
	#top_level = true
	
func update(delta, move_dir, stepping):
	global_position = last_position
	var parent_pos = parent.global_position
	var target = parent_pos + offset
	if step:
		step_timer += delta / step_duration
		if step_timer >= 1:
			global_position = (post_step + target) / 2
			step = false
		else:
			global_position = lerp(pre_step, (post_step + target) / 2, step_timer)
			global_position.y += step_height * (1 - pow(((2 * (step_timer)) - 1), 2)) # 1 - (2x - 1)^2
	elif !stepping and (global_position - target).length() > max_offset:
		step = true
		step_timer = 0
		pre_step = global_position
		post_step = target + (move_dir * step_duration)
		
	var elbow = FKBone.get_elbow(parent_pos + start_offset, global_position, bone_length)
	first_bone.update(parent_pos + start_offset, elbow)
	second_bone.update(elbow, global_position)
	
	last_position = global_position
	return step
	
func reset_position():
	last_position = global_position
	step = false
