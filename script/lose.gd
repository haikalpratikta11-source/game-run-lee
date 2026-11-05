extends Control

func _ready() -> void:
	Audio.play("lose")
	var idx := Game.current_level_index()
	if idx >= 0:
		$Message.text = "Kamu mati di Level %d" % (idx + 1)
	else:
		$Message.text = "Kamu mati!"
	$RetryButton.grab_focus()

func _on_retry_button_pressed() -> void:
	Audio.play("click")
	var path := Game.current_level_path
	if path == "":
		path = Game.LEVELS[0]
	Game.reset()
	get_tree().change_scene_to_file(path)
	
func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_mainmenu_pressed() -> void:
		get_tree().change_scene_to_file(("res://scenes/main_menu.tscn"))
