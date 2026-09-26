extends Control

@onready var resume_button: Button = $VBoxContainer/Resume 
@onready var exit_button: Button = $VBoxContainer/Exit



func _ready() -> void:
    print("ready to menu")
    hide()



func _input(event: InputEvent) -> void:
    if event.is_action_pressed("Pause"):
        pause_menu_change()
        resume_button.pressed.connect(resume_button_pressed)
        exit_button.pressed.connect(exit_button_pressed)


func pause_menu_change():
    get_tree().paused = not get_tree().paused
    
    if get_tree().paused:
        show()
        print("Pause Menu open")

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
