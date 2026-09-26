extends Control

signal exit
signal pause

@export var display_time = 1
@export var text_to_show = "Popup text"


@onready var exit_button = $PanelContainer/VBoxContainer/ExitButton
@onready var pause_button = $PanelContainer/VBoxContainer/PauseButton

@onready var popup_button = $PanelContainer/VBoxContainer/ShowPopUp

# @onready var level_bar = $PanelContainer/VBoxContainer/LevelBar

@onready var popup_scene = load("res://PopUp_Scene.tscn")
var max_speed :float = 0
var last_signal :float = 0
var signal_falling :bool =false 


func _ready():
   # mouse_filter = Control.MOUSE_FILTER_IGNORE
    # if player:
    print("Ready for hud")
    pause_button.pressed.connect(_on_pause_button_pressed)
    exit_button.pressed.connect(_on_exit_button_pressed)
    popup_button.pressed.connect(_on_popup_button_pressed)


func _process(_delta: float) -> void:
    print(GlobalManager.player_body.linear_velocity)
    # _speed_tracker()


# func _speed_tracker():
#
#     print("Speed tracker")
#     if player.speed > max_speed:
#         signal_falling = false



# func _init():

    

func _on_popup_button_pressed():
    var new_popup = popup_scene.instantiate()
    new_popup.show_time = display_time
    new_popup.text_to_show = text_to_show
    add_child(new_popup)


func _on_exit_button_pressed():
    print("Exit")


func _on_pause_button_pressed():
    print("Pause")




    #needs signal that trick was done 
#	  trick_popUp.achieved.connect(_on_trick_popup)
#
# func _on_trick_popup(trick):
#	   %PopupTrick.popup()
#
# func _on_hide_trick_popup(trick):
#	   %PopupTrick.hide()
