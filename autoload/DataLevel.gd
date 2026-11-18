extends Node
# Membaca res://data/levels.json

var bab: Array = []
var level: Array = []
var kuis: Dictionary = {}

func _ready() -> void:
	var data = JSON.parse_string(FileAccess.get_file_as_string("res://data/levels.json"))
	if typeof(data) != TYPE_DICTIONARY:
		push_error("levels.json gagal dibaca. Cek koma dan kurung kurawalnya.")
		return
	bab = data["bab"]
	level = data["level"]
	kuis = data["kuis"]
	print("DataLevel siap: %d bab, %d level" % [bab.size(), level.size()])

func cari_level(id: String) -> Dictionary:
	for l in level:
		if l["id"] == id:
			return l
	return {}

func cari_bab(id: String) -> Dictionary:
	for b in bab:
		if b["id"] == id:
			return b
	return {}

func level_bab(id_bab: String) -> Array:
	return level.filter(func(l): return l["bab"] == id_bab)

func inti_bab(id_bab: String) -> Array:
	return level_bab(id_bab).filter(func(l): return not l.get("bonus", false))

func semua_inti() -> Array:
	return level.filter(func(l): return not l.get("bonus", false))
