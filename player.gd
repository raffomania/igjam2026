class_name Player extends Node3D

signal level_increased(level)

var input_direction = Vector3.ZERO

@onready var body: RigidBody3D = $body
@onready var mesh: Node3D = $"body/mesh"
@onready var camera_pivot := $CameraPivot
@onready var camera: Camera3D = $"CameraPivot/SpringArm3D/Camera3D"
@onready var camera_spring_arm: SpringArm3D = $"CameraPivot/SpringArm3D"
@onready var ground_generator := get_node("../GroundGenerator")
@onready var trick_cooldown_timer: Timer = Timer.new()
@onready var trick_particles: CPUParticles3D = $"CameraPivot/SpringArm3D/Camera3D/TrickParticles"

@onready var animation = mesh.get_node('AnimationPlayer')

@onready var initial_camera_pivot_rotation = camera_pivot.rotation

signal trick_hint(text: String)

const not_flying_camera_pivot_angle := -25.0

const ground_speed := 16.0
var gravity_bonus := 7.0
var gravity_scale_override := 1.0
const trick_threshold_speed = 25
const trick_threshold_up_speed = 40
const trick_threshold_charge_time = 3.0
const trick_threshold_y_travel = 10.0
const trick_threshold_height = 2
const trick_cooldown_secs = 1.5
var level = 1

# when starting to roll up a hill, disable gravity boost for a short time
var previous_linear_velocity := Vector3.ZERO
var disable_active_gravity_boost_secs := 0.0

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

    var increase_gravity := Input.is_action_pressed("increase_gravity")
    # how long the player has pressed the gravity increase button,
    # they can only do tricks after pressing it for a minimum time
    var trick_charge_time := 0.0
    var trick_y_start = null


    func trick_y_travel(body: PhysicsBody3D) -> float:
        if trick_y_start == null:
            return 0.0
        return body.global_position.y - trick_y_start


func _ready() -> void:
    animation.play('RollUp')
    GlobalManager.player_body = $body
    GlobalManager.player = self
    GlobalManager.game_end.connect(_on_game_end)
    animation.set_blend_time('RollUp', 'Trick1', 0.3)
    animation.set_blend_time('RollUp', 'Trick2', 0.3)
    animation.set_blend_time('RollUp', 'Trick3', 0.3)
    trick_cooldown_timer.wait_time = trick_cooldown_secs
    trick_cooldown_timer.one_shot = true
    add_child(trick_cooldown_timer)

    body.body_entered.connect(_body_entered)


func _body_entered(_other: Node3D):
    if state is Flying:
        state = NotFlying.new()

    # Once the player touches the ground, start measuring how steep the
    # hill they're rolling down is
    if state.increase_gravity and state.trick_y_start == null:
        state.trick_y_start = body.global_position.y


func get_height_above_ground() -> float:
    var ground_height = ground_generator.calculate_ground_height(
        body.global_position.x,
        body.global_position.z,
    )
    return body.global_position.y - ground_height


func process_flying(_delta: float) -> void:
    body.gravity_scale = 1.0


func random_trick(speed_boost_force := 20) -> void:
    if state is NotFlying:
        state.trick_y_start = null
    var quality = trick_timing_quality()
    match quality:
        TrickQuality.OK:
            trick_hint.emit('OK')
        TrickQuality.GOOD:
            trick_hint.emit('Good')
        TrickQuality.PERFECT:
            trick_hint.emit('Perfect!', true)
    var intensity = (level - 10) / 10.0
    Juicee.chromatic(self, intensity * 50, 1.0)

    body.apply_central_impulse(body.linear_velocity.normalized() * speed_boost_force)
    level += 1
    level_increased.emit(level)
    trick_cooldown_timer.start()
    trick_particles.emitting = true
    gravity_scale_override = 0.5
    await get_tree().create_timer(0.7).timeout
    gravity_scale_override = 1.0
    var trick = ['Trick1', 'Trick2', 'Trick3'].pick_random()
    print('performing ', trick)
    body.do_reset_angular_velocity()
    animation.queue(trick)
    animation.queue('RollUp')


func process_not_flying(delta: float, not_flying: NotFlying) -> void:
    # If the player just started rolling up a hill, disable gravity boost
    # for a short time even if they are still pressing the button.
    # This forgives short timing mistakes
    var changed_from_down_to_up_movement = (
        previous_linear_velocity.y <= 0.0 and body.linear_velocity.y > 0.0
    )
    if changed_from_down_to_up_movement:
        disable_active_gravity_boost_secs = 0.2

    previous_linear_velocity = body.linear_velocity
    disable_active_gravity_boost_secs -= delta

    if not_flying.increase_gravity and disable_active_gravity_boost_secs <= 0.0:
        body.gravity_scale = gravity_bonus + level
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
        process_flying(delta)
    elif state is NotFlying:
        process_not_flying(delta, state)


func _process(delta: float) -> void:
    if state is NotFlying:
        look_into_movement_direction(delta)
        state.trick_charge_time += delta
    elif state is Flying:
        look_into_nose_direction(delta)

    process_speed_fx()


func process_speed_fx() -> void:
    var speed = body.linear_velocity.length()
    var speed_factor = clamp(speed / (body.max_speed / 2), 0.0, 1.0)
    camera.fov = lerp(60.0, 110.0, speed_factor)
    camera_spring_arm.spring_length = lerp(6, 12, speed_factor)


func look_into_movement_direction(delta):
    var direction := body.linear_velocity
    direction.y = 0.0
    direction = direction.normalized()

    if direction.length_squared() > 0.0:
        var target_quat = Basis \
                .looking_at(direction, Vector3.UP) \
                .rotated(direction.rotated(Vector3.UP, PI / 2), not_flying_camera_pivot_angle) \
                .get_rotation_quaternion()

        var slerped_rotation = camera_pivot.basis.get_rotation_quaternion().slerp(
            target_quat,
            delta * 5.0,
        )

        camera_pivot.rotation = slerped_rotation.get_euler()


func look_into_nose_direction(delta):
    var direction := -body.global_transform.basis.z.normalized()

    if direction.length_squared() > 0.0:
        var target_quat = Basis \
                .looking_at(direction, Vector3.UP) \
                .get_rotation_quaternion()

        var slerped_rotation = camera_pivot.basis.get_rotation_quaternion().slerp(
            target_quat,
            delta * 2.0,
        )

        camera_pivot.rotation = slerped_rotation.get_euler()


func is_flight_allowed():
    return level >= 3


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("reset"):
        body.do_reset_pos()
    if event.is_action_released("toggle_flying"): #block if not enough momentum
        if state is not Flying and is_flight_allowed():
            state = Flying.new()
        else:
            state = NotFlying.new()

    if event.is_action_pressed("increase_gravity"):
        if state is NotFlying:
            state.increase_gravity = true
    elif event.is_action_released("increase_gravity"):
        if state is NotFlying:
            state.increase_gravity = false
            handle_trick()

    if event.is_action_pressed("cheat_add_gravity_boost"):
        level += 10
        level_increased.emit(level)
        Juicee.shockwave(self, 0.6, 0.045)


func _on_game_end():
    if is_instance_valid(camera):
        camera.reparent(GlobalManager.game_end_camera)


func handle_trick() -> void:
    var no_cooldown = trick_cooldown_timer.time_left <= 0.0
    var dive_long_enough = (
        state is NotFlying and state.trick_charge_time >= trick_threshold_charge_time
    )
    var close_to_ground = get_height_above_ground() < trick_threshold_height
    var enough_y_travel = (
        state is NotFlying and abs(state.trick_y_travel(body)) > trick_threshold_y_travel
    )
    if close_to_ground and dive_long_enough and no_cooldown and enough_y_travel:
        var velocity = body.linear_velocity
        var speed = velocity.length()
        print('height ', get_height_above_ground())
        if speed > trick_threshold_speed:
            if (abs(velocity.y) < trick_threshold_up_speed):
                print('Doing trick! Speed: ', speed, ' Upspeed: ', velocity.y)
                random_trick()
            elif (sign(velocity.y) == -1):
                # player is moving downwards
                level -= 1
                level = max(1, level)
                level_increased.emit(level)
                print('Trick timing not good enough! Speed: ', speed, ' Upspeed: ', velocity.y)
                trick_hint.emit('Released too early!')
            else:
                # player is moving upwards
                level -= 1
                level = max(1, level)
                level_increased.emit(level)
                print('Trick timing not good enough! Speed: ', speed, ' Upspeed: ', velocity.y)
                trick_hint.emit('Released too late!')
        else:
            print('too slow, speed: ', speed)
            trick_hint.emit('Too slow!')
    elif not dive_long_enough:
        trick_hint.emit("Dive too short!")
    elif not no_cooldown:
        trick_hint.emit("Trick on cooldown!")
    elif not close_to_ground:
        trick_hint.emit("Not on ground!")
    elif not enough_y_travel:
        trick_hint.emit("Jumped too flat!")


enum TrickQuality {
    OK,
    GOOD,
    PERFECT,
}


func trick_timing_quality() -> TrickQuality:
    var up_velocity = abs(body.linear_velocity.y)
    if up_velocity < (trick_threshold_up_speed * .3):
        return TrickQuality.PERFECT
    elif up_velocity < (trick_threshold_up_speed * .6):
        return TrickQuality.GOOD
    else:
        return TrickQuality.OK
