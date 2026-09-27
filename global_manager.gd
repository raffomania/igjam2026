extends Node

var player_body: RigidBody3D
var player: Player
var game_end_camera: GameEndCameraHolder

signal game_end


func play_again():
    #TODO: fix bug where reloaded game has no momentum, maybe timer related?
    get_tree().reload_current_scene()
