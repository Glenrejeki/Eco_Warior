extends Area2D
# ✅ Script ini digunakan untuk mendeteksi ketika player masuk area kaleng,
# lalu menjalankan animasi menghilang dan menambahkan gold ke dalam game.

func _on_body_entered(body: Node2D) -> void:
	# ✅ Cek apakah yang menyentuh adalah Player
	if body.name == "Player":
		# ✅ Tambahkan gold ke variabel global Game
		Game.gold += 1

		# ✅ Buat tween untuk animasi efek visual
		var tween = get_tree().create_tween()

		# ✅ Naikkan posisi sedikit ke atas (efek "menghilang")
		tween.tween_property(self, "position", position - Vector2(0, 16), 0.3)

		# ✅ Buat objek perlahan jadi transparan
		tween.tween_property(self, "modulate:a", 0, 0.3)

		# ✅ Hapus objek setelah animasi selesai
		tween.tween_callback(queue_free)

		# ✅ Debug: Tampilkan siapa yang menyentuh
		print("Kaleng diambil oleh: ", body.name)
