extends AudioStreamPlayer

const VOLUME_SAVE_PATH = "user://volume.bin"
const DEFAULT_VOLUME = 0.5


func apply_volume(value: float) -> void:
    volume_linear = clampf(value, 0.0, 1.0)
    save_volume()


func save_volume() -> void:
    var file := FileAccess.open(VOLUME_SAVE_PATH, FileAccess.WRITE)
    file.store_float(volume_linear)


func load_volume() -> float:
    var value = DEFAULT_VOLUME
    var file := FileAccess.open(VOLUME_SAVE_PATH, FileAccess.READ)
    if file:
        value = file.get_float()

    apply_volume(value)
    return value
