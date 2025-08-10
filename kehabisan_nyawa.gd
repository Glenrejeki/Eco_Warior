extends Node2D

@onready var video = $VideoStreamPlayer
@onready var anim = $AnimationPlayer

func _ready() -> void:
	start_cutscene()

func start_cutscene() -> void:
	video.play()                       # Mainkan video
	anim.play("mulai_animasi")   # Mainkan animasi teks

	await video.finished                # Tunggu video selesai
	goto_main_menu()

func _on_balik_menu_pressed() -> void:
	video.stop()                        # Stop video kalau tombol ditekan
	goto_main_menu()

func goto_main_menu() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
