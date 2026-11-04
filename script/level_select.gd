extends Control

func _ready() -> void:
	SaveSystem.load_data()
	_build_ui()

func _build_ui() -> void:
	for child in get_children():
		child.queue_free()
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_add_background()

	var center := CenterContainer.new()
	add_child(center)
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 22)
	center.add_child(box)

	var title := Label.new()
	title.text = "PILIH LEVEL"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 44)
	title.add_theme_color_override("font_color", Color(1.0, 0.85, 0.3))
	box.add_child(title)

	var grid := GridContainer.new()
	grid.columns = 4
	grid.add_theme_constant_override("h_separation", 24)
	grid.add_theme_constant_override("v_separation", 18)
	grid.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	box.add_child(grid)
	for i in Game.LEVELS.size():
		grid.add_child(_make_card(i))

	var back := _make_button("Kembali")
	back.pressed.connect(_on_back_pressed)
	box.add_child(back)

	var reset := _make_button("Reset Progres")
	reset.add_theme_font_size_override("font_size", 14)
	reset.custom_minimum_size = Vector2(160, 32)
	reset.pressed.connect(_on_reset_pressed)
	box.add_child(reset)

	(grid.get_child(0).get_child(0) as Button).grab_focus()

func _make_card(i: int) -> Control:
	var unlocked := SaveSystem.is_unlocked(i)
	var stars := SaveSystem.get_stars(i)

	var card := VBoxContainer.new()
	card.add_theme_constant_override("separation", 8)

	var b := Button.new()
	if unlocked:
		b.text = "Level %d" % (i + 1)
	else:
		b.text = "Level %d\nTerkunci" % (i + 1)
	b.custom_minimum_size = Vector2(130, 90)
	b.add_theme_font_size_override("font_size", 20)
	b.disabled = not unlocked
	b.pressed.connect(_on_level_pressed.bind(i))
	card.add_child(b)

	var rating := StarRating.new()
	rating.stars = stars
	rating.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	card.add_child(rating)

	var tag := Label.new()
	tag.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	if stars >= Game.COINS_PER_LEVEL:
		tag.text = "PERFECT!"
		tag.add_theme_color_override("font_color", Color(1.0, 0.85, 0.3))
	elif SaveSystem.is_cleared(i):
		tag.text = "Selesai"
	else:
		tag.text = " "
	card.add_child(tag)
	return card

func _make_button(text: String) -> Button:
	var b := Button.new()
	b.text = text
	b.custom_minimum_size = Vector2(220, 44)
	b.add_theme_font_size_override("font_size", 18)
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

func _on_level_pressed(i: int) -> void:
	Audio.play("click")
	Game.reset()
	get_tree().change_scene_to_file(Game.LEVELS[i])

func _on_back_pressed() -> void:
	Audio.play("click")
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_reset_pressed() -> void:
	Audio.play("click")
	SaveSystem.reset_all()
	_build_ui()
