extends Node3D

@onready var area: Area3D = $"Area3D"


func _ready() -> void:
    area.body_entered.connect(body_entered)


func body_entered(body: Node3D) -> void:
    if body.is_in_group("player"):
        Juicee.shockwave(body, 0.6, 0.045)
        GlobalManager.player.random_trick(1500)
        queue_free()
