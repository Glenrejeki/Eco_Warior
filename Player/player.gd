extends CharacterBody2D

var health = 1
var respawn_position : Vector2
const SPEED = 300.0
const RUN_SPEED = 900.0
const JUMP_VELOCITY = -400.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var sfx_jump: AudioStreamPlayer = $sfx_jump

var is_attacking: bool = false

func _ready():
	respawn_position = position

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity.y += 20
	else:
		velocity.y = 0

	# Attack
	if Input.is_action_just_pressed("attack") and not is_attacking:
		print("Z ditekan, serang!")
		is_attacking = true
		anim.play("attack")
		await get_tree().create_timer(0.4).timeout
		is_attacking = false

	# Lompat
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		sfx_jump.play()

	# Gerak kiri-kanan
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
		if is_on_floor() and not is_attacking:
			anim.play("run")
	else:
		if is_on_floor() and not is_attacking:
			anim.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Saat jatuh
	if velocity.y > 0 and not is_attacking:
		anim.play("fall")

	# Apply movement
	move_and_slide()

	# Respawn jika jatuh ke jurang
	if position.y > 1000:
		Game.playerHP -= 1
		
		if Game.playerHP <= 0:
			get_tree().change_scene_to_file("res://kehabisan_nyawa.tscn")
			return # supaya kode setelahnya gak jalan
			
		position = respawn_position
		velocity = Vector2.ZERO
