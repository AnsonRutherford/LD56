class_name FKBone
extends Node3D
	
func update(start, end):
	var dir = start - end
	position = start + dir / 2
	look_at(end, dir.cross(Vector3(-dir.z, 0, dir.x)))	
	
static func get_elbow(start, end, arm_length):
	# Right now, great at two equal lengths, won't touch anything else
	var dir = end - start
	var joint_up = dir.cross(Vector3(-dir.z, 0, dir.x)).normalized()
	
	var hc = sqrt((4 * pow(arm_length, 2)) - pow(dir.length(), 2)) / 2 # sqrt(4 * a^2 * c^2)/2
	return start + (dir / 2) + joint_up * hc
	
