class_name GameEndCameraHolder extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    GlobalManager.game_end_camera = self

func _process(delta: float) -> void:
    var camera = get_node_or_null("Camera3D")
    if camera:
        camera.position += (0.2 * camera.transform.basis.y + camera.transform.basis.z) * 2.0 * delta
