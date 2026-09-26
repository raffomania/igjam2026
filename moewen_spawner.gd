extends Node

var moewe_scene = preload("res://obstacles/Moewe.tscn")

const spawn_count = 10


func _ready() -> void:
    for i in range(0, spawn_count):
        var distance = randi_range(600, 1000)
        var height = randi_range(10, 100)
        var pos = Vector3(0, height, distance).rotated(Vector3.UP, PI * 2 * i / spawn_count)
        spawn_object(pos, moewe_scene)


func spawn_object(position, scene):
    var spawned = scene.instantiate()
    spawned.set_position(position)
    add_child(spawned)
    # print("lol", coordinates)
