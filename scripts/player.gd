class_name Player extends CharacterBody2D

signal laser_shot(laser)
#signal missile_fired(laser)
signal died

@export var max_speed := 350.0
@export var acceleration := 10.0
@export var rotatation_speed := 500.0
@export var laser_rof := 0.1
@export var missile_rof := 0.010

@onready var muzzle = $Muzzle
@onready var lasers = $"../Lasers"
@onready var missiles = $"../Missiles"
@onready var sprite = $Sprite2D
@onready var engine_time_scale = Engine.time_scale
@onready var cshape = $CollisionShape2D
@onready var radar_beam = $RadarBeam

var laser_scene = preload ("res://scenes/laser.tscn")
var missile_scene = preload ("res://scenes/missile.tscn")

var shoot_cooldown = false
var shoot_alt_cooldown = false

var alive := true

func _process(delta: float) -> void:
    if !alive:
        return
    engine_time_scale = Engine.time_scale
    if Input.is_action_pressed("shoot"):
        if !Input.is_action_pressed("alt_input"):
            if !shoot_cooldown:
                shoot_laser()
                $LaserSound.pitch_scale = engine_time_scale
                $LaserSound.play()
                shoot_cooldown = true
                await get_tree().create_timer(laser_rof / engine_time_scale).timeout
                shoot_cooldown = false
    
    if Input.is_action_just_pressed("shoot_alt"):
        print(Input)
        print(get_global_mouse_position())
        if !Input.is_action_pressed("alt_input"):
            if !shoot_alt_cooldown:
                fire_missile(get_global_mouse_position())
                #$LaserSound.pitch_scale = engine_time_scale
                #$LaserSound.play()
                shoot_alt_cooldown = true
                await get_tree().create_timer(missile_rof / engine_time_scale).timeout
                shoot_alt_cooldown = false

    if radar_beam.is_colliding():
        var collider = radar_beam.get_collider(0)
        if collider is Asteroid:
            collider.just_detected()

func _physics_process(delta: float) -> void:
    if !alive:
        return
    #var scan speed = 5.0 * Engine.time_scale
    radar_beam.rotation += deg_to_rad(5.0 * Engine.time_scale)

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

func fire_missile(target):
    var missile = missile_scene.instantiate()
    missile.set_target_position(target)
    missile.set_init_rot(rotation)
    missiles.add_child(missile)
    missile.global_position = muzzle.global_position
    missile.rotation = rotation
    #emit_signal("missile_fired", missile)

func die():
    if alive == true:
        velocity = Vector2.ZERO
        alive = false
        cshape.set_deferred("disabled", true)
        sprite.visible = false
        emit_signal("died")
        #process_mode = Node.PROCESS_MODE_DISABLED

func respawn(pos):
    cshape.set_deferred("disabled", false)
    global_position = pos
    alive = true
    sprite.visible = true
    #process_mode = Node.PROCESS_MODE_INHERIT
