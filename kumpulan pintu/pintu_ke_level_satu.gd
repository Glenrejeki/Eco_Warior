extends Area2D

@export var next_scene_path: String = "res://cut_scene_level_2.tscn"

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.name == "Player":
		if Game.gold >= 10:
			get_tree().change_scene_to_file(next_scene_path)
		else:
			print("Butuh minimal 50 gold untuk masuk ke level 2!")
