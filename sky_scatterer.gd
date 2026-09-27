extends Node3D

@export var object_scenes: Array[PackedScene] # Das zu spawnende Objekt
@export var amount: int = 4000          # Anzahl der Objekte
@export var spread_x: float = 1000.0   # Streuung auf der X-Achse
@export var spread_z: float = 1000.0   # Streuung auf der Z-Achse
@export var min_height: float = -50.0 # Minimale Flughöhe Y
@export var max_height: float = 200.0 # Maximale Flughöhe Y
@export var scale_min: float = 1.0 # Minimale Flughöhe Y
@export var scale_max: float = 3.0 # Maximale Flughöhe Y

func _ready() -> void:
    randomize()
    for i in range(amount):
        spawn_object()

func spawn_object() -> void:
    
    # Zufällige Position berechnen
    var random_x = randf_range(-spread_x, spread_x)
    var random_y = randf_range(min_height, max_height)
    var random_z = randf_range(-spread_z, spread_z)
    
    if abs(random_x)**2 + abs(random_z)**2 < 400**2:
        return
    
    var object_scene = object_scenes.pick_random()
    var instance = object_scene.instantiate()
    
    instance.position = Vector3(random_x, random_y, random_z)
    
    # Optional: Zufällige Rotation und Skalierung für mehr Natürlichkeit
    instance.rotation = Vector3(randf_range(0, TAU), randf_range(0, TAU), randf_range(0, TAU))
    var scale_factor = randf_range(scale_min, scale_max)
    instance.scale = Vector3.ONE * scale_factor # bzw. instance.scale = Vector3.ONE * scale_factor
    
    add_child(instance)
