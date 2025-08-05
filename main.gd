extends Node2D

func _ready() -> void:
	Utils.saveGame()
	Utils.loadGame()

func _process(delta: float) -> void:
	pass # Timer dipindahkan ke player.gd, jadi tidak perlu di sini

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_play_pressed() -> void:
	Game.reset() # Reset data sebelum masuk world
	Utils.saveGame()
	get_tree().change_scene_to_file("res://cut_scene.tscn")
