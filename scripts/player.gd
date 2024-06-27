class_name Player extends CharacterBody2D

signal laser_shot(laser)
signal died

@export var max_speed := 350.0
@export var acceleration := 10.0
@export var rotatation_speed := 500.0
@export var laser_rof := 0.1

@onready var muzzle = $Muzzle
@onready var lasers = $"../Lasers"
@onready var sprite = $Sprite2D

var laser_scene = preload ("res://scenes/laser.tscn")

var shoot_cooldown = false

var alive := true

func _process(delta: float) -> void:
    if Input.is_action_pressed("shoot"):
        if !shoot_cooldown:
            shoot_laser()
            shoot_cooldown = true
            await get_tree().create_timer(laser_rof).timeout
            shoot_cooldown = false

func _physics_process(delta: float) -> void:
    var input_vector := Vector2(0, 0)
    if Input.is_action_pressed("move_foreward"):
        input_vector.y = -1
    if Input.is_action_pressed("move_backward"):
        input_vector.y = 1
    velocity += input_vector.rotated(rotation) * acceleration
    velocity = velocity.limit_length(max_speed)

    if Input.is_action_pressed("rotate_right"):
        rotate(deg_to_rad(rotatation_speed) * delta)
    if Input.is_action_pressed("rotate_left"):
        rotate(deg_to_rad( - rotatation_speed) * delta)

    #if input_vector.y == 0:
    #    velocity = velocity.move_toward(Vector2.ZERO, 3)
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
    var laser = laser_scene.instantiate()
    lasers.add_child(laser)
    laser.global_position = muzzle.global_position
    laser.rotation = rotation
    emit_signal("laser_shot", laser)

func die():
    if alive == true:
        alive = false
        emit_signal("died")
        sprite.visible = false
        process_mode = Node.PROCESS_MODE_DISABLED

func respawn(pos):
    print("respawn")
    global_position = pos
    alive = true
    sprite.visible = true
    process_mode = Node.PROCESS_MODE_INHERIT
