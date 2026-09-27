extends Control

@onready var label: Label = $MarginContainer/VBoxContainer/Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var score := 0
var game_ended := false

func _ready() -> void:
    label.text = ""
    GlobalManager.game_end.connect(_on_game_end)
    GlobalManager.game_start.connect(_on_game_start)
    
    
func _process(delta: float) -> void:
    if !game_ended:
        var player_pos = GlobalManager.player_body.position
        var distance = Vector2(player_pos.x, player_pos.z).distance_to(Vector2.ZERO)
        score = max(score, distance)
        GlobalManager.score_changed.emit(score)
        label.text = "maximum distance: %sm" % score
        
func _on_game_end() -> void:
    game_ended = true
        
func _on_game_start() -> void:
    game_ended = false
    score = 0
