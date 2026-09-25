extends Node3D

var input_direction = Vector3.ZERO

@onready var body := $body
@onready var mesh := $"body/mesh"
var ground_speed = 10
@onready var camera_pivot := $CameraPivot


func process_air(delta: float) -> void:
    var next_position = self.global_position + body.linear_velocity
    mesh.look_at(next_position)
    # glide forward
    body.apply_central_force(-mesh.transform.basis.z * delta * 200)
    # reduce gravity
    body.apply_central_force(Vector3.UP * delta * 400)


func process_ground(_delta: float) -> void:
    var movement = input_direction * ground_speed
    body.apply_central_force(Vector3(movement.x, 0, movement.y))
    return


func get_input_direction() -> void:
    input_direction = Input.get_vector("move_left", "move_right", "move_forward", "move_back")


func _physics_process(delta: float) -> void:
    # TODO: Find out whether we are on ground
    get_input_direction()
    camera_pivot.global_position = body.global_position
    mesh.global_position = body.global_position
    # process_air(delta)
    process_ground(delta)
