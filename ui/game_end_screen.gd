extends Control

@onready var play_again: Button = $VBoxContainer/PlayAgain
@onready var score_label: Label = $VBoxContainer/Score
@onready var distance_label: Label = $VBoxContainer/Distance
@onready var combo_label: Label = $VBoxContainer/Combo
@onready var highscore_label: Label = $VBoxContainer/HighScore

var curr_score := 0

func _ready() -> void:
    GlobalManager.game_end.connect(_on_game_end)
    GlobalManager.score_changed.connect(_on_score_changed)
    play_again.pressed.connect(_on_play_again_pressed)
    hide()


func _on_play_again_pressed() -> void:
    GlobalManager.play_again()

func _on_score_changed(score: int):
    curr_score = score

func _on_game_end():
    var current_dist_score = curr_score
    var current_multi = GlobalManager.player.level
    var total = current_dist_score * current_multi
    var highscore = load_highscore()

    if total > highscore:
        save_highscore(total)
        highscore = total

    distance_label.text = "Maximum Distance: " + str(current_dist_score) + "m"
    combo_label.text = "Combo Multi: x" + str(current_multi)
    score_label.text = "Total Score: " + str(total)
    highscore_label.text = "High Score: " + str(highscore)
    show()


const SAVE_PATH = "user://highscore.bin"


func save_highscore(highscore: int) -> void:
    var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
    if file:
        file.store_64(highscore)
    else:
        push_warning("Couldn't save highscore file: ", error_string(FileAccess.get_open_error()))


func load_highscore() -> int:
    var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
    if file:
        return file.get_64()
    else:
        push_warning("Couldn't load highscore file: ", error_string(FileAccess.get_open_error()))
        return -1
