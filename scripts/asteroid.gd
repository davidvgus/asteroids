class_name Asteroid extends Area2D

signal exploded(pos, size)
signal detected

var movement_vector := Vector2(0, -1)
enum AsteroidSize {SMALL, MEDIUM, LARGE}
@export var size = AsteroidSize.LARGE
@export var fade_out_time = 1.0

var speed := 50

@onready var sprite = $Sprite2D
@onready var collision_shape = $CollisionShape2D
@onready var fade_out_tween = $Tween

@export var points: int:
    get:
        match size:
            AsteroidSize.LARGE:
                return 100
            AsteroidSize.MEDIUM:
                return 50
            AsteroidSize.SMALL:
                return 20
            _:
                return 0

func _ready() -> void:
    rotation = randf_range(0, 2 * PI)
    fade_out()

    match size:
        AsteroidSize.LARGE:
            speed = randi_range(50, 100)
            sprite.texture = preload ("res://assets/textures/meteorGrey_big4.png")
            collision_shape.shape = preload ("res://resources/asteroid_cshape_large.tres")
        AsteroidSize.MEDIUM:
            speed = randi_range(100, 150)
            sprite.texture = preload ("res://assets/textures/meteorGrey_med2.png")
            collision_shape.shape = preload ("res://resources/asteroid_cshape_medium.tres")
        AsteroidSize.SMALL:
            speed = randi_range(150, 200)
            sprite.texture = preload ("res://assets/textures/meteorGrey_tiny1.png")
            collision_shape.shape = preload ("res://resources/asteroid_cshape_small.tres")

func _physics_process(delta: float) -> void:
    global_position += movement_vector.rotated(rotation) * delta * speed

    var radius = collision_shape.shape.radius
    var screen_size = get_viewport_rect().size

    if (global_position.y + radius) < 0:
        global_position.y = (screen_size.y + radius)
    elif (global_position.y - radius) > screen_size.y:
        global_position.y = -radius
    if (global_position.x + radius) < 0:
        global_position.x = (screen_size.x + radius)
    elif (global_position.x - radius) > screen_size.x:
        global_position.x = -radius

func explode() -> void:
    emit_signal("exploded", global_position, size, points)
    queue_free()

func _on_body_entered(body: Node2D) -> void:
    print("Asteroid collided with", body)
    if body is Player:
        var player = body
        player.die()

func fade_out():
    fade_out_tween = get_tree().create_tween()
    fade_out_tween.tween_property(self, "modulate:a", 0, fade_out_time)

func just_detected():
    modulate.a = 1
    fade_out()
