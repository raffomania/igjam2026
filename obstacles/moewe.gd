extends MeshInstance3D


func _physics_process(delta: float) -> void:
    var next = global_position.rotated(Vector3.UP, 0.01 * delta)
    next.y = global_position.y
    global_position = next
    rotation.y = Basis.looking_at(next, Vector3.UP).get_euler().y
