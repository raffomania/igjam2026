extends Node

var total_game_length_seconds = 120
var start_drown_time_seconds = 60

var start_time #time when level started in millisecs
#TODO: show timer in ui
var dist_to_travel
var meters_to_sink
var time_to_sink
@onready var ground_generator := get_parent()


func _ready() -> void:
    start_time = Time.get_ticks_msec()
    meters_to_sink = abs(ground_generator.island_center_height - ground_generator.water_height)
    time_to_sink = abs(start_drown_time_seconds - total_game_length_seconds)


var should_print = true


func _process(delta):
    if abs(Time.get_ticks_msec() - start_time) / 1000 > start_drown_time_seconds:
        if should_print:
            print("sinking now")
            should_print = false
        var island_sinking_delta = meters_to_sink / time_to_sink * delta
        get_parent().position.y -= island_sinking_delta
        # print(abs(Time.get_ticks_msec() - start_time) / 1000)
