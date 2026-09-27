extends Node3D

var camera: Camera3D
var player: RigidBody3D

@export var speed: float = 100.0
@export var rotation_speed: float = 5.0
@export var depth_percentage: float = 0.2

func _ready() -> void:
    player = GlobalManager.player_body
    camera = GlobalManager.player.camera
    randomize()

    var spawn_position = get_random_point_in_far_fov()
    self.set_position(spawn_position)
    self.look_at(player.get_position())

func _physics_process(delta: float) -> void:
    self.look_at(player.get_position())
    
    var forward_dir: Vector3 = -global_transform.basis.z
    global_position += forward_dir * speed * delta

func get_random_point_in_far_fov() -> Vector3:
    var target_depth: float = camera.far * depth_percentage
    
    var random_x: float = randf_range(-1.0, 1.0)
    var random_y: float = randf_range(-1.0, 1.0)
    
    var ndc_position = Vector3(random_x, random_y, target_depth)
    
    var global_point: Vector3 = camera.project_position(
        Vector2(
            remap(random_x, -1.0, 1.0, 0.0, get_viewport().size.x),
            remap(random_y, -1.0, 1.0, 0.0, get_viewport().size.y)
        ),
        target_depth
    )
    
    return global_point
