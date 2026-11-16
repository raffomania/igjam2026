extends Node3D

@export var object_scenes: Array[PackedScene] # Das zu spawnende Objekt
@export var initial_amount: int = 1000
@export var spread_x: float = 1000.0 # Streuung auf der X-Achse
@export var spread_z: float = 1000.0 # Streuung auf der Z-Achse
@export var min_height: float = -50.0 # Minimale Flughöhe Y
@export var max_height: float = 300.0 # Maximale Flughöhe Y
@export var scale_min: float = 1.0
@export var scale_max: float = 3.0

@export var redistribute_distance: float = 100
# average distance between spawned objects
@export var redistribute_object_gap: float = 80
# start redistributing at this distance from the island.
@export var redistribute_offset: float = 800
@export var redistribute_amount: float = 100
var furthest_scatter: float = 400 + redistribute_distance

@onready var player: RigidBody3D = GlobalManager.player_body

@export var max_objects: int = 3000

var spawned_objects: Array[Node3D] = []


func _ready() -> void:
    randomize()
    for i in range(initial_amount):
        spawn_object_initial()


func _process(_delta: float) -> void:
    var distance_from_origin
    # player is null in title screen
    if player != null:
        distance_from_origin = Vector2(player.global_position.x, player.global_position.z).length()
    else:
        distance_from_origin = 100000

    if distance_from_origin > furthest_scatter - redistribute_offset:
        for i in range(redistribute_amount):
            spawn_object_redistribute()
        furthest_scatter += redistribute_distance


func spawn_object_redistribute() -> void:
    var forward: Vector3
    # player is null in title screen
    if player != null:
        forward = Vector3(player.global_position.x, 0.0, player.global_position.z).normalized()
    else:
        return

    # The new strip starts at the current "edge"
    # and extends redistribute_distance forward.
    var near_distance := furthest_scatter
    var far_distance := furthest_scatter + redistribute_distance
    var random_forward := randf_range(near_distance, far_distance)

    # calculate the angle we need to reach the object density we want
    # start by calculating how much area we'd have if we spawned around the whole circle
    var height_range = (max_height - min_height)
    var area_of_whole_strip = (PI * (far_distance ** 2)) - (PI * (near_distance ** 2))
    area_of_whole_strip *= height_range
    # then calc how much of that area we can cover with the objects we're spawning and the density we want
    var area_per_object = redistribute_object_gap ** 3
    var area_to_cover = redistribute_amount * area_per_object
    # translate that to an angle
    var available_angle = PI * 2 * (area_to_cover / area_of_whole_strip)
    var random_angle = randf_range(-available_angle / 2, available_angle / 2)

    var pos_xz := (forward * random_forward).rotated(Vector3.UP, random_angle)

    var random_y := randf_range(min_height, max_height)

    spawn_object(Vector3(pos_xz.x, random_y, pos_xz.z))


func spawn_object_initial() -> void:
    # Zufällige Position berechnen
    var random_y = randf_range(min_height, max_height)
    var random_distance = randf_range(400, redistribute_offset)
    var random_angle = randf_range(0, PI * 2)

    var spawn_position = Vector3.FORWARD.rotated(Vector3.UP, random_angle) * random_distance
    spawn_position.y = random_y

    spawn_object(spawn_position)


func spawn_object(pos: Vector3) -> void:
    var object_scene = object_scenes.pick_random()
    var instance = object_scene.instantiate()

    instance.position = pos

    # Optional: Zufällige Rotation und Skalierung für mehr Natürlichkeit
    instance.rotation = Vector3(randf_range(0, TAU), randf_range(0, TAU), randf_range(0, TAU))
    var scale_factor = randf_range(scale_min, scale_max)
    instance.scale *= scale_factor # bzw. instance.scale = Vector3.ONE * scale_factor

    set_cast_shadow(instance, GeometryInstance3D.SHADOW_CASTING_SETTING_OFF)

    add_child(instance)

    spawned_objects.push_back(instance)

    if spawned_objects.size() > max_objects:
        var oldest = spawned_objects.pop_front()
        if is_instance_valid(oldest):
            oldest.queue_free()


func set_cast_shadow(node: Node, mode: GeometryInstance3D.ShadowCastingSetting) -> void:
    if node is GeometryInstance3D:
        node.cast_shadow = mode
    for child in node.get_children():
        set_cast_shadow(child, mode)
