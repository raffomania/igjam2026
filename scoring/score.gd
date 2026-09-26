extends Control

@onready var label: Label = $MarginContainer/Label

var score := 0


func _ready() -> void:
    GlobalManager.player_body.add_score.connect(add_score)
    label.text = "score: %s" % score


func add_score(val: int) -> void:
    score += val
    label.text = "score: %s" % score
