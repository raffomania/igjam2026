extends Node

@onready var ground_generator := get_parent()

var num_shovels = 50


func _ready() -> void:
    var preloaded_shovel_blue = preload("res://assets/separated/ShovelBlue.tscn")
    var preloaded_shovel_green = preload("res://assets/separated/ShovelGreen.tscn")
    var preloaded_shovel_red = preload("res://assets/separated/ShovelRed.tscn")
    var preloaded_sand_castle = preload("res://assets/separated/ShovelBlue.tscn")
    var preloaded_water_ball = preload("res://assets/separated/ShovelBlue.tscn")

    spawn_shovels(preloaded_shovel_red, preloaded_shovel_green, preloaded_shovel_blue)


func spawn_shovels(red, green, blue):
    var spawned_shovels = 0
    while spawned_shovels < num_shovels:
        var dice = randi_range(0, 2)
        # print(dice)
        var coords = get_shovel_coords()
        if Vector2(coords.x, coords.z).distance_to(ground_generator.center_point) > ground_generator.size * 0.5 - 20:
            continue
        if dice == 0:
            spawn_object(coords, red)
        if dice == 1:
            spawn_object(coords, green)
        if dice == 2:
            spawn_object(coords, blue)
        spawned_shovels = spawned_shovels + 1


func get_shovel_coords():
    var x = int(randf_range(0, ground_generator.size) - ground_generator.size / 2.0)
    var z = int(randf_range(0, ground_generator.size) - ground_generator.size / 2.0)
    var coords = Vector3(x, 0, z)
    coords.y = ground_generator.calculate_ground_height(coords.x, coords.z)
    # coords.y = 100
    return coords


func spawn_object(coordinates, scene):
    var spawned = scene.instantiate()
    spawned.set_position(coordinates)
    add_child(spawned)
    # print("lol", coordinates)
