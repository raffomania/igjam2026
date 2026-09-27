class_name AttackMoewe extends GameEnder

var camera: Camera3D
var player: RigidBody3D

@export var speed: float = 110.0
@export var depth_percentage: float = 0.4

var close: bool = false

func _ready() -> void:
    player = GlobalManager.player_body
    camera = GlobalManager.player.camera
    randomize()

    var spawn_position = player.global_position + \
    player.global_position.normalized() * 250 + \
    player.global_position.normalized().cross(Vector3.UP) * randf_range(-1.0, 1.0) * 30
    spawn_position.y = player.global_position.y + 10
    global_position = spawn_position
    self.look_at(player.global_position)

func _physics_process(delta: float) -> void:
    if (player.global_position - global_position).length() < 25:
        close = true
        
    if !close:
        self.look_at(player.global_position + Vector3.UP * 10)
    
    var forward_dir: Vector3 = -global_transform.basis.z
    position += forward_dir * speed * delta

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
    
func _on_body_entered(body: Node) -> void:
    print("Hit: ", body)
