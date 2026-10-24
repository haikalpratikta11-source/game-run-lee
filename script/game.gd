extends Node
var coins := 0
var deaths := 0
var coins_at_level_start := 0
var tutorial_seen := false

func reset() -> void:
	coins_at_level_start = 0
	coins = 0
	deaths = 0

const MAX_DEATHS := 15
