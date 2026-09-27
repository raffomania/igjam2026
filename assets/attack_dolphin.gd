class_name AttackDolphin extends GameEnder

var camera: Camera3D
var player: RigidBody3D

@export var turn_speed: float = 0.3

var close: bool = false

func _ready() -> void:
    player = GlobalManager.player_body
    camera = GlobalManager.player.camera

    var spawn_position = player.global_position + \
    player.global_position.normalized() * (190 + randf_range(-1.0, 1.0) * 30)
    spawn_position.y = -50 + randf_range(-1.0, 0.0) * 50
    global_position = spawn_position
    self.look_at(player.global_position)
    
func _physics_process(delta: float) -> void:
    $Pivot.rotate_z(turn_speed * delta)
    
    
