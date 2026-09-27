extends TextureButton

const NORMAL_COLOR: Color = Color(1.0, 1.0, 1.0, 1.0)
const HOVER_COLOR: Color = Color(0.7, 0.7, 0.7, 1.0)


func _ready() -> void:
    mouse_entered.connect(_on_mouse_entered)
    mouse_exited.connect(_on_mouse_exited)


func _on_mouse_entered() -> void:
    hover_on()


func _on_mouse_exited() -> void:
    hover_off()


func hover_on():
    self_modulate = HOVER_COLOR


func hover_off():
    self_modulate = NORMAL_COLOR
