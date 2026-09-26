extends Control

var text_to_show : String = "PopUp text"
var show_time : float = 0.1
@onready var timer = %Timer

func _ready():
    $PanelContainer/Label.text = text_to_show
    timer.start(show_time)

func _on_Timer_timeout():
    queue_free()
    

