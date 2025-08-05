extends Node2D

@onready var video = $VideoStreamPlayer
@onready var anim = $AnimationPlayer

func _ready() -> void:
	start_cutscene()

func start_cutscene() -> void:
	video.play()                     # Mainkan video
	anim.play("cut_scene_mulai")    # Mainkan animasi teks

	await video.finished             # Tunggu video selesai
	goto_next_scene()

func _on_button_pressed() -> void:
	video.stop()
	goto_next_scene()

func goto_next_scene() -> void:
	get_tree().change_scene_to_file("res://world.tscn")
