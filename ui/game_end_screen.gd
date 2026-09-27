extends Control

@onready var play_again: Button = $VBoxContainer/PlayAgain
@onready var score_label: Label = $VBoxContainer/Score
@onready var highscore_label: Label = $VBoxContainer/HighScore


func _ready() -> void:
    GlobalManager.game_end.connect(_on_game_end)
    play_again.pressed.connect(_on_play_again_pressed)
    hide()


func _on_play_again_pressed() -> void:
    GlobalManager.play_again()


func _on_game_end():
    var current_dist_score = int(get_island_distance_score())
    var highscore = load_highscore()

    if current_dist_score > highscore:
        save_highscore(current_dist_score)
        highscore = current_dist_score

    score_label.text = "Distance Score: " + str(current_dist_score) + "m"
    highscore_label.text = "High Score: " + str(highscore) + "m"
    show()


func get_island_distance_score():
    var player_pos = GlobalManager.player_body.position
    var distance = Vector2(player_pos.x, player_pos.z).distance_to(Vector2.ZERO)
    return distance


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
