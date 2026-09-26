extends Node3D

@onready var area: Area3D = $"Shelly/Area3D"


func _ready() -> void:
    area.body_entered.connect(body_entered)


func _process(delta: float) -> void:
    rotate(Vector3.UP, delta * 2)


func body_entered(body: Node3D) -> void:
    if body.is_in_group("player"):
        body.add_score.emit(10)
        queue_free()
