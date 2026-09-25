extends Node3D

var input_direction = Vector3.ZERO

@onready var body := $RigidBody3D
@onready var shrimp := $"RigidBody3D/shrimp"
var ground_speed = 10


func process_air(delta: float) -> void:
    var next_position = self.global_position - transform.basis.z
    shrimp.look_at(next_position)
    # glide forward
    body.apply_central_force(-transform.basis.z * delta * 200)
    # reduce gravity
    body.apply_central_force(transform.basis.y * delta * 300)


func process_ground(_delta: float) -> void:
    print(input_direction.y)
    var movement = input_direction * ground_speed
    body.apply_central_force(Vector3(movement.x, 0, movement.y))
    return


func get_input_direction() -> void:
    input_direction = Input.get_vector("move_left", "move_right", "move_forward", "move_back")


func _physics_process(delta: float) -> void:
    # TODO: Find out whether we are on ground
    get_input_direction()
    $CameraPivot.global_position = body.global_position
    # process_air(delta)
    process_ground(delta)
