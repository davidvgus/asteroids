extends Node2D

@onready var lasers = $Lasers
@onready var player = $Player
@onready var asteroids = $Asteroids

var asteroid_scene = preload ("res://scenes/asteroid.tscn")

func _process(delta: float) -> void:
    if Input.is_action_just_pressed("reset"):
        get_tree().reload_current_scene()
        
func _ready() -> void:
    for asteroid in asteroids.get_children():
        asteroid.connect("exploded", _on_asteroid_exloded)

#func _on_player_laser_shot(laser) -> void:
#    lasers.add_child(laser)

func _on_asteroid_exloded(pos, size):
    for i in range(2):
        match size:
            Asteroid.AsteroidSize.LARGE:
                spawn_asteroid(pos, Asteroid.AsteroidSize.MEDIUM)
                spawn_asteroid(pos, Asteroid.AsteroidSize.MEDIUM)
            Asteroid.AsteroidSize.MEDIUM:
                spawn_asteroid(pos, Asteroid.AsteroidSize.SMALL)
                spawn_asteroid(pos, Asteroid.AsteroidSize.SMALL)
            Asteroid.AsteroidSize.SMALL:
                pass

func spawn_asteroid(pos, size):
    var a = asteroid_scene.instantiate()
    a.global_position = pos
    a.size = size
    a.connect("exploded", _on_asteroid_exloded)
    asteroids.add_child(a)
