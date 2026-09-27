extends Node3D

@onready var area: Area3D = $"Area3D"


func _ready() -> void:
    area.body_entered.connect(body_entered)
    rotate(Vector3.UP, randf_range(0, PI * 2))


func _process(delta: float) -> void:
    rotate(Vector3.UP, delta * 2)


func body_entered(body: Node3D) -> void:
    if body.is_in_group("player"):
        Juicee.shockwave(body, 0.6, 0.045)
        body.add_score.emit(10)
        queue_free()
