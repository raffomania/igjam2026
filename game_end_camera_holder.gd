class_name GameEndCameraHolder extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    GlobalManager.game_end_camera = self

func _process(delta: float) -> void:
    if get_node("Camera3D"):
        $Camera3D.position += (0.2 * $Camera3D.transform.basis.y + $Camera3D.transform.basis.z) * 2.0 * delta
