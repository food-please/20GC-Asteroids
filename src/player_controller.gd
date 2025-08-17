extends Node

var bullet: = load("res://bullet/bullet.tscn")

@export var linear_acceleration: = 5.0
@export var angular_acceleration: = PI/10

var max_speed: = 220.0
var max_angular_velocity: = PI/2

var direction: = Vector2.UP
var current_angular_speed: = 0.0
var current_speed: = 0.0


@onready var ship: = get_parent() as CharacterBody2D


func _physics_process(delta: float) -> void:
	update_rotation()
	update_current_speed()
	
	#print("\n", current_angular_speed)
	direction = direction.rotated(current_angular_speed * delta)
	ship.rotation = direction.angle()
	#print(direction.angle())w
	ship.velocity = direction * current_speed
	ship.move_and_collide(ship.velocity*delta)
	#var rotation: = Input.get_axis("rotate_cw", "rotate_ccw")
	#if not is_zero_approx(rotation):
		#pass
	#
	#elif r


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("fire_primary"):
		var new_bullet = bullet.instantiate()
		new_bullet.global_position = ship.projectile_origin.global_position
		new_bullet.fire_velocity = (new_bullet.fire_speed+current_speed)*direction
		new_bullet.origin_ship = ship
		Events.projectile_fired.emit(new_bullet)


func update_rotation() -> void:
	var rotation_direction: = Input.get_axis("rotate_cw", "rotate_ccw")
	if is_zero_approx(rotation_direction):
		current_angular_speed = move_toward(current_angular_speed, 0, max_angular_velocity)
	
	else:
		current_angular_speed = clampf(
			current_angular_speed + rotation_direction * angular_acceleration,
			-max_angular_velocity,
			max_angular_velocity
		)


func update_current_speed() -> void:
	var throttle_direction: = Input.get_axis("throttle_down", "throttle_up")
	current_speed = clampf(
		current_speed + throttle_direction * linear_acceleration,
		0, 
		max_speed)
