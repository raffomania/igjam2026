extends Node3D

var input_direction = Vector3.ZERO

@onready
var body := $RigidBody3D
@onready
var shrimp := $"RigidBody3D/shrimp"


func process_air(delta: float) -> void:
    var next_position = self.global_position - transform.basis.z
    shrimp.look_at(next_position)
    # glide forward
    body.apply_central_force(-transform.basis.z * delta * 200)
    # reduce gravity
    body.apply_central_force(transform.basis.y * delta * 300)


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


func _physics_process(delta: float) -> void:
    # TODO: Find out whether we are on ground
    get_input_direction()
    $CameraPivot.global_position = body.global_position
    # process_air(delta)
    process_ground(delta)
