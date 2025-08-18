class_name Ship extends CharacterBody2D

const MAX_COLLISIONS_PER_FRAME: = 4

## Determines how much the ship will resist knockback from damage and collisions.
## The higher the value, the greater the resistance.
@export_range(0.0, 1.0, 0.02) var knockback_resist: = 0.0

@export var max_linear_speed: = 560.0

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
		#print("Vel ", velocity.length(), " Col ", collision.get_collider_velocity().length())
		var collision_normal: = collision.get_normal()
		var collision_speed: = velocity.length() + collision.get_collider_velocity().length()
		
		knockback += collision_normal * collision_speed * (1.0-knockback_resist)
		var collider = collision.get_collider()
		if "collision_repulsion" in collision.get_collider():
			knockback *= collider.collision_repulsion
			
		collision = move_and_collide(collision_normal*collision.get_remainder().length())
		#print(collision.get_normal())
		#global_position = Vector2(0,0)
		num_collisions += 1
	
	if num_collisions > 0:
		velocity = knockback.limit_length(max_linear_speed)


func take_hit(hit: Hit) -> void:
	hit_sound.stop()
	hit_sound.stream = hit.hull_sfx
	hit_sound.play()
	
	anim.play("hurt")
