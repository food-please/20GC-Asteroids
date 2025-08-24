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

var primary_weapon: Weapon = null
var secondary_weapon: Weapon = null

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var hit_sound: AudioStreamPlayer = $HitSounds


func _physics_process(delta: float) -> void:
	var num_collisions = 0
	var knockback_velocity: = Vector2.ZERO
	
	var collision: = move_and_collide(velocity*delta)
	while collision != null and num_collisions < MAX_COLLISIONS_PER_FRAME:
		var collider: = collision.get_collider()
		
		# If this Ship has hit another Ship, process the collision there as well.
		# This is necessary since only one CharacterBody2D will process this collision.
		if collider is Ship:
			collider.velocity = collider.knockback(-collision.get_normal(), velocity, self)
		knockback_velocity += knockback(collision.get_normal(), collision.get_collider_velocity(),
			collider)
		
		collision = move_and_collide(collision.get_normal()*collision.get_remainder().length())
		num_collisions += 1
	
	if num_collisions > 0:
		velocity = knockback_velocity.limit_length(max_linear_speed)


## Resgister a weapon as primary or secondary, if those slots are not already taken.
func register_weapon(weapon: Weapon) -> bool:
	if primary_weapon == null:
		primary_weapon = weapon
		print("Armed %s as primary weapon!" % weapon.name)
		return true
	elif secondary_weapon == null:
		secondary_weapon = weapon
		print("Armed %s as secondary weapon!" % weapon.name)
		return true
	print("Failed to register %s, weapon slots full!" % weapon.name)
	return false


func deregister_weapon(weapon: Weapon) -> void:
	if primary_weapon == weapon:
		primary_weapon = null
	if secondary_weapon == weapon:
		secondary_weapon = null


## collider_velocity is fully transferred to the Ship.
func knockback(knockback_direction: Vector2, collider_velocity: Vector2, collider: Object = null,
		knockback_damping: = 1.0) -> Vector2:
	var knockback_velocity: = Vector2.ZERO
	var collision_speed: = velocity.length() + collider_velocity.length()
	print("Col speed: ", collision_speed, " Source vel: ", velocity, " Coll vel: ", collider_velocity)
	
	knockback_velocity += knockback_direction * collision_speed * (1.0-knockback_resist) \
		* knockback_damping
	print("Knockback dir: ", knockback_velocity)
	
	if collider != null and "collision_repulsion" in collider:
		knockback_velocity *= collider.collision_repulsion
	
	return knockback_velocity


func take_hit(hit: Hit) -> void:
	hit_sound.stop()
	hit_sound.stream = hit.hull_sfx
	hit_sound.play()
	
	print("\nTransfer: ", hit.transferred_velocity)
	velocity = knockback(hit.knockback_direction, hit.transferred_velocity)
	#print(hit.transferred_velocity, " ", hit.knockback_direction)k
	#velocity = knockback(hit.knockback_direction, hit.transferred_velocity).limit_length(max_linear_speed)
	
	anim.play("hurt")
	
	var new_Explosion = load("res://explosion/dust_hit.tscn").instantiate()
	new_Explosion.global_position = hit.global_position
	get_parent().add_child(new_Explosion)
	new_Explosion.explode(-hit.knockback_direction)
