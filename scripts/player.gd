extends CharacterBody2D
@export var max_speed := 350.0
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
    velocity = velocity.limit_length(max_speed)

    if input_vector.y == 0:
        velocity = velocity.move_toward(Vector2.ZERO, 3)
    move_and_slide()

    var screen_size = get_viewport_rect().size
    if global_position.y < 0:
        global_position.y = screen_size.y
    if global_position.y > screen_size.y:
        global_position.y = 0
