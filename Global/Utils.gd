extends Node


const SAVE_PATH ="res://savegame.bin"

func saveGame():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE) # Create the file 
	var data : Dictionary = {
		"PlayerHP": Game.playerHP,
		"Gold" : Game.gold,
	} # Membuat objek : Menyimpan informasi apa aja 
	var jstr = JSON.stringify(data) # ini bagian menyimpan : mudah dibaca saat load dan mudah disimpan ke file 
	file.store_line(jstr) #simpan string json ke file 
	file.close()  # tutup file setelah disimpan
		
func loadGame():
	if FileAccess.file_exists(SAVE_PATH): 
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ) # Read the file 
		if not file.eof_reached(): 
			var current_line =JSON.parse_string(file.get_line())
			if current_line: 
				Game.playerHP = current_line.get("PlayerHP", 1)
				Game.gold = current_line.get("Gold", 0)
