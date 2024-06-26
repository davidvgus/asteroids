extends Area2D
var movement_vector = Vector2(0, -1)
@export var speed = 1000

func _physics_process(delta: float) -> void:
    global_position += movement_vector.rotated(rotation) * delta * speed

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
    queue_free()
