extends Node


@onready var timer: Timer = $Timer
@export var attackers: Array[PackedScene]
@export var min_delay: float = 1.0
@export var max_delay: float = 5.0


func _ready() -> void:
    #spawn_attacker()
    #start_random_timer()
    pass

func start_random_timer() -> void:
    timer.wait_time = randf_range(1.0, 5.0)
    timer.start()

func _on_timer_timeout() -> void:
    spawn_attacker()
    start_random_timer()
    
func spawn_attacker():
    var object_scene = attackers.pick_random()
    var instance = object_scene.instantiate()
    self.get_parent().add_child(instance)
    
