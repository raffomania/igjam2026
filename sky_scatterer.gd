extends Node3D

@export var object_scenes: Array[PackedScene] # Das zu spawnende Objekt
@export var amount: int = 4000          # Anzahl der Objekte
@export var spread_x: float = 1000.0   # Streuung auf der X-Achse
@export var spread_z: float = 1000.0   # Streuung auf der Z-Achse
@export var min_height: float = -50.0 # Minimale Flughöhe Y
@export var max_height: float = 200.0 # Maximale Flughöhe Y
@export var scale_min: float = 1.0 # Minimale Flughöhe Y
@export var scale_max: float = 3.0 # Maximale Flughöhe Y

@export var redistribute_distance: float = 400
@export var redistribute_amount: float = 600
var furthest_scatter: float = Vector2(spread_x, spread_z).length() / 2.5

@onready var player: RigidBody3D = GlobalManager.player_body

func _ready() -> void:
    randomize()
    for i in range(amount):
        spawn_object_initial()
        
func _process(delta: float) -> void:
    
    var distance_from_origin := Vector2(
        player.global_position.x,
        player.global_position.z
    ).length()
    
    if distance_from_origin > furthest_scatter - redistribute_distance:
        furthest_scatter += redistribute_distance
        for i in range(redistribute_amount):
            spawn_object_redistribute()

func spawn_object_redistribute() -> void:
    var forward := Vector3(
        player.global_position.x,
        0.0,
        player.global_position.z
    ).normalized()

    var right := forward.cross(Vector3.UP).normalized()

    # The new strip starts at the current "edge"
    # and extends redistribute_distance forward.
    var near_distance := furthest_scatter
    var far_distance := furthest_scatter + redistribute_distance

    # Width of the spawning area.
    var half_width := redistribute_distance * 3.0

    var random_forward := randf_range(near_distance, far_distance)
    var random_side := randf_range(-half_width, half_width)

    var pos_xz := forward * random_forward + right * random_side

    var random_y := randf_range(min_height, max_height)

    spawn_object(Vector3(
        pos_xz.x,
        random_y,
        pos_xz.z
    ))

func spawn_object_initial() -> void:
    
    # Zufällige Position berechnen
    var random_x = randf_range(-spread_x, spread_x)
    var random_y = randf_range(min_height, max_height)
    var random_z = randf_range(-spread_z, spread_z)
    
    if abs(random_x)**2 + abs(random_z)**2 < 400**2:
        return
    
    spawn_object(Vector3(random_x, random_y, random_z))

func spawn_object(pos: Vector3) -> void:    
    var object_scene = object_scenes.pick_random()
    var instance = object_scene.instantiate()
    
    instance.position = pos
    
    # Optional: Zufällige Rotation und Skalierung für mehr Natürlichkeit
    instance.rotation = Vector3(randf_range(0, TAU), randf_range(0, TAU), randf_range(0, TAU))
    var scale_factor = randf_range(scale_min, scale_max)
    instance.scale = Vector3.ONE * scale_factor # bzw. instance.scale = Vector3.ONE * scale_factor
    
    add_child(instance)
