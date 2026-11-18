extends Control
# Layar Judul: animasi judul, menu utama, dan kotak isi nama.

var _setelah_nama := ""   # mau ke mana setelah nama diisi

func _ready() -> void:
	%IsiNama.hide()
	# Judul: mainkan "intro" sekali, lalu "idle" berulang
	%JudulAnim.animation_finished.connect(_on_judul_selesai)
	%JudulAnim.play("intro")
	%TombolMain.pressed.connect(_on_main)
	%TombolPilihBab.pressed.connect(_on_pilih_bab)
	%TombolPanduan.pressed.connect(Layar.ke.bind("panduan"))
	%TombolPengaturan.pressed.connect(Layar.ke.bind("pengaturan"))
	%TombolSiap.pressed.connect(_on_siap)
	%Kelas.text_submitted.connect(_on_enter)

func _on_judul_selesai() -> void:
	if %JudulAnim.animation == "intro":
		%JudulAnim.play("idle")

func _on_main() -> void:
	if Progres.nama == "":
		_minta_nama("main")
	elif not Progres.prolog_sudah:
		Layar.ke("cerita", {"jenis": "prolog"})
	else:
		Layar.ke_level_berikutnya()

func _on_pilih_bab() -> void:
	if Progres.nama == "":
		_minta_nama("peta")
	else:
		Layar.ke("peta")

func _minta_nama(tujuan: String) -> void:
	_setelah_nama = tujuan
	%Nama.text = Progres.nama
	%Kelas.text = Progres.kelas
	%Menu.hide()
	%IsiNama.show()
	%Nama.grab_focus()

func _on_enter(_teks: String) -> void:
	_on_siap()

func _on_siap() -> void:
	var n: String = %Nama.text.strip_edges().replace("|", "")
	if n == "":
		%Nama.grab_focus()
		return
	Progres.nama = n
	Progres.kelas = %Kelas.text.strip_edges().replace("|", "")
	Progres.simpan()
	%IsiNama.hide()
	%Menu.show()
	if _setelah_nama == "main":
		_on_main()
	else:
		Layar.ke("peta")
