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
@export var redistribute_amount: float = 400
var furthest_scatter: float = spread_x

@onready var player: RigidBody3D = GlobalManager.player_body

func _ready() -> void:
    randomize()
    for i in range(amount):
        spawn_object_initial()
        
func _process(delta: float) -> void:
    if player.global_position.length() > furthest_scatter - redistribute_distance:
        furthest_scatter += redistribute_distance
        for i in range(redistribute_amount):
            spawn_object_redistribute()

func spawn_object_redistribute() -> void:
    
    var cross = player.global_position.normalized().cross(Vector3.UP)
    var far = player.global_position + player.global_position.normalized() * 2 * redistribute_distance + cross * 2 * redistribute_distance
    var close = player.global_position + player.global_position.normalized() * 1 * redistribute_distance - cross * 2 * redistribute_distance
    
    var min_x = min(far.x, close.x)
    var max_x = max(far.x, close.x)
    var min_z = min(far.z, close.z)
    var max_z = max(far.z, close.z)
    
    # Zufällige Position berechnen
    var random_x = randf_range(min_x, max_x)
    var random_y = randf_range(min_height, max_height)
    var random_z = randf_range(min_z, max_z)
    
    spawn_object(Vector3(random_x, random_y, random_z))

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
