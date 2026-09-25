extends Node3D

var input_direction = Vector3.ZERO

@onready var body := $body
@onready var mesh := $"body/mesh"
var ground_speed = 10
@onready var camera_pivot := $CameraPivot
var flying := false

var fly_thrust := 200.0
var fly_lift_coefficient := 0.3
var fly_drag_coefficient = 0.02


func process_air(delta: float) -> void:
    pass

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
    if flying:
        process_air(delta)
    else:
        process_ground(delta)

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_released("toggle_flying"):
        flying = !flying
        if flying:
            body.apply_central_force(-body.transform.basis.z * 100)
            # body.angular_damp = 2.0
            mesh.scale.x = 2
        else:
            # body.angular_damp = 0.0
            mesh.scale.x = 1
