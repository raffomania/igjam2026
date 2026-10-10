extends Node3D

@export var new_game_button: TextureButton
@export var exit_button: TextureButton
@export var volume_slider: Slider

var currently_selected_button = "new_game_button"


func _ready() -> void:
    new_game_button.pressed.connect(_on_new_game_button_pressed)
    exit_button.pressed.connect(_on_exit_button_pressed)
    new_game_button.hover_on()

    volume_slider.min_value = 0.0
    volume_slider.max_value = 0.8
    volume_slider.step = 0.01
    volume_slider.value = Music.load_volume()
    volume_slider.value_changed.connect(Music.apply_volume)

    Music.play()


func _on_new_game_button_pressed():
    GlobalManager.play_again()


func _on_exit_button_pressed():
    get_tree().quit()


func _on_toggle_button():
    print("toggle")
    if currently_selected_button == "new_game_button":
        print("A")
        currently_selected_button = "exit_button"
        exit_button.hover_on()
        new_game_button.hover_off()
        return

    if currently_selected_button == "exit_button":
        print("b")
        currently_selected_button = "new_game_button"
        exit_button.hover_off()
        new_game_button.hover_on()


func _press_current_button():
    if currently_selected_button == "new_game_button":
        new_game_button.pressed.emit()
    if currently_selected_button == "exit_button":
        exit_button.pressed.emit()


func _input(event):
    if event.is_action_pressed("ui_up"):
        _on_toggle_button()
    if event.is_action_pressed("ui_down"):
        _on_toggle_button()
    if event.is_action_pressed("ui_accept"):
        _press_current_button()
