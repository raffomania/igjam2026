extends Control


func _ready() -> void:
    get_tree().paused = true
    show()


func _input(event):
    if not visible:
        return
    if get_tree().paused and event.is_pressed() and not event.is_echo():

        get_tree().paused = false
        hide()
        get_viewport().set_input_as_handled()
