extends Node


@onready var timer: Timer = $Timer
@export var attackers: Array[PackedScene]
@export var min_delay: float = 1.0
@export var max_delay: float = 5.0

var start_attacking: bool = false

var stop_attacking: bool = false

func _ready() -> void:
    GlobalManager.game_end.connect(_on_game_ended)
    
func _process(delta: float) -> void:
    if !start_attacking:
        var position = Vector2(GlobalManager.player_body.global_position.x, GlobalManager.player_body.global_position.z)
        if position.length() > 350:
            start_random_timer()
            start_attacking = true

func start_random_timer() -> void:
    timer.wait_time = randf_range(1.0, 5.0)
    timer.start()

func _on_timer_timeout() -> void:
    spawn_attacker()
    start_random_timer()
    
func spawn_attacker():
    if !stop_attacking:
        var object_scene = attackers.pick_random()
        var instance = object_scene.instantiate()
        self.get_parent().add_child(instance)
    
func _on_game_ended():
    stop_attacking = true
