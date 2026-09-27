extends Node3D

@onready var new_game_button = $TitleScreenUI/CenterContainer/HBoxContainer/New
@onready var exit_button = $TitleScreenUI/CenterContainer/HBoxContainer/Exit


func _ready() -> void:
    new_game_button.pressed.connect(_on_new_game_button_pressed)
    exit_button.pressed.connect(_on_exit_button_pressed)


func _on_new_game_button_pressed():
    GlobalManager.play_again()


func _on_exit_button_pressed():
    get_tree().quit()
