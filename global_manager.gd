extends Node

const MAIN_SCENE: PackedScene = preload("res://main.tscn")

var player_body: RigidBody3D
var player: Player
var game_end_camera: GameEndCameraHolder

signal game_end
signal game_start
signal score_changed(score: int)


func play_again() -> void:
    JuiceeStateStack.reset()

    get_tree().change_scene_to_packed(MAIN_SCENE)

    game_start.emit.call_deferred()
