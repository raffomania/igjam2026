extends Control

@onready var resume_button: TextureButton = $VBoxContainer/Resume
@onready var exit_button: TextureButton = $VBoxContainer/Exit


func _ready() -> void:
    print("ready to menu")
    resume_button.pressed.connect(resume_button_pressed)
    exit_button.pressed.connect(exit_button_pressed)

    hide()


func _input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_up"):
        _on_toggle_button()
    if event.is_action_pressed("ui_down"):
        _on_toggle_button()
    if event.is_action_pressed("Pause"):
        if get_tree().paused and not visible:
            return
        pause_menu_change()


func pause_menu_change():
    get_tree().paused = not get_tree().paused

    if get_tree().paused:
        show()
        print("Pause Menu open")
        resume_button.hover_on()
        currently_selected_button = "resume_button"

    else:
        hide()
        print("Pause Menu closed")


func resume_button_pressed() -> void:
    print("resume")
    pause_menu_change()


func exit_button_pressed() -> void:
    pause_menu_change()
    get_tree().quit()
    print("Exit")


var currently_selected_button = "resume_button"


func _on_exit_button_pressed():
    get_tree().quit()


func _on_toggle_button():
    if currently_selected_button == "resume_button":
        currently_selected_button = "exit_button"
        exit_button.hover_on()
        resume_button.hover_off()
        return

    if currently_selected_button == "exit_button":
        currently_selected_button = "resume_button_pressed"
        exit_button.hover_off()
        exit_button.hover_on()


func _press_current_button():
    if currently_selected_button == "resume_button":
        resume_button.pressed.emit()
    if currently_selected_button == "exit_button":
        exit_button.pressed.emit()
