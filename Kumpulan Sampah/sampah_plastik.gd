extends Area2D
# ✅ Script ini digunakan untuk mendeteksi ketika player mengambil sampah plastik,
# lalu menjalankan animasi menghilang dan menambahkan plastik_count ke dalam game.

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		# ✅ Tambahkan jumlah plastik ke variabel global Game
		Game.plastik_count += 1  # Pastikan variabel ini ada di autoload Game.gd

		# ✅ Buat tween untuk animasi efek visual
		var tween = get_tree().create_tween()

		# ✅ Efek naik sedikit ke atas
		tween.tween_property(self, "position", position - Vector2(0, 16), 0.3)

		# ✅ Efek transparansi
		tween.tween_property(self, "modulate:a", 0, 0.3)

		# ✅ Hapus objek setelah animasi selesai
		tween.tween_callback(queue_free)

		# ✅ Debug: Tampilkan siapa yang menyentuh
		print("Sampah plastik diambil oleh: ", body.name)
