extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    GlobalManager.game_end.connect(_on_game_end)


func _on_game_end() -> void:
    $GameEndScreen.show()
