extends Node2D

# Preload scene sampah
var sampah_kertas = preload("res://Kumpulan Sampah/sampah_kertas.tscn")
var sampah_plastik = preload("res://Kumpulan Sampah/sampah_plastik.tscn")

var rng = RandomNumberGenerator.new()

# Jumlah spawn
var jumlah_kertas = 0
var jumlah_plastik = 0

# Batas maksimal
const MAKSIMAL_KERTAS = 100
const MAKSIMAL_PLASTIK = 100

# Cari posisi aman supaya tidak tabrakan
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

		if result.is_empty():
			return posisi

	return Vector2(min_x, min_y) # fallback

# Dipanggil tiap timer timeout
func _on_timer_timeout() -> void:
	if jumlah_kertas >= MAKSIMAL_KERTAS and jumlah_plastik >= MAKSIMAL_PLASTIK:
		$Timer.stop()
		return

	var jenis_sampah = rng.randi_range(0, 1) # 0 = plastik, 1 = kertas

	if jenis_sampah == 0 and jumlah_plastik < MAKSIMAL_PLASTIK:
		var plastikTemp = sampah_plastik.instantiate()
		var posisi = cari_posisi_aman(0, 5000, 250, 300) # ✅ Y dari 250-300
		plastikTemp.global_position = posisi
		get_parent().add_child(plastikTemp)
		jumlah_plastik += 1
	elif jenis_sampah == 1 and jumlah_kertas < MAKSIMAL_KERTAS:
		var kertasTemp = sampah_kertas.instantiate()
		var posisi = cari_posisi_aman(0, 5000, 250, 300) # ✅ Y dari 250-300
		kertasTemp.global_position = posisi
		get_parent().add_child(kertasTemp)
		jumlah_kertas += 1
