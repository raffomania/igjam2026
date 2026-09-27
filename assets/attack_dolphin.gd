class_name AttackDolphin extends GameEnder

var camera: Camera3D
var player: RigidBody3D

@export var turn_speed: float = 0.3

var flipped: bool = false

func _ready() -> void:
    player = GlobalManager.player_body
    camera = GlobalManager.player.camera

    var spawn_position = player.global_position + \
    player.global_position.normalized() * (240 + randf_range(-1.0, 1.0) * 50)
    spawn_position.y = -50 + randf_range(-1.0, 0.5) * 80
    global_position = spawn_position
    if randf_range(0.0, 1.0) > 0.5:
        $Pivot.rotate_y(PI)
        flipped = true
    self.look_at(Vector3(player.global_position.x, spawn_position.y, player.global_position.z))
    
func _physics_process(delta: float) -> void:
    if flipped:
        $Pivot.rotate_z(-turn_speed * delta)
    else:
        $Pivot.rotate_z(turn_speed * delta)
    
    
