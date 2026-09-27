extends Control

@onready var label: Label = $VBoxContainer/Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
    label.text = ""
    GlobalManager.player.trick_hint.connect(_on_trick)
        
func _on_trick(text: String) -> void:
    show()
    if text == 'Perfect!':
        animation_player.play("increase_score")
    label.text = text
    var tween = create_tween()
    tween.tween_property(self, "modulate:a", 0.0, 1.0)
    await tween.finished
    hide()
    self.modulate.a = 1.0
