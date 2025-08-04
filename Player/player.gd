extends CharacterBody2D

var respawn_position : Vector2
const SPEED = 300.0
const RUN_SPEED = 900.0
const JUMP_VELOCITY = -400.0

@onready var anim = get_node("AnimatedSprite2D")
@onready var sfx_jump: AudioStreamPlayer = $sfx_jump

func _ready() -> void:
	respawn_position = global_position

func _physics_process(delta: float) -> void:
	# ✅ Countdown waktu
	if Game.batas_waktu > 0:
		Game.batas_waktu -= delta
		if Game.batas_waktu <= 0:
			Game.batas_waktu = 0
			get_tree().change_scene_to_file("res://kehabisan_nyawa.tscn")
			return

	# ✅ Cek jika player jatuh ke jurang
	if global_position.y > 1000:
		Game.playerHP -= 1
		global_position = respawn_position
		velocity = Vector2.ZERO

	# ✅ Cek jika nyawa player habis
	if Game.playerHP <= 0:
		get_tree().change_scene_to_file("res://kehabisan_nyawa.tscn")
		return

	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play("jump")
		sfx_jump.play()

	# Movement
	var direction := Input.get_axis("ui_left", "ui_right")

	var current_speed = SPEED
	if Input.is_action_pressed("ui_shift"):
		current_speed = RUN_SPEED

	if direction == -1:
		anim.flip_h = true
	elif direction == 1:
		anim.flip_h = false

	if direction:
		velocity.x = direction * current_speed
		if velocity.y == 0:
			anim.play("run")
	else:
		if velocity.y == 0:
			anim.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if velocity.y > 0:
		anim.play("fall")

	move_and_slide()
