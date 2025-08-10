extends CharacterBody2D

var SPEED = 50
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player = null
var chase = false
var is_attacking = false
var is_dead = false

@onready var animation_player = $AnimationPlayer
@onready var sprite = $AnimatedSprite2D
@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft

func _ready():
	play_anim("idle")

func _physics_process(delta):
	if is_dead:
		velocity = Vector2.ZERO
		return

	velocity.y += gravity * delta

	# Jika chase mati otomatis di override
	if not chase:
		# Patrol otomatis berdasarkan raycast tepi
		if ray_cast_right.is_colliding():
			# Balik arah ke kiri
			SPEED = -abs(SPEED)
			sprite.flip_h = true
		elif ray_cast_left.is_colliding():
			# Balik arah ke kanan
			SPEED = abs(SPEED)
			sprite.flip_h = false

		velocity.x = SPEED
		if not is_attacking:
			play_anim("run")
	else:
		# Chase player aktif
		if player != null:
			var direction = (player.position - position).normalized()
			sprite.flip_h = direction.x < 0
			velocity.x = direction.x * abs(SPEED)

			if not is_attacking:
				if abs(velocity.x) > 0.1:
					play_anim("run")
				else:
					play_anim("idle")
		else:
			velocity.x = 0
			if not is_attacking:
				play_anim("idle")

	move_and_slide()

# Deteksi player masuk area chase
func _on_player_detection_body_entered(body):
	if body.is_in_group("Player") and not is_dead:
		player = body
		chase = true
		print("DEBUG: Player detected, chase started")

# Deteksi player keluar area chase
func _on_player_detection_body_exited(body):
	if body.is_in_group("Player") and not is_dead:
		player = null
		chase = false
		print("DEBUG: Player lost, chase stopped")

# Attack player saat player di area attack
func _on_player_attack_area_body_entered(body):
	if body.is_in_group("Player") and not is_dead and not is_attacking:
		is_attacking = true
		play_anim("attack")
		Game.playerHP -= 1  # Kurangi HP player saat serang
		await animation_player.animation_finished
		is_attacking = false
		play_anim("run")
		print("DEBUG: Attack finished")

# Trigger kematian enemy
func _on_player_death_body_entered(body):
	if body.is_in_group("Player") and not is_dead:
		death()

func death():
	is_dead = true
	chase = false
	velocity = Vector2.ZERO
	Game.Gold += 5
	Utils.saveGame()
	play_anim("death")
	print("DEBUG: Playing death animation")
	await animation_player.animation_finished
	queue_free()

# Fungsi untuk play animasi
func play_anim(anim_name: String):
	if animation_player.current_animation != anim_name:
		animation_player.play(anim_name)
		print("DEBUG: Switching animation to ", anim_name)
