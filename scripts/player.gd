extends CharacterBody2D

signal laser_shot(laser)

@export var max_speed := 350.0
@export var acceleration := 10.0
@export var rotatation_speed := 250.0

@onready var muzzle = $Muzzle
@onready var lasers = $"../Lasers"

var laser_scene = preload ("res://scenes/laser.tscn")

var shoot_cooldown = false

func _process(delta: float) -> void:
    shoot_laser()

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
    velocity += input_vector.rotated(rotation) * acceleration
    velocity = velocity.limit_length(max_speed)

    if Input.is_action_pressed("rotate_right"):
        rotate(deg_to_rad(rotatation_speed) * delta)
    if Input.is_action_pressed("rotate_left"):
        rotate(deg_to_rad( - rotatation_speed) * delta)

    if input_vector.y == 0:
        velocity = velocity.move_toward(Vector2.ZERO, 3)
    move_and_slide()

    var screen_size = get_viewport_rect().size
    if global_position.y < 0:
        global_position.y = screen_size.y
    if global_position.y > screen_size.y:
        global_position.y = 0
    if global_position.x > screen_size.x:
        global_position.x = 0
    if global_position.x < 0:
        global_position.x = screen_size.x

func shoot_laser():
    if Input.is_action_just_pressed("shoot"):
        var laser = laser_scene.instantiate()
        lasers.add_child(laser)
        laser.global_position = muzzle.global_position
        laser.rotation = rotation
        emit_signal("laser_shot", laser)
