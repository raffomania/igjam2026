extends Node3D
@onready var sun = $Sun
@onready var moon = $Moon

@export var cycle_duration_seconds: float = 120.0


func _process(delta: float) -> void:
	var rotation_per_second = TAU / cycle_duration_seconds

	rotate_x(rotation_per_second * delta)
	# sun.visible = sun.global_transform.basis.z.y < 0
	# moon.visible = moon.global_transform.basis.z.y < 0
