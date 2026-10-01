extends Camera3D

const speed = 0.01


func _process(delta):
    rotation.y = rotation.y + delta * speed
