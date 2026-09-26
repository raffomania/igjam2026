extends Control

@onready var label: Label = $MarginContainer/Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
    GlobalManager.player.level_increased.connect(level_increased)
    label.text = "gravity x%s" % GlobalManager.player.level


func level_increased(level: int) -> void:
    label.text = "gravity x%s" % level
    animation_player.play("increase_score")
