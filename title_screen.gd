extends Node3D

@onready var new_game_button = $TitleScreenUI/CenterContainer/HBoxContainer/New


#
func _ready() -> void:
    new_game_button.pressed.connect(_on_new_game_button_pressed)


func _on_new_game_button_pressed():
    print("new_game_button")
    GlobalManager.play_again()
