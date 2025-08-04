extends CharacterBody2D

var respawn_position: Vector2
const SPEED = 300.0
const RUN_SPEED = 900.0
const JUMP_VELOCITY = -400.0

@onready var anim = $AnimatedSprite2D
@onready var sfx_jump: AudioStreamPlayer = $sfx_jump

var is_attacking = false

func _ready() -> void:
	respawn_position = global_position

func _physics_process(delta: float) -> void:
	# ⏱ Timer batas waktu
	if Game.batas_waktu > 0:
		Game.batas_waktu -= delta
		if Game.batas_waktu <= 0:
			Game.batas_waktu = 0
			get_tree().change_scene_to_file("res://kehabisan_nyawa.tscn")
			return

	# 🔻 Jatuh ke jurang
	if global_position.y > 1000:
		Game.playerHP -= 1
		global_position = respawn_position
		velocity = Vector2.ZERO

	# ❤️ Habis nyawa
	if Game.playerHP <= 0:
		get_tree().change_scene_to_file("res://kehabisan_nyawa.tscn")
		return

	# 🔽 Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# 🔼 Lompat
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		sfx_jump.play()
		if not is_attacking:
			anim.play("jump")

	# 🔁 Gerakan kiri kanan
	var direction := Input.get_axis("ui_left", "ui_right")
	var current_speed = SPEED
	if Input.is_action_pressed("ui_shift"):
		current_speed = RUN_SPEED

	if direction == -1:
		anim.flip_h = true
	elif direction == 1:
		anim.flip_h = false

	velocity.x = direction * current_speed

	# ⚔️ Attack
	if Input.is_action_just_pressed("attack") and not is_attacking:
		is_attacking = true
		anim.play("attack")
		velocity.x = 0  # opsional: diam saat menyerang

	# 🔁 Animasi gerak normal (jika tidak menyerang)
	if not is_attacking:
		if direction != 0:
			if is_on_floor():
				anim.play("run")
		elif is_on_floor():
			anim.play("idle")

		if velocity.y > 0 and not is_on_floor():
			anim.play("fall")

	move_and_slide()

# ✅ Reset is_attacking setelah animasi attack selesai
func _on_AnimatedSprite2D_animation_finished():
	if anim.animation == "attack":
		is_attacking = false
