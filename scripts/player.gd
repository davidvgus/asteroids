extends CharacterBody2D
@export var acceleration := 10.0
func _physics_process(delta: float) -> void:
	#var input_vector := Vector2(0, Input.get_axis("move_forward", "move_backward"))
	var input_vector := Vector2(0, 0)
	if Input.is_action_pressed("move_foreward"):
		print("move_forward")
		#bleh
		input_vector.y = -1
	if Input.is_action_pressed("move_backward"):
		print("move_backward")
		input_vector.y = 1
	print(input_vector)
	velocity += input_vector * acceleration
	move_and_slide()
