class_name Missile extends Area2D

@onready var collision_shape = $CollisionShape2D

var movement_vector = Vector2(0, -1)
@export var speed = 500

var _current_velocity = Vector2.ZERO
var target_position := Vector2.ZERO
var desired_velocity := Vector2.ZERO
var direction := Vector2.ZERO
var change := Vector2.ZERO
var drag_factor := 0.15

func _ready() -> void:
    _current_velocity = speed * movement_vector.rotated(rotation)

func _physics_process(delta: float) -> void:
    #global_position += movement_vector.rotated(rotation) * delta * speed
    direction = Vector2.RIGHT.rotated(rotation).normalized()
    #direction = Vector2.RIGHT.rotated(rotation).normalized()

    direction = global_position.direction_to(target_position)
    desired_velocity = direction * speed
    change = (desired_velocity - _current_velocity) * drag_factor

    _current_velocity += change
    global_position += _current_velocity * delta
    look_at(global_position + _current_velocity)
    rotation += PI / 2

    var half_x = collision_shape.shape.radius
    var half_y = half_x + collision_shape.shape.height / 2
    var screen_size = get_viewport_rect().size

    if (global_position.y + half_y) < 0:
        global_position.y = (screen_size.y + half_y)
    elif (global_position.y - half_y) > screen_size.y:
        global_position.y = -half_y
    if (global_position.x + half_x) < 0:
        global_position.x = (screen_size.x + half_x)
    elif (global_position.x - half_x) > screen_size.x:
        global_position.x = -half_x

func _on_area_entered(area: Area2D) -> void:
    if area is Asteroid:
        var asteroid = area
        asteroid.explode()
        queue_free()

func set_target_position(pos: Vector2) -> void:
    target_position = pos
