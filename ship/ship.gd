class_name Ship extends CharacterBody2D

const MAX_COLLISIONS_PER_FRAME: = 4

## Determines how much the ship will resist knockback from damage and collisions.
## The higher the value, the greater the resistance.
@export_range(0.0, 1.0, 0.02) var knockback_resist: = 0.0

@export var max_linear_speed: = 560.0
@export var max_angular_speed: = PI

## Determines how the object is currently rotating each frame. Positive is clockwise.
## Note that the object's velocity and current facing aren't necessarily related. This is usually
## only relevant when forward (or backwards) thrust is applied.
var angular_velocity: float = 0.0


@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var hit_sound: AudioStreamPlayer = $HitSounds
@onready var projectile_origin: Node2D = $ProjectileOrigin


func _physics_process(delta: float) -> void:
	var num_collisions = 0
	var knockback: = Vector2.ZERO
	
	var collision: = move_and_collide(velocity*delta)
	while collision != null and num_collisions < MAX_COLLISIONS_PER_FRAME:
		var collider: = collision.get_collider()
		
		if collider is Ship:
			collider.velocity = collider.take_collision(-collision.get_normal(), self, velocity)
		knockback += take_collision(collision.get_normal(), collider,
			collision.get_collider_velocity())
		
		collision = move_and_collide(collision.get_normal()*collision.get_remainder().length())
		num_collisions += 1
	
	if num_collisions > 0:
		velocity = knockback.limit_length(max_linear_speed)


func take_collision(normal: Vector2, collider: Object, collider_velocity: Vector2) -> Vector2:
	print("%s got hit by %s!" % [name, collider.name])
	
	var knockback: = Vector2.ZERO
	var collision_speed: = velocity.length() + collider_velocity.length()
	
	knockback += normal * collision_speed * (1.0-knockback_resist)
	
	if "collision_repulsion" in collider:
		knockback *= collider.collision_repulsion
	
	return knockback


func take_hit(hit: Hit) -> void:
	hit_sound.stop()
	hit_sound.stream = hit.hull_sfx
	hit_sound.play()
	
	anim.play("hurt")
