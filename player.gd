extends Node3D

var input_direction = Vector3.ZERO

@onready var body := $body
@onready var mesh := $"body/mesh"
var ground_speed = 10
@onready var camera_pivot := $CameraPivot
var flying_mode := false


func process_air(delta: float) -> void:
    # glide forward
    body.apply_central_force(-body.transform.basis.z * delta * 400)
    # reduce gravity
    body.apply_central_force(Vector3.UP * delta * 400)
    var up_rotation = input_direction.y
    if up_rotation >= 0.0:
        var max_x_basis = Vector3.UP
        var distance_from_max_x_basis = max_x_basis.angle_to(-body.transform.basis.z)
        print(distance_from_max_x_basis)
        body.apply_torque(Vector3.RIGHT * delta * up_rotation * distance_from_max_x_basis * 5)


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
    process_air(delta)
    # process_ground(delta)

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_released("toggle_flying"):
        flying_mode = !flying_mode
        if flying_mode:
            mesh.scale.x = 2
        else:
            mesh.scale.x = 1
