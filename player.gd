extends RigidBody3D

var input_direction = Vector3.ZERO


func process_air(delta: float) -> void:
    return


func process_ground(delta: float) -> void:
    return


func get_input_direction() -> void:
    if Input.is_action_pressed("move_right"):
        input_direction.x += 1
    if Input.is_action_pressed("move_left"):
        input_direction.x -= 1
    if Input.is_action_pressed("move_back"):
        input_direction.z += 1
    if Input.is_action_pressed("move_forward"):
        input_direction.z -= 1


func _process(delta: float) -> void:
    # TODO: Find out whether we are on ground
    process_ground(delta)
