extends Area2D

@export var next_scene_path: String = "res://dunia/level_dua.tscn"

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.name == "Player":
		if Game.gold >= 50:
			get_tree().change_scene_to_file(next_scene_path)
		else:
			print("Butuh minimal 50 gold untuk masuk ke level 2!")
