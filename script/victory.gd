extends Control

func _ready() -> void:
	_build_ui()

func _build_ui() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var idx: int = Game.last_level_index
	var stars: int = Game.last_stars
	var perfect := stars >= Game.COINS_PER_LEVEL
	var has_next := idx >= 0 and idx + 1 < Game.LEVELS.size()

	_add_background()
	var center := CenterContainer.new()
	add_child(center)
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 14)
	center.add_child(box)

	var title := Label.new()
	title.text = "LEVEL %d SELESAI!" % (maxi(idx, 0) + 1)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 44)
	title.add_theme_color_override("font_color", Color(0.49, 1.0, 0.69))
	box.add_child(title)

	var rating := StarRating.new()
	rating.star_size = 56.0
	rating.stars = stars
	rating.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	box.add_child(rating)

	var coins := Label.new()
	coins.text = "Koin: %d / %d" % [stars, Game.COINS_PER_LEVEL]
	coins.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	coins.add_theme_font_size_override("font_size", 24)
	box.add_child(coins)

	if perfect:
		var perfect_label := Label.new()
		perfect_label.text = "PERFECT!"
		perfect_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		perfect_label.add_theme_font_size_override("font_size", 34)
		perfect_label.add_theme_color_override("font_color", Color(1.0, 0.85, 0.3))
		box.add_child(perfect_label)

	if not has_next and idx >= 0:
		var done := Label.new()
		done.text = "Kamu menamatkan semua level!"
		done.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		box.add_child(done)

	var first_button: Button = null
	if has_next:
		var next := _make_button("Level Berikutnya")
		next.pressed.connect(_on_next_pressed.bind(idx + 1))
		box.add_child(next)
		first_button = next

	var menu := _make_button("Menu Utama")
	menu.pressed.connect(_on_menu_pressed)
	box.add_child(menu)
	if first_button == null:
		first_button = menu
	first_button.grab_focus()

func _make_button(text: String) -> Button:
	var b := Button.new()
	b.text = text
	b.custom_minimum_size = Vector2(240, 46)
	b.add_theme_font_size_override("font_size", 20)
	b.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	return b

func _add_background() -> void:
	var path := "res://assets/menu_bg.png"
	if ResourceLoader.exists(path):
		var tex := TextureRect.new()
		tex.texture = load(path)
		tex.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tex.stretch_mode = TextureRect.STRETCH_SCALE
		add_child(tex)
		tex.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	else:
		var rect := ColorRect.new()
		rect.color = Color(0.08, 0.10, 0.20)
		add_child(rect)
		rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

func _on_next_pressed(next_index: int) -> void:
	Audio.play("click")
	Game.reset()
	get_tree().change_scene_to_file(Game.LEVELS[next_index])

func _on_menu_pressed() -> void:
	Audio.play("click")
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
