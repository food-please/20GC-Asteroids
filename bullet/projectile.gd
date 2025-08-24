class_name Projectile extends Area2D

@export_category("Physics")

@export var allow_friendly_fire: = false

@export var fire_speed: = 100.0
@export var fire_velocity: = Vector2.ZERO

## The amount of velocity transferred to a hit object.
@export var knockback_factor: = 0.1

@export_category("Audio")
@export var hit_hull_sounds: Array[AudioStream]
@export var hit_shield_sounds: Array[AudioStream]

var origin_ship: Ship = null

@onready var visibility: VisibleOnScreenNotifier2D = $VisibilityNotifier


func _ready() -> void:
	visibility.screen_exited.connect(queue_free)
	
	body_entered.connect(
		func _on_body_collision(body: Node2D) -> void:
			if not allow_friendly_fire and body == origin_ship:
				print("No friendly fire!")
			
			else:
				if body is Ship:
					#print("Hit!")
					var new_hit: = Hit.new()
					if not hit_hull_sounds.is_empty(): 
						new_hit.hull_sfx = hit_hull_sounds.pick_random()
					if not hit_shield_sounds.is_empty(): 
						new_hit.shield_sfx = hit_shield_sounds.pick_random()
					
					new_hit.global_position = global_position
					new_hit.transferred_velocity = -fire_velocity * knockback_factor
					new_hit.knockback_direction =\
						 (body.global_position - global_position).normalized()
					
					body.take_hit(new_hit)
				
				queue_free()
	)


func _physics_process(delta: float) -> void:
	position += fire_velocity*delta
