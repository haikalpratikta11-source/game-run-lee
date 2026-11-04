class_name SaveSystem
extends RefCounted

const PATH := "user://runlee_data.cfg"

static var unlocked: int = 1
static var best_stars: Dictionary = {}
static var _loaded: bool = false

static func load_data() -> void:
	if _loaded:
		return
	_loaded = true
	var cfg := ConfigFile.new()
	if cfg.load(PATH) != OK:
		return
	unlocked = maxi(1, int(cfg.get_value("progress", "unlocked", 1)))
	if cfg.has_section("stars"):
		for key in cfg.get_section_keys("stars"):
			best_stars[int(key)] = int(cfg.get_value("stars", key, 0))

static func save_data() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("progress", "unlocked", unlocked)
	for i in best_stars:
		cfg.set_value("stars", str(i), best_stars[i])
	cfg.save(PATH)

static func is_unlocked(level_index: int) -> bool:
	load_data()
	return level_index < unlocked

static func is_cleared(level_index: int) -> bool:
	load_data()
	return best_stars.has(level_index)

static func get_stars(level_index: int) -> int:
	load_data()
	return int(best_stars.get(level_index, 0))

static func complete_level(level_index: int, stars: int) -> void:
	load_data()
	best_stars[level_index] = maxi(get_stars(level_index), stars)
	unlocked = maxi(unlocked, level_index + 2)
	save_data()

static func reset_all() -> void:
	unlocked = 1
	best_stars.clear()
	_loaded = true
	save_data()
