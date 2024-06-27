extends Node2D

@onready var lasers = $Lasers
@onready var player = $Player
@onready var asteroids = $Asteroids
@onready var hud = $UI/HUD
@onready var player_spawn_postion = $PlayerSpawnPosition

var default_time_scale = 1.0

var asteroid_scene = preload ("res://scenes/asteroid.tscn")

var score := 0:
    set(value):
        score = value
        hud.set_score(score)

var lives := 3

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
    score = 0
    Engine.time_scale = default_time_scale

    for asteroid in asteroids.get_children():
        asteroid.connect("exploded", _on_asteroid_exloded)
    player.connect("died", _on_player_died)

func _on_asteroid_exloded(pos, size, points):
    score += points
    for i in range(2):
        match size:
            Asteroid.AsteroidSize.LARGE:
                spawn_asteroid(pos, Asteroid.AsteroidSize.MEDIUM)
            Asteroid.AsteroidSize.MEDIUM:
                spawn_asteroid(pos, Asteroid.AsteroidSize.SMALL)
            Asteroid.AsteroidSize.SMALL:
                pass
        push_error(points)

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

func _on_player_died():
    lives -= 1
    print(lives)
    if lives <= 0:
        get_tree().reload_current_scene()
        print(lives)
    else:
        await get_tree().create_timer(1.0).timeout
        player.respawn(player_spawn_postion.global_position)
