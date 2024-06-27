extends Control

@onready var score_label: Label = $Score

var _score: int

func set_score(value: int) -> void:
    _score = value
    score_label.text = "SCORE: " + str(value)

func update_score(value: int) -> void:
    set_score(value)
