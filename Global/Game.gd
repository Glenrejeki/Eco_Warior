extends Node

var gold : int = 0
var playerHP : int = 5
var batas_waktu: float = 300.0  # default 5 menit

# Tambahkan parameter waktu (default 300 detik)
func reset(waktu: float = 300.0):
	gold = 0
	playerHP = 5
	batas_waktu = waktu
