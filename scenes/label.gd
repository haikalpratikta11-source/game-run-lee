extends Label
func _process(_d):
	text = "Koin %d   Mati %d" % [Game.coins, Game.deaths]
	
