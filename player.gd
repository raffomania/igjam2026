extends Node3D

var input_direction = Vector3.ZERO

@onready var body: RigidBody3D = $body
@onready var mesh: Node3D = $"body/mesh"
var ground_speed := 4.0
@onready var camera_pivot := $CameraPivot
@onready var camera: Camera3D = $"CameraPivot/SpringArm3D/Camera3D"
@onready var camera_spring_arm: SpringArm3D = $"CameraPivot/SpringArm3D"

@onready var animation = mesh.get_node('AnimationPlayer')

var state: State = NotFlying.new():
    set(val):
        state = val
        if state is NotFlying:
            mesh.scale.x = 1
            body.set_flying(false)
            animation.play('RollUp')
        elif state is Flying:
            # mesh.scale.x = 3
            body.set_flying(true)
            animation.play('RollOut')
            animation.queue('Glide')


class State:
    pass


class Flying:
    extends State


class NotFlying:
    extends State

    var increase_gravity := false


func _ready() -> void:
    animation.play('RollUp')


func process_air(_delta: float) -> void:
    body.gravity_scale = 0.5


func process_not_flying(_delta: float, not_flying: NotFlying) -> void:
    if not_flying.increase_gravity:
        body.gravity_scale = 10.0
    else:
        body.gravity_scale = 1.0
    var movement = input_direction * ground_speed

    # Disable forward/backward movement when in gravity mode
    if not_flying.increase_gravity:
        movement.y = 0

    body.apply_central_force(camera_pivot.basis.z * movement.y)


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
        process_not_flying(delta, state)


func _process(delta: float) -> void:
    var direction := body.linear_velocity
    direction.y = 0.0

    if direction.length_squared() > 0.0:
        var target_quat = Basis \
                .looking_at(direction.normalized(), Vector3.UP) \
                .get_rotation_quaternion()

        var slerped_rotation = camera_pivot.basis.get_rotation_quaternion().slerp(
            target_quat,
            delta * 5.0,
        )

        camera_pivot.rotation.y = slerped_rotation.get_euler().y

    var speed = body.linear_velocity.length()
    var speed_factor = speed / (body.max_speed / 2)
    camera.fov = lerp(60.0, 110.0, speed_factor)
    camera_spring_arm.spring_length = lerp(4, 12, speed_factor)


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("reset"):
        body.do_reset_pos()
    if event.is_action_released("toggle_flying"):
        if state is Flying:
            state = NotFlying.new()
        else:
            state = Flying.new()

    if event.is_action_pressed("increase_gravity"):
        if state is not NotFlying:
            state = NotFlying.new()
        state.increase_gravity = true
    elif event.is_action_released("increase_gravity"):
        if state is NotFlying:
            state.increase_gravity = false
