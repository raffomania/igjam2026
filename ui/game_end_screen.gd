extends Control

@onready var play_again: Button = $VBoxContainer/PlayAgain 
@onready var score_label: Label = $VBoxContainer/Score 

func _ready() -> void:
    GlobalManager.game_end.connect(_on_game_end)
    play_again.pressed.connect(_on_play_again_pressed)
    hide()

func _on_play_again_pressed() -> void:
    GlobalManager.play_again()
    
func _on_game_end():
    score_label.text = "12345"
    show()
