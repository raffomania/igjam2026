class_name Water extends Node3D


signal water_hit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    $MeshInstance3D/WaterArea.connect("body_entered",func (_b): GlobalManager.game_end.emit())
