extends Node

const LEVELS := [
	"res://scenes/level_1.tscn",
	"res://scenes/level_2.tscn",
	"res://scenes/level_3.tscn",
]
const COINS_PER_LEVEL := 3

var coins := 0
var deaths := 0
var current_level_path := ""
var last_level_index := 0
var last_stars := 0
var tutorial_seen := false

func reset() -> void:
	coins = 0
	deaths = 0

func start_level(path: String) -> void:
	current_level_path = path
	coins = 0

func current_level_index() -> int:
	return LEVELS.find(current_level_path)

func complete_level() -> void:
	last_level_index = current_level_index()
	last_stars = clampi(coins, 0, COINS_PER_LEVEL)
	if last_level_index >= 0:
		SaveSystem.complete_level(last_level_index, last_stars)
