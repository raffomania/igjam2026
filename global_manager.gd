extends Node

const MAIN_SCENE: PackedScene = preload("res://main.tscn")

var player_body: RigidBody3D
var player: Player
var game_end_camera: GameEndCameraHolder
var game_has_ended: bool

signal game_end
signal game_start
signal score_changed(score: int)

func _ready() -> void:
    game_end.connect(_on_game_ended)

func play_again() -> void:
    JuiceeStateStack.reset()
    game_has_ended = false

    get_tree().change_scene_to_packed(MAIN_SCENE)

    game_start.emit.call_deferred()


func _on_game_ended():
    game_has_ended = true
