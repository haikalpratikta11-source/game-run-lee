extends Control
 
func _ready() -> void:
	$Stats/CoinLabel.text = "Total Koin: %d" % Game.coins
	$Stats/DeathLabel.text = "Total Mati: %d" % Game.deaths
	$Buttons/RetryButton.grab_focus()  
 
func _on_retry_button_pressed() -> void:
	Game.reset()
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")
 
func _on_exit_menu_button_pressed() -> void:
	Game.reset()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
