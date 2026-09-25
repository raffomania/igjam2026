extends RigidBody3D

var pitch_speed := 3.0
var roll_speed := 4.0
var thrust_power := 30.0
var angular_stop_speed := 10.0  # how fast rotation stops when no input
var alignment_speed := 3.0        # how fast velocity aligns to facing
var min_speed := 0.0              # base glide speed, even flying level
var max_speed := 60.0             # terminal velocity cap
var drag := 0.5                   # bleeds off excess speed over time
var dive_gain := 15.0             # how fast diving builds speed

var speed := 20.0

func _integrate_forces(state: PhysicsDirectBodyState3D):
    var pitch_input = Input.get_axis("move_forward", "move_back")
    var roll_input = Input.get_axis("move_left", "move_right")

    var desired_angular = (global_transform.basis.x * pitch_input * pitch_speed) + \
                           (-global_transform.basis.z * roll_input * roll_speed)


    # Snap toward desired angular velocity
    state.angular_velocity = state.angular_velocity.lerp(desired_angular, angular_stop_speed * state.step)

    # --- Speed evolves based on pitch relative to gravity ---
    var forward = -global_transform.basis.z
    var dive_factor = -forward.y   # positive when diving, negative when climbing
    speed += dive_factor * dive_gain * state.step
    speed -= drag * state.step      # constant bleed, stronger dives needed to keep speed up
    speed = clampf(speed, min_speed, max_speed)

    # align forward speed with nose direction
    var aligned_velocity = forward * speed
    state.linear_velocity = state.linear_velocity.lerp(aligned_velocity, alignment_speed * state.step)
