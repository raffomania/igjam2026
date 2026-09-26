extends Node3D

var input_direction = Vector3.ZERO

@onready var body := $body
@onready var mesh := $"body/mesh"
var ground_speed = 10
@onready var camera_pivot := $CameraPivot
@onready var camera := $"CameraPivot/SpringArm3D/Camera3D"

var state: State = NotFlying.new():
    set(val):
        state = val
        if state is NotFlying:
            mesh.scale.x = 1
            body.set_flying(false)
        elif state is Flying:
            mesh.scale.x = 3
            body.set_flying(true)


class State:
    pass


class Flying:
    extends State


class NotFlying:
    extends State

    var increase_gravity := false


func process_air(_delta: float) -> void:
    body.gravity_scale = 0.5


func process_ground(_delta: float, state: NotFlying) -> void:
    if state.increase_gravity:
        body.gravity_scale = 10.0
    else:
        body.gravity_scale = 1.0
    var movement = input_direction * ground_speed

    # Disable forward/backward movement when in gravity mode
    if state.increase_gravity:
        movement.y = 0

    body.apply_central_force(Vector3(movement.x, 0, movement.y))

    if mesh.global_position != camera.global_position:
        mesh.look_at(camera.global_position)
        mesh.rotate_x(PI)


func get_input_direction() -> void:
    input_direction = Input.get_vector("move_left", "move_right", "move_forward", "move_back")


func _physics_process(delta: float) -> void:
    # TODO: Find out whether we are on ground
    get_input_direction()
    camera_pivot.global_position = body.global_position
    mesh.global_position = body.global_position
    if state is Flying:
        process_air(delta)
    elif state is NotFlying:
        process_ground(delta, state)


func _unhandled_input(event: InputEvent) -> void:
    var animation = mesh.get_node('AnimationPlayer')
    if event.is_action_released("toggle_flying"):
        if state is Flying:
            state = NotFlying.new()
            animation.play('RollUp')
        else:
            state = Flying.new()
            animation.play('Glide')

    if event.is_action_pressed("increase_gravity"):
        if state is not NotFlying:
            state = NotFlying.new()
        state.increase_gravity = true
    elif event.is_action_released("increase_gravity"):
        if state is NotFlying:
            state.increase_gravity = false
