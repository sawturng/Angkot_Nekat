extends Node
# Semua perpindahan layar lewat sini.

const SCENE := {
	"judul": "res://layar/Judul.tscn",
	"cerita": "res://layar/Cerita.tscn",
	"peta": "res://layar/Peta.tscn",
	"main": "res://layar/Main.tscn",
	"kuis": "res://layar/Kuis.tscn",
	"rapor": "res://layar/Rapor.tscn",
	"skor": "res://layar/PapanSkor.tscn",
	"pengaturan": "res://layar/Pengaturan.tscn",
	"panduan": "res://layar/Panduan.tscn",
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
