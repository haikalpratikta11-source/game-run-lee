class_name TutorialOverlay
extends CanvasLayer

const ROWS := [
	["A / D   atau   ← →", "Bergerak"],
	["Space / W / ↑", "Lompat (tekan lagi di udara: double jump)"],
	["Shift / K", "Dash"],
	["P / Esc", "Pause (ada menu Ulang dan Menu Utama)"],
	["R", "Ulang level"],
	["M", "Suara ON / OFF"],
]

var pause_game := true
var _was_paused := false
var _can_close := false

static func open(host: Node, pause: bool = true) -> TutorialOverlay:
	var t := TutorialOverlay.new()
	t.pause_game = pause
	host.add_child(t)
	return t

func _ready() -> void:
	layer = 100
	process_mode = Node.PROCESS_MODE_ALWAYS
	_was_paused = get_tree().paused
	if pause_game:
		get_tree().paused = true
	_build_ui()
	await get_tree().create_timer(0.3).timeout   # cegah tertutup oleh klik yang membukanya
	_can_close = true

func _build_ui() -> void:
	var root := Control.new()
	add_child(root)
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var dim := ColorRect.new()
	dim.color = Color(0.03, 0.04, 0.10, 0.88)
	root.add_child(dim)
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var center := CenterContainer.new()
	root.add_child(center)
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var panel := PanelContainer.new()
	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color(0.11, 0.14, 0.28)
	panel_style.set_corner_radius_all(14)
	panel_style.set_border_width_all(2)
	panel_style.border_color = Color(1.0, 0.85, 0.3)
	panel_style.set_content_margin_all(26)
	panel.add_theme_stylebox_override("panel", panel_style)
	center.add_child(panel)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 12)
	panel.add_child(box)

	var title := Label.new()
	title.text = "CARA BERMAIN"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 30)
	title.add_theme_color_override("font_color", Color(1.0, 0.85, 0.3))
	box.add_child(title)

	for row in ROWS:
		var line := HBoxContainer.new()
		line.add_theme_constant_override("separation", 16)
		box.add_child(line)

		var key_box := PanelContainer.new()
		key_box.custom_minimum_size = Vector2(200, 0)
		var key_style := StyleBoxFlat.new()
		key_style.bg_color = Color(0.22, 0.26, 0.46)
		key_style.set_corner_radius_all(6)
		key_style.set_content_margin_all(8)
		key_box.add_theme_stylebox_override("panel", key_style)
		line.add_child(key_box)

		var key := Label.new()
		key.text = row[0]
		key.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		key_box.add_child(key)

		var desc := Label.new()
		desc.text = row[1]
		desc.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		line.add_child(desc)

	var footer := Label.new()
	footer.text = "Tekan tombol apa saja untuk melanjutkan"
	footer.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	footer.add_theme_color_override("font_color", Color(0.7, 0.75, 0.9))
	box.add_child(footer)

func _input(event: InputEvent) -> void:
	if not _can_close:
		return
	var key := event as InputEventKey
	var mouse := event as InputEventMouseButton
	var should_close := (key != null and key.pressed and not key.echo) \
			or (mouse != null and mouse.pressed)
	if should_close:
		get_viewport().set_input_as_handled()
		_close()

func _close() -> void:
	if pause_game:
		get_tree().paused = _was_paused
	queue_free()
