extends RigidBody3D

const pitch_speed := 1.5
const yaw_speed := 2.5
const angular_stop_speed := 10.0 # how fast rotation stops when no input
const alignment_speed := 3.0 # how fast velocity aligns to facing
const min_speed := 0.0 # base glide speed, even flying level
const max_speed := 200.0 # increasing this can cause clipping through ground
const drag := 0.0 # bleeds off excess speed over time
const dive_gain := 45.0 # how fast diving builds speed
@onready var reset_pos = global_position
@onready var camera := $"../CameraPivot/SpringArm3D/Camera3D"

var speed := 0.0
var flying := false
var reset = false

var lerp_to_forward_rotation := false


func do_reset_pos() -> void:
    reset = true


func _integrate_forces(state: PhysicsDirectBodyState3D):
    if state.get_contact_count() > 0:
        speed *= 0.8

    if reset:
        state.transform.origin = reset_pos
        # Call reset_physics_interpolation() at the end of the frame once the physics engine has been updated
        reset_physics_interpolation.call_deferred()
        reset = false

    if state.linear_velocity.length() > max_speed:
        var capped_velocity = state.linear_velocity.normalized() * max_speed
        state.linear_velocity = state.linear_velocity.lerp(capped_velocity, state.step * 20)

    if flying:
        integrate_forces_flying(state)
    else:
        integrate_forces_not_flying(state)


func integrate_forces_not_flying(state: PhysicsDirectBodyState3D):
    var turn_input = Input.get_axis("move_left", "move_right")
    var target_velocity = state.linear_velocity.rotated(Vector3.UP, -turn_input * PI / 4)
    state.linear_velocity = state.linear_velocity.slerp(target_velocity, state.step * 2)


func integrate_forces_flying(state: PhysicsDirectBodyState3D):
    if lerp_to_forward_rotation:
        state.angular_velocity = Vector3.ZERO
        var current_rotation = global_transform.basis.get_rotation_quaternion()
        var direction = camera.global_position - global_position
        direction.y = 0.0
        direction *= -1

        var target_quat = Basis \
                .looking_at(direction.normalized(), Vector3.UP) \
                .get_rotation_quaternion()

        global_transform.basis = Basis(current_rotation.slerp(target_quat, state.step * 10.0))
        var dot = abs(current_rotation.dot(target_quat))
        # 1.0: both quaternions point in the same direction
        if dot > 0.999:
            # lerp to forward complete
            lerp_to_forward_rotation = false
        else:
            return

    var pitch_input = Input.get_axis("move_forward", "move_back")
    var yaw_input = Input.get_axis("move_left", "move_right")

    var desired_angular = (global_transform.basis.x * pitch_input * pitch_speed) + \
            (Vector3.UP * yaw_input * -yaw_speed)

    # Snap toward desired angular velocity
    state.angular_velocity = state.angular_velocity.lerp(
        desired_angular,
        angular_stop_speed * state.step,
    )

    # --- Speed evolves based on pitch relative to gravity ---
    var forward = -global_transform.basis.z
    var dive_factor = -forward.y # positive when diving, negative when climbing
    if state.get_contact_count() > 0:
        dive_factor = 0.0
    speed += dive_factor * dive_gain * state.step
    speed -= drag * state.step # constant bleed, stronger dives needed to keep speed up
    speed = clampf(speed, min_speed, max_speed)

    # align forward speed with nose direction
    var aligned_velocity = forward * speed
    state.linear_velocity = state.linear_velocity.lerp(
        aligned_velocity,
        alignment_speed * state.step,
    )


func set_flying(new_val: bool):
    flying = new_val

    if flying:
        lerp_to_forward_rotation = true
        physics_material_override.friction = 0.5
        speed = linear_velocity.length() * 1.1
    else:
        physics_material_override.friction = 0.1
