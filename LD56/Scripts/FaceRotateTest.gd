extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_physical_key_pressed(KEY_W):
		rotate(transform.basis.z.normalized(), delta)
	if Input.is_physical_key_pressed(KEY_S):
		rotate(transform.basis.y.normalized(), delta)
	if Input.is_physical_key_pressed(KEY_X):
		rotate(transform.basis.x.normalized(), delta)
	
