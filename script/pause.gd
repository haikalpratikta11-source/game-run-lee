class_name Pause
extends CanvasLayer

var _root: Control
var _resume_button: Button

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 50
	Game.coins_at_level_start = Game.coins
	_build_ui()
	_root.visible = false
	_show_first_tutorial.call_deferred()

func _show_first_tutorial() -> void:
	if not Game.tutorial_seen:
		Game.tutorial_seen = true
		TutorialOverlay.open(self)

func _build_ui() -> void:
	_root = Control.new()
	add_child(_root)
	_root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var dim := ColorRect.new()
	dim.color = Color(0, 0, 0, 0.65)
	_root.add_child(dim)
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var center := CenterContainer.new()
	_root.add_child(center)
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 12)
	center.add_child(box)

	var title := Label.new()
	title.text = "PAUSE"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 44)
	box.add_child(title)

	_resume_button = _add_button(box, "Lanjutkan", _on_resume)
	_add_button(box, "Ulang Level", _restart)
	_add_button(box, "Kontrol", _on_controls)
	_add_button(box, "Menu Utama", _on_main_menu)

func _add_button(parent: Node, text: String, action: Callable) -> Button:
	var b := Button.new()
	b.text = text
	b.custom_minimum_size = Vector2(240, 46)
	b.add_theme_font_size_override("font_size", 20)
	b.pressed.connect(_on_button_pressed.bind(action))
	parent.add_child(b)
	return b

func _on_button_pressed(action: Callable) -> void:
	Audio.play("click")
	action.call()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_set_paused(not get_tree().paused)
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("restart"):
		_restart()

func _set_paused(value: bool) -> void:
	get_tree().paused = value
	_root.visible = value
	if value:
		Audio.play("click")
		_resume_button.grab_focus()

func _on_resume() -> void:
	_set_paused(false)

func _on_controls() -> void:
	TutorialOverlay.open(self)

func _restart() -> void:
	get_tree().paused = false
	Game.coins = Game.coins_at_level_start    
	get_tree().reload_current_scene()

func _on_main_menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
