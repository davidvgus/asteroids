extends Node2D

@onready var lasers = $Lasers
@onready var player = $Player
@onready var asteroids = $Asteroids

var default_time_scale = 1.0

var asteroid_scene = preload ("res://scenes/asteroid.tscn")

func _process(delta: float) -> void:
    if Input.is_action_just_pressed("reset"):
        get_tree().reload_current_scene()
    
    if Input.is_action_pressed("increase_time_scale"):
        increase_time_scale()
    if Input.is_action_pressed("decrease_time_scale"):
        decrease_time_scale()
    if Input.is_action_pressed("reset_time_scale"):
        reset_time_scale()

func _ready() -> void:

    Engine.time_scale = default_time_scale

    for asteroid in asteroids.get_children():
        asteroid.connect("exploded", _on_asteroid_exloded)

#func _on_player_laser_shot(laser) -> void:
#    lasers.add_child(laser)

func _on_asteroid_exloded(pos, size):
    for i in range(2):
        match size:
            Asteroid.AsteroidSize.LARGE:
                spawn_asteroid(pos, Asteroid.AsteroidSize.MEDIUM)
            Asteroid.AsteroidSize.MEDIUM:
                spawn_asteroid(pos, Asteroid.AsteroidSize.SMALL)
            Asteroid.AsteroidSize.SMALL:
                pass

func spawn_asteroid(pos, size):
    var a = asteroid_scene.instantiate()
    a.global_position = pos
    a.size = size
    a.connect("exploded", _on_asteroid_exloded)
    asteroids.add_child(a)

func set_time_scale(scale: float) -> void:
    Engine.time_scale = scale

func get_time_scale() -> float:
    return Engine.time_scale

func increase_time_scale() -> void:
    Engine.time_scale += 0.1
    Engine.time_scale = clamp(Engine.time_scale, 0.1, 2.0)

func decrease_time_scale() -> void:
    Engine.time_scale -= 0.1
    Engine.time_scale = clamp(Engine.time_scale, 0.1, 2.0)

func reset_time_scale() -> void:
    Engine.time_scale = default_time_scale
