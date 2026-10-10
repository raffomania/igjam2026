extends Node

const VOLUME_SAVE_PATH = "user://volume.bin"

const LPF_CUTOFF_PLAYING_HZ = 20500.0
const LPF_CUTOFF_PAUSED_HZ = 500.0
const CUTOFF_BLEND_SPEED = 4.0

var pause_filter: AudioEffectLowPassFilter
var master_bus_idx: int
var volume := 0.5

signal volume_loaded(volume: int)


func _ready() -> void:
    pause_filter = _find_pause_filter()

    master_bus_idx = AudioServer.get_bus_index("Master")
    if master_bus_idx < 0:
        push_warning("Music: bus 'Master' not found, pause filter disabled")

    load_volume()
    # only play after volume has been loaded
    $MusicPlayer.play()


func _process(delta: float) -> void:
    if pause_filter == null:
        return
    # process_mode is ALWAYS, so this runs while the tree is paused as well.
    var target := LPF_CUTOFF_PAUSED_HZ if get_tree().paused else LPF_CUTOFF_PLAYING_HZ
    pause_filter.cutoff_hz = lerpf(
        pause_filter.cutoff_hz,
        target,
        clampf(CUTOFF_BLEND_SPEED * delta, 0.0, 1.0),
    )


func _find_pause_filter() -> AudioEffectLowPassFilter:
    for i in range(AudioServer.get_bus_effect_count(master_bus_idx)):
        var effect := AudioServer.get_bus_effect(master_bus_idx, i) as AudioEffectLowPassFilter
        if effect:
            return effect

    push_warning("Music: no high-pass filter on bus 'Master', pause filter disabled")
    return null


func apply_volume(value: float) -> void:
    AudioServer.set_bus_volume_linear(master_bus_idx, clampf(value, 0.0, 1.0))
    save_volume()


func save_volume() -> void:
    var file := FileAccess.open(VOLUME_SAVE_PATH, FileAccess.WRITE)
    file.store_float(AudioServer.get_bus_volume_linear(master_bus_idx))


func load_volume() -> void:
    var file := FileAccess.open(VOLUME_SAVE_PATH, FileAccess.READ)
    if file:
        volume = file.get_float()

    apply_volume(volume)
    volume_loaded.emit(volume)
