extends Node
@onready var sun = $Sun
@onready var moon = $Moon
@export var sun_light: DirectionalLight3D
@export var world_env: WorldEnvironment
@export var cycle_duration_seconds: float = 120.0


func _process(delta: float) -> void:
	sun_light.rotation.x += delta * 10
	sun.visible = sun.global_transform.basis.z.y < 0
	moon.visible = moon.global_transform.basis.z.y < 0
