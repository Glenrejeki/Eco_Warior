extends Node2D

var sampah_kertas = preload("res://Kumpulan Sampah/sampah_kertas.tscn")
var sampah_kaleng = preload("res://Kumpulan Sampah/sampah_kaleng.tscn") # ✅ Tambah preload kaleng

var rng = RandomNumberGenerator.new()

var jumlah_kertas = 0 # ✅ jumlah spesifik untuk kertas
var jumlah_kaleng = 0 # ✅ jumlah spesifik untuk kaleng

const MAKSIMAL_KERTAS = 100
const MAKSIMAL_KALENG = 100

# ✅ Fungsi cari posisi aman (hindari tilemap / body lain)
func cari_posisi_aman(min_x: int, max_x: int, min_y: int, max_y: int) -> Vector2:
	var max_coba = 10
	var space_state = get_world_2d().direct_space_state

	for i in max_coba:
		var x = rng.randi_range(min_x, max_x)
		var y = rng.randi_range(min_y, max_y)
		var posisi = Vector2(x, y)

		var query = PhysicsPointQueryParameters2D.new()
		query.position = posisi
		query.collide_with_areas = true
		query.collide_with_bodies = true

		var result = space_state.intersect_point(query)

		if result.is_empty(): # ✅ posisi aman
			return posisi

	# Kalau gagal 10x, pakai default
	return Vector2(min_x, min_y)

func _on_timer_timeout() -> void:
	if jumlah_kertas >= MAKSIMAL_KERTAS and jumlah_kaleng >= MAKSIMAL_KALENG:
		$Timer.stop()
		return

	# ✅ Tentukan jenis sampah yang akan di-spawn (acak)
	var jenis_sampah = rng.randi_range(0, 1) # 0 = kertas, 1 = kaleng

	if jenis_sampah == 0 and jumlah_kertas < MAKSIMAL_KERTAS:
		var sampahkertasTemp = sampah_kertas.instantiate()
		var posisi = cari_posisi_aman(10, 5000, 320, 450)
		sampahkertasTemp.global_position = posisi
		get_parent().add_child(sampahkertasTemp)
		jumlah_kertas += 1
	elif jenis_sampah == 1 and jumlah_kaleng < MAKSIMAL_KALENG:
		var sampahkalengTemp = sampah_kaleng.instantiate()
		var posisi = cari_posisi_aman(10, 5000, 320, 450)
		sampahkalengTemp.global_position = posisi
		get_parent().add_child(sampahkalengTemp)
		jumlah_kaleng += 1
