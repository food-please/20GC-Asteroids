class_name Ship extends CharacterBody2D


@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var hit_sound: AudioStreamPlayer = $HitSounds
@onready var projectile_origin: Node2D = $ProjectileOrigin


func take_hit(hit: Hit) -> void:
	hit_sound.stop()
	hit_sound.stream = hit.hull_sfx
	hit_sound.play()
	
	anim.play("hurt")
