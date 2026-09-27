extends Control

@onready var play_again: Button = $VBoxContainer/PlayAgain
@onready var score_label: Label = $VBoxContainer/Score


func _ready() -> void:
    GlobalManager.game_end.connect(_on_game_end)
    play_again.pressed.connect(_on_play_again_pressed)
    hide()


func _on_play_again_pressed() -> void:
    GlobalManager.play_again()


func _on_game_end():
    score_label.text = str(int(get_island_distance_score())) + "m"
    show()


func get_island_distance_score():
    var player_pos = GlobalManager.player_body.position
    var distance = Vector2(player_pos.x, player_pos.z).distance_to(Vector2.ZERO)
    return distance
