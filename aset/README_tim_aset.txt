ANGKOT NEKAT — PAKET SPRITE KARAKTER (revisi 2: detail + palet berkode)
=====================================================================

Isi folder
----------
sheets/         1 sprite sheet per karakter, 416 x 48 px (13 frame x 32 x 48), skala 1x.
                -> File ini yang dipakai Godot dan yang kamu buka di Aseprite.
frames/         Frame yang sama, dipisah per file (nama_anim_nomor.png).
godot/          SpriteFrames .tres untuk Godot 4.3 (siap pakai di AnimatedSprite2D).
aseprite/       angkot_nekat_karakter.gpl  palet berkode (nama warna ikut termuat)
                palet_kode.png             kartu kode warna untuk dilihat sambil menggambar
ikon/           60 ikon UI: ikon/16/ dan ikon/32/ (PNG per ikon), atlas 16 & 32 + koordinat (.json),
                ikon_daftar.json (nama, grup, label). Lencana & gelar hanya 32 px.
latar/          24 background 426x240 (tampil 3x = ~1280x720), polos tanpa aset:
                samping/ 12 lokasi + lapisan/ (1_langit, 2_kota_jauh, 3_bangunan, 4_jalan) untuk parallax,
                atas/ peta + arena, ui/ 10 latar layar UI, pratinjau_x3/ untuk dilihat,
                latar_daftar.json (nama file + keterangan). Karakter berdiri di trotoar y 172-186.
judul/          Judul ANGKOT NEKAT! 196x102: statis (dengan/tanpa pita, pita saja, x4),
                judul_anim_sheet.png (intro 27 frame 12 fps sekali + idle 16 frame 10 fps loop),
                frames/ per frame, judul_animasi_x3.png (APNG transparan untuk dilihat).
                Godot: godot/judul_frames.tres (path res://assets/ui/judul_anim_sheet.png), play("intro") lalu play("idle").
potret/         Potret Bang Udin 64x64: biasa, panik, pusing, bangga (+ sheet 256x64).
palet_kode.csv  Daftar kode, hex, nama, dan karakter pemakai tiap warna.
preview/        Versi besar (x4 / x6) untuk dilihat saja. JANGAN dipakai di game.
sprites.json    Data frame dan palet (ukuran, urutan, fps) kalau programmer butuh.

Kode warna
----------
Format GRUP-nomor. UM = umum (wajah, efek), RB = rambut & tutup kepala,
IK = warna tambahan ikon, LT = warna latar, KN Kenek, UD Bang Udin, SR Sari, BM Bimo, NS Nisa, DR Juragan Darto, AA-AE anak komplek.
Contoh: UM-03 #f6ccb0 Kulit, UM-04 #e2b094 Kulit bayangan.

Aturan kanvas & detail
----------------------
- Satu frame 32 x 48 px. Latar transparan.
- Garis bawah outline sepatu selalu di baris y = 46 (baris ke-47). Baris 47 kosong.
- Titik tengah badan di x = 16 (celah antara dua kaki).
- Outline 1 px warna UM-01 #18161c, hanya 4 arah (sudut diagonal dibiarkan kosong).
- Cahaya dari kiri atas: sisi kanan tiap bagian diberi 1 px bayangan; dahi di bawah poni
  dan baju di bawah dagu juga diberi bayangan. Rambut/peci/topi/hijab diberi sorotan di kiri atas.
- Mata 2x2 dengan 1 px kilau putih (UM-02) di pojok kanan atas.
- Tampilkan di game dengan skala bulat (3x atau 4x) dan filter Nearest.

Urutan frame (kolom 0 sampai 12, dari kiri)
-------------------------------------------
 0-1   idle    (diam)          4 fps  loop
 2-5   walk    (jalan)         8 fps  loop
 6-8   naik    (naik angkot)   6 fps  sekali jalan
 9-10  senang  (bersorak)      6 fps  loop
 11-12 nangis  (menangis)      5 fps  loop

Aseprite (menggambar ulang)
---------------------------
1. File > Open > pilih sheets/<nama>.png.
2. Sprite > Import Sprite Sheet: Type "Horizontal Strip", Width 32, Height 48, tanpa padding.
3. Panel palet (ikon menu) > Load Palette > aseprite/angkot_nekat_karakter.gpl.
4. Buat layer baru di atas, turunkan opacity layer asli jadi ~30%, lalu gambar ulang di layer baru.
5. Beri Tag: idle 1-2, walk 3-6, naik 7-9, senang 10-11, nangis 12-13 (Aseprite mulai dari 1).
6. Sembunyikan layer referensi, lalu File > Export Sprite Sheet: Horizontal Strip,
   tanpa border/padding/trim, simpan dengan nama file yang SAMA (mis. kenek.png).

Godot 4.3
---------
1. Salin isi sheets/ ke res://assets/characters/ (path ini yang dipakai file .tres).
   Kalau folder kalian berbeda, ubah baris ext_resource path di tiap .tres.
2. Project Settings > Rendering > Textures > Canvas Textures > Default Texture Filter = Nearest.
3. Salin godot/*.tres ke proyek, buat AnimatedSprite2D, isi Sprite Frames dengan .tres-nya.
4. Agar posisi node = telapak kaki: centered = false, offset = (-16, -47).
5. Di kode: $AnimatedSprite2D.play("walk")  # idle / walk / naik / senang / nangis
