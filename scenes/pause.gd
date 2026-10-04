extends CanvasLayer

func _ready():
	visible = false

func _unhandled_input(e):
	if e.is_action_pressed("pause"):
		get_tree().paused = not get_tree().paused
		visible = get_tree().paused
	if e.is_action_pressed("restart"):
		get_tree().paused = false
		get_tree().reload_current_scene()
