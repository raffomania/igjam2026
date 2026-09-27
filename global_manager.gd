extends Node

var player_body: RigidBody3D
var player: Player
var game_end_camera: GameEndCameraHolder

signal game_end
signal game_start
signal score_changed(score)



func play_again():
    JuiceeStateStack.reset()
    game_start.emit()
    get_tree().reload_current_scene()
