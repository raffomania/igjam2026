extends Node
@onready var sun = $Sun
@onready var moon = $Moon
@export var sun_light: DirectionalLight3D
@export var world_env: WorldEnvironment
@export var cycle_duration_seconds: float = 120.0


func _ready() -> void:
    pass
    # var timer: Timer = Timer.new()
    # timer.wait_time = 0.
    # timer.timeout.connect(_time_handling)
    # add_child(timer)


func _time_handling():
    pass
    # sun_light.rotation.x += 5
    #
    # sun.visible = sun.global_transform.basis.z.y < 0
    # moon.visible = moon.global_transform.basis.z.y < 0
