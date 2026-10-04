extends Control
# Pasang di root scene Lose (Control)

func _ready() -> void:
	$Message.text = "Kamu kalah karena mati sebanyak %dx" % Game.deaths
	$RetryButton.grab_focus()   # supaya bisa dipilih dengan keyboard

func _on_retry_button_pressed() -> void:
	Game.reset()
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")
