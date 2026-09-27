extends Control

@onready var label: Label = $MarginContainer/VBoxContainer/Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var score := 0


func _ready() -> void:
    GlobalManager.player_body.add_score.connect(add_score)
    label.text = "collected: %s" % score


func add_score(val: int) -> void:
    score += val
    label.text = "collected: %s" % score
    animation_player.play("increase_score")
