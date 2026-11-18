extends Node
# Semua perpindahan layar lewat sini.
# Nama file scene ditulis huruf kecil semua, sama persis dengan nama file di folder layar/.

const SCENE := {
	"judul": "res://layar/judul.tscn",
	"cerita": "res://layar/cerita.tscn",
	"peta": "res://layar/peta.tscn",
	"main": "res://layar/main.tscn",
	"kuis": "res://layar/kuis.tscn",
	"rapor": "res://layar/rapor.tscn",
	"skor": "res://layar/papan_skor.tscn",
	"pengaturan": "res://layar/pengaturan.tscn",
	"panduan": "res://layar/panduan.tscn",
}

var sebelumnya := "judul"
var sekarang := "judul"
var titipan := {}   # data yang dibawa ke layar berikutnya, contoh {"level": "1-1"}

func ke(nama: String, data: Dictionary = {}) -> void:
	sebelumnya = sekarang
	sekarang = nama
	titipan = data
	get_tree().change_scene_to_file(SCENE[nama])

func ke_level_berikutnya() -> void:
	var l := Progres.level_berikutnya()
	if l.is_empty():
		ke("peta")
	else:
		ke("main", {"level": l["id"]})
