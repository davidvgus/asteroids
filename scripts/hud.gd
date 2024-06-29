extends Control

@onready var score_label: Label = $Score
@onready var lives_label: Label = $Lives

var _score: int
var _lives: int

func set_score(value: int) -> void:
    _score = value
    score_label.text = "SCORE: " + str(value)

func update_score(value: int) -> void:
    set_score(value)

func set_lives(value: int) -> void:
    _lives = value
    lives_label.text = "LIVES: " + str(value)

func update_lives(value: int) -> void:
    set_lives(value)

func _on_time_scale_slider_drag_ended(value_changed: bool) -> void:
    Engine.time_scale = $Lives/TimeScaleSlider.value
