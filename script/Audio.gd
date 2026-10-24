class_name AudioManager
extends Node
# Daftarkan sebagai Autoload dengan nama "Audio" (beda dengan class_name).
# Pemakaian: Audio.play("jump")   Audio.toggle_mute()   (tombol M = suara ON/OFF)
# Versi tanpa musik latar: hanya efek suara (SFX).

const SFX_NAMES := ["jump", "double_jump", "dash", "coin", "die", "land",
		"click", "stomp", "win", "lose"]
const POOL_SIZE := 8
const SFX_PATH := "res://assets/sfx/%s.wav"

var muted := false
var _streams := {}
var _pool: Array[AudioStreamPlayer] = []

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS     # tetap bunyi saat game di-pause
	for sfx_name in SFX_NAMES:
		var path: String = SFX_PATH % sfx_name
		if ResourceLoader.exists(path):
			_streams[sfx_name] = load(path)
	for i in POOL_SIZE:
		var p := AudioStreamPlayer.new()
		add_child(p)
		_pool.append(p)

func play(sfx_name: String, pitch: float = 1.0) -> void:
	if not _streams.has(sfx_name):
		return
	for p in _pool:
		if not p.playing:
			_start(p, sfx_name, pitch)
			return
	_start(_pool[0], sfx_name, pitch)           # semua sibuk: pakai yang pertama

func _start(p: AudioStreamPlayer, sfx_name: String, pitch: float) -> void:
	p.stream = _streams[sfx_name]
	p.pitch_scale = pitch
	p.play()

func is_muted() -> bool:
	return muted

func toggle_mute() -> void:
	muted = not muted
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), muted)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_M:
		toggle_mute()
