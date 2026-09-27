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
var max_speed: float = 0
var last_signal: float = 0
var signal_falling: bool = false


func _ready():
    # mouse_filter = Control.MOUSE_FILTER_IGNORE
    # if player:
    pause_button.pressed.connect(_on_pause_button_pressed)
    exit_button.pressed.connect(_on_exit_button_pressed)
    popup_button.pressed.connect(_popup_distances)


func _process(_delta: float) -> void:
    if GlobalManager.player_body.in_air:
        var current_dist = GlobalManager.player_body.calculate_distance(
            GlobalManager.player_body.position
        )
        var current_height = GlobalManager.player_body.calculate_height(
            GlobalManager.player_body.position[1]
        )
        if current_height > GlobalManager.player_body.last_height:
            GlobalManager.player_body.last_height = current_height
            GlobalManager.player_body.falling = false
        else:
            GlobalManager.player_body.falling = true
            # print(last_height, "maximum   ", max_height)
            if GlobalManager.player_body.last_height > GlobalManager.player_body.max_height:
                GlobalManager.player_body.max_height = GlobalManager.player_body.calculate_height(
                    GlobalManager.player_body.position[1]
                )
                text_to_show = "New Maximum Height!"
                _popup_distances(text_to_show)

        if current_dist > GlobalManager.player_body.last_distance:
            GlobalManager.player_body.last_distance = current_dist
        else:
            # print(last_distance, "	 max distance ",  max_distance)
            if GlobalManager.player_body.last_distance > GlobalManager.player_body.max_distance:
                GlobalManager.player_body.max_distance = GlobalManager.player_body.last_distance

                text_to_show = "New Maximum Distance!"
                _popup_distances(text_to_show)


func _popup_distances(text: String):
    var new_popup = popup_scene.instantiate()
    new_popup.show_time = display_time
    new_popup.text_to_show = text
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
