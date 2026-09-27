extends Node

@export var sun_light: DirectionalLight3D
@export var world_env: WorldEnvironment
@export var cycle_duration_seconds: float = 120.0


func _process(delta: float) -> void:
    sun_light.rotation.x += delta * 10
