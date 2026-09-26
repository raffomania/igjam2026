extends Control

@onready var label: Label = $MarginContainer/Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
    GlobalManager.player.level_increased.connect(level_increased)
    update_label(GlobalManager.player.level)


func level_increased(level: int) -> void:
    animation_player.play("increase_score")
    update_label(level)


func update_label(level):
    if level < 2:
        label.visible = false
    else:
        label.visible = true
    label.text = "combo x%s" % level
