extends Control

func _ready() -> void:
    get_tree().paused = true
    show()

func _input(event):
    if get_tree().paused:
        if event.is_pressed():
            get_tree().paused = false
            get_viewport().set_input_as_handled()
            hide()
