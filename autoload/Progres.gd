extends Node
# Menyimpan progres pemain ke user://progres.json

const PATH := "user://progres.json"

var nama := ""
var kelas := ""
var level := {}          # "1-1": {"lulus": true, "bintang": 3}
var kuis := {}           # "1": 3
var prolog_sudah := false
var epilog_sudah := false
var pengaturan := {"musik": true, "efek": true, "mode_kelas": false, "proyektor": false}
var sisa_timer := {}     # sisa detik per bab (mode kelas), tidak disimpan

func _ready() -> void:
	muat()
	terapkan_pengaturan()

# ---------- simpan & muat ----------
func simpan() -> void:
	var f := FileAccess.open(PATH, FileAccess.WRITE)
	if f == null:
		return
	f.store_string(JSON.stringify({
		"nama": nama, "kelas": kelas, "level": level, "kuis": kuis,
		"prolog": prolog_sudah, "epilog": epilog_sudah, "pengaturan": pengaturan,
	}))

func muat() -> void:
	if not FileAccess.file_exists(PATH):
		return
	var d = JSON.parse_string(FileAccess.get_file_as_string(PATH))
	if typeof(d) != TYPE_DICTIONARY:
		return
	nama = d.get("nama", "")
	kelas = d.get("kelas", "")
	level = d.get("level", {})
	kuis = d.get("kuis", {})
	prolog_sudah = d.get("prolog", false)
	epilog_sudah = d.get("epilog", false)
	pengaturan.merge(d.get("pengaturan", {}), true)

func hapus_progres() -> void:
	nama = ""
	kelas = ""
	level = {}
	kuis = {}
	prolog_sudah = false
	epilog_sudah = false
	simpan()

# ---------- bintang & gelar ----------
func lulus(id: String) -> bool:
	return level.has(id) and level[id].get("lulus", false)

func bintang(id: String) -> int:
	return int(level[id].get("bintang", 0)) if level.has(id) else 0

func bintang_teks(n: int) -> String:
	return "★".repeat(n) + "☆".repeat(3 - n)

func total_bintang_inti() -> int:
	var t := 0
	for l in DataLevel.semua_inti():
		t += bintang(l["id"])
	return t

func total_kuis() -> int:
	var t := 0
	for n in kuis.values():
		t += int(n)
	return t

func gelar(b: int) -> String:
	if b >= 32:
		return "Kenek Juara Komplek"
	if b >= 20:
		return "Kenek Andal"
	return "Kenek Magang"

func catat_lulus(id: String, dapat: int) -> void:
	level[id] = {"lulus": true, "bintang": maxi(bintang(id), dapat)}
	simpan()

# ---------- kunci level ----------
func bab_selesai(id_bab: String) -> bool:
	for l in DataLevel.inti_bab(id_bab):
		if not lulus(l["id"]):
			return false
	return kuis.has(id_bab) or not DataLevel.kuis.has(id_bab)

func bab_terbuka(id_bab: String) -> bool:
	var ids := DataLevel.bab.map(func(b): return b["id"])
	var i := ids.find(id_bab)
	return i <= 0 or bab_selesai(ids[i - 1])

func level_terbuka(l: Dictionary) -> bool:
	if not bab_terbuka(l["bab"]):
		return false
	var inti := DataLevel.inti_bab(l["bab"])
	if l.get("bonus", false):
		return inti.all(func(x): return lulus(x["id"]))
	var ids := inti.map(func(x): return x["id"])
	var i := ids.find(l["id"])
	return i == 0 or lulus(ids[i - 1])

func level_berikutnya() -> Dictionary:
	for l in DataLevel.semua_inti():
		if level_terbuka(l) and not lulus(l["id"]):
			return l
	return {}

# ---------- kode rapor ----------
func buat_kode_rapor() -> String:
	var semua := ""
	for l in DataLevel.level:
		semua += str(bintang(l["id"]))
	var isi := "%s|%s|%s|%d" % [nama, kelas, semua, total_kuis()]
	var b64 := Marshalls.utf8_to_base64(isi).replace("+", "-").replace("/", "_").replace("=", "")
	return "SKM.%s.%s" % [b64, _cek(b64)]

func baca_kode_rapor(kode: String) -> Dictionary:
	var p := kode.strip_edges().split(".")
	if p.size() != 3 or p[0] != "SKM" or _cek(p[1]) != p[2].to_upper():
		return {}
	var b64 := p[1].replace("-", "+").replace("_", "/")
	while b64.length() % 4 != 0:
		b64 += "="
	var bagian := Marshalls.base64_to_utf8(b64).split("|")
	if bagian.size() != 4:
		return {}
	var inti := 0
	var bonus := 0
	for i in mini(bagian[2].length(), DataLevel.level.size()):
		var n := int(bagian[2][i])
		if DataLevel.level[i].get("bonus", false):
			bonus += n
		else:
			inti += n
	return {"nama": bagian[0], "kelas": bagian[1], "inti": inti, "bonus": bonus, "kuis": int(bagian[3])}

func _cek(s: String) -> String:
	var h := 0
	for c in s:
		h = (h * 31 + c.unicode_at(0)) % 1296
	return String.num_int64(h, 36).to_upper().lpad(2, "0")

# ---------- pengaturan ----------
func terapkan_pengaturan() -> void:
	get_tree().root.content_scale_factor = 1.3 if pengaturan["proyektor"] else 1.0
	var musik := AudioServer.get_bus_index("Musik")
	var efek := AudioServer.get_bus_index("Efek")
	if musik >= 0:
		AudioServer.set_bus_mute(musik, not pengaturan["musik"])
	if efek >= 0:
		AudioServer.set_bus_mute(efek, not pengaturan["efek"])
