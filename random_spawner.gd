extends Node

@onready var ground_generator := get_parent()

var num_shovels = 20

var preloaded_shovel_blue = preload("res://assets/separated/ShovelBlue.tscn")
var preloaded_shovel_green = preload("res://assets/separated/ShovelGreen.tscn")
var preloaded_shovel_red = preload("res://assets/separated/ShovelRed.tscn")
var preloaded_sand_castle = preload("res://assets/separated/SandCastle.tscn")
var preloaded_water_ball = preload("res://assets/separated/WaterBall.tscn")


func _ready() -> void:
    spawn_shovels()


func spawn_shovels():
    var spawned_shovels = 0
    while spawned_shovels < num_shovels:
        var dice = randi_range(0, 3)
        # print(dice)
        var coords = get_shovel_coords()
        var rotation = Basis \
                .looking_at(Vector3.FORWARD) \
                .rotated(Vector3.UP, randf_range(0, PI / 2)) \
                .rotated(Vector3.FORWARD, randf_range(0, PI / 6)) \
                .get_euler()
        if Vector2(coords.x, coords.z).distance_to(ground_generator.center_point) > ground_generator.size * 0.5 - 20:
            continue
        if dice == 0:
            spawn_object(coords, rotation, preloaded_shovel_red)
        if dice == 1:
            spawn_object(coords, rotation, preloaded_shovel_green)
        if dice == 2:
            spawn_object(coords, rotation, preloaded_shovel_blue)
        if dice == 3:
            spawn_object(coords, rotation, preloaded_sand_castle)
        spawned_shovels = spawned_shovels + 1


func get_shovel_coords():
    var x = int(randf_range(0, ground_generator.size) - ground_generator.size / 2.0)
    var z = int(randf_range(0, ground_generator.size) - ground_generator.size / 2.0)
    var y = ground_generator.calculate_ground_height(x, z) - randf_range(2, 10)
    var coords = Vector3(x, y, z)
    return coords


func spawn_object(coordinates, rotation, scene):
    var spawned = scene.instantiate()
    spawned.set_position(coordinates)
    spawned.rotation = rotation
    add_child(spawned)
    # print("lol", coordinates)
