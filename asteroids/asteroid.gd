@tool
class_name Asteroid extends AnimatableBody2D

signal split(num_new_asteroids: int, size: Size)

enum Size { SMALL, MEDIUM, BIG, HUGE }

const SPLIT_CHANCE: = 0
const MAX_NEW_ASTEROIDS: = 1
const SCALE: = 2
const STATS: = 3

const PROPERTIES: = {
	Size.HUGE: [1.0, 2, Vector2(1.5, 1.5), preload("res://asteroids/stats_asteroid_huge.tres")],
	Size.BIG: [1.0, 3, Vector2(1.1, 1.1), preload("res://asteroids/stats_asteroid_big.tres")],
	Size.MEDIUM: [0.8, 4, Vector2(0.7, 0.7), preload("res://asteroids/stats_asteroid_medium.tres")],
	Size.SMALL: [0, 0, Vector2(0.3, 0.3), preload("res://asteroids/stats_asteroid_small.tres")],
}

@export var size: Size:
	set(value):
		size = value
		scale = PROPERTIES[size][SCALE]
		stats = PROPERTIES[size][STATS]
		
@export var stats: Stats:
	set(value):
		if value != null:
			value = value.duplicate()
		
		stats = value
		if not Engine.is_editor_hint() and stats != null:
			if not stats.hull_depleted.is_connected(explode):
				stats.hull_depleted.connect(explode)

var angular_speed: = 0.1
var velocity: = Vector2.ZERO


func _ready() -> void:
	if not Engine.is_editor_hint():
		stats = stats
		if stats == null:
			stats = Stats.new()
			stats.hull = stats.max_hull
			stats.shields = stats.max_shields
			print("Setup: ", stats.hull, " ", stats.max_hull)
	
	else:
		set_physics_process(false)


func _physics_process(delta: float) -> void:
	position += velocity*delta
	rotate(angular_speed*delta)


func take_hit(hit: Hit) -> void:
	stats.hull -= hit.hull_damage
	#print("Ouch! ", hit.hull_damage, " Remaining: ", stats.hull)
	
	if stats.hull > 0:
		SFX.play(hit.hull_sfx)
		
		#velocity = knockback(hit.knockback_direction, hit.transferred_velocity)
		#velocity = \
			#knockback(hit.knockback_direction, hit.transferred_velocity).limit_length(max_linear_speed)
		
		#anim.play("hurt")
		
		var new_Explosion = load("res://explosion/dust_hit.tscn").instantiate()
		new_Explosion.global_position = hit.global_position
		get_parent().add_child(new_Explosion)
		new_Explosion.explode(-hit.knockback_direction)



## Animate the destruction of the ship, playing a series of explosions before freeing the object.
func explode() -> void:
	print("Essplode")
	var explosion_scene: = preload("res://explosion/explosion.tscn")
	var explosion: = explosion_scene.instantiate()
	
	get_parent().add_child(explosion)
	explosion.global_position = global_position
	explosion.explosion_frame.connect(_on_explosion_frame)
	explosion.explode()


func _on_explosion_frame() -> void:
	queue_free()
	
	var max_new_children: int = PROPERTIES[size][MAX_NEW_ASTEROIDS]
	var new_asteroids: = 0 if max_new_children <= 0 else (randi()%max_new_children + 1)
	if new_asteroids > 0:
		var new_size: = Size.SMALL
		match size:
			Size.HUGE:	new_size = Size.BIG
			Size.BIG:	new_size = Size.MEDIUM
		
		print("New size: ", new_size, " New asteroids: ", new_asteroids)
		split.emit(new_asteroids, new_size)
