extends RigidBody3D

const pitch_speed := 1.0
const roll_speed := 2.0
const angular_stop_speed := 10.0 # how fast rotation stops when no input
const alignment_speed := 3.0 # how fast velocity aligns to facing
const min_speed := 0.0 # base glide speed, even flying level
const max_speed := 80.0 # increasing this can cause clipping through ground
const drag := 0.0 # bleeds off excess speed over time
const dive_gain := 55.0 # how fast diving builds speed

var speed := 20.0
var flying := false

var forward_rotation = Quaternion.IDENTITY
var lerp_to_forward_rotation := false


func _integrate_forces(state: PhysicsDirectBodyState3D):
    if state.linear_velocity.length() > max_speed:
        var capped_velocity = state.linear_velocity.normalized() * max_speed
        state.linear_velocity = state.linear_velocity.lerp(capped_velocity, state.step * 20)

    if !flying:
        return

    if lerp_to_forward_rotation:
        state.angular_velocity = Vector3.ZERO
        var current_rotation = global_transform.basis.get_rotation_quaternion()
        global_transform.basis = Basis(
            current_rotation.slerp(Quaternion.IDENTITY, state.step * 10.0)
        )
        var dot = abs(current_rotation.dot(forward_rotation))
        # 1.0: both quaternions point in the same direction
        if dot > 0.999:
            # lerp to forward complete
            lerp_to_forward_rotation = false
        else:
            return

    var pitch_input = Input.get_axis("move_forward", "move_back")
    var roll_input = Input.get_axis("move_left", "move_right")

    var desired_angular = (global_transform.basis.x * pitch_input * pitch_speed) + \
            (-global_transform.basis.z * roll_input * roll_speed)

    # Snap toward desired angular velocity
    state.angular_velocity = state.angular_velocity.lerp(
        desired_angular,
        angular_stop_speed * state.step,
    )

    # --- Speed evolves based on pitch relative to gravity ---
    var forward = -global_transform.basis.z
    var dive_factor = -forward.y # positive when diving, negative when climbing
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
