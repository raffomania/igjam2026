extends RigidBody3D

var input_direction = Vector3.ZERO


func process_air(delta: float) -> void:
    var next_position = self.position - transform.basis.z
    $shrimp.look_at(next_position)
    # glide forward
    self.apply_central_force(-transform.basis.z * delta * 200)
    # reduce gravity
    self.apply_central_force(transform.basis.y * delta * 400)


func process_ground(_delta: float) -> void:
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


func _ready() -> void:
    self.apply_central_force(Vector3.FORWARD * 100)


func _physics_process(delta: float) -> void:
    # TODO: Find out whether we are on ground
    get_input_direction()
    process_air(delta)
    process_ground(delta)
