extends Area2D
# Script ini digunakan untuk mendeteksi ketika objek (seperti player) masuk ke dalam area,
# lalu menjalankan animasi menghilang dan menambahkan gold ke dalam game.

# Fungsi ini akan dipanggil secara otomatis ketika suatu Node2D masuk ke area (Area2D) ini
func _on_body_entered(body: Node2D) -> void:
	# Mengecek apakah yang masuk adalah player
	if body.name == "Player": # kita ambil asset player
		# Tambahkan 1 gold ke dalam variabel global Game
		Game.gold += 1 

		# Membuat tween untuk menganimasikan efek visual
		var tween = get_tree().create_tween()

		# Menganimasikan posisi objek ini agar naik sedikit (0, 16 piksel ke atas) dalam 0.3 detik
		tween.tween_property(self, "position", position - Vector2(0, 16), 0.3)

		# Menganimasikan agar objek perlahan menjadi transparan (alpha = 0) dalam 0.3 detik
		tween.tween_property(self, "modulate:a", 0, 0.3)

		# Setelah animasi selesai, hapus objek ini dari scene (agar tidak bisa diambil lagi)
		tween.tween_callback(queue_free)

		# Menampilkan nama objek yang masuk (debug/log)
		print("Entered: ", body.name)
