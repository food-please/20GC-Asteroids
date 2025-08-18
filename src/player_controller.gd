extends Node

var bullet: = load("res://bullet/bullet.tscn")

@export var linear_acceleration: = 1500.0

@export var angular_acceleration: = 6*PI

@onready var ship: = get_parent() as Ship


func _ready() -> void:
	assert(ship, "Player controller must be child of a Ship!")


func _process(delta: float) -> void:
	update_rotation(delta)
	update_current_speed(delta)
	
	#print("\n", current_angular_speed)
	#direction = direction.rotated(current_angular_speed * delta)
	#ship.rotation = direction.angle()
	##print(direction.angle())w
	#ship.velocity = direction * current_speed
	
	#var num_collisions = 0
	#var collision: = ship.move_and_collide(ship.velocity*delta)
	#while collision != null and num_collisions < MAX_COLLISIONS_PER_FRAME:
		#
		#num_collisions += 1
	
	#var rotation: = Input.get_axis("rotate_cw", "rotate_ccw")
	#if not is_zero_approx(rotation):
		#pass
	#
	#elif r


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("fire_primary"):
		var new_bullet = bullet.instantiate()
		new_bullet.global_position = ship.projectile_origin.global_position
		new_bullet.fire_velocity = \
			(new_bullet.fire_speed)*Vector2.RIGHT.rotated(ship.rotation)
		new_bullet.origin_ship = ship
		Events.projectile_fired.emit(new_bullet)
#
#
func update_rotation(delta: float) -> void:
	var rotation_direction: = Input.get_axis("rotate_cw", "rotate_ccw")
	if is_zero_approx(rotation_direction):
		ship.angular_velocity = move_toward(ship.angular_velocity, 0, angular_acceleration * delta)
	
	else:
		ship.angular_velocity = clampf(
			ship.angular_velocity + rotation_direction * angular_acceleration * delta,
			-ship.max_angular_speed,
			ship.max_angular_speed
		)
		print(ship.angular_velocity)
	
	ship.rotation += ship.angular_velocity * delta


func update_current_speed(delta: float) -> void:
	var throttle_direction: = Input.get_axis("throttle_down", "throttle_up")
	if is_zero_approx(throttle_direction):
		ship.velocity = ship.velocity.move_toward(Vector2.ZERO, linear_acceleration * delta)
	
	else:
		var facing: = Vector2.RIGHT.rotated(ship.rotation)
		print("\nVel before: ", ship.velocity, " mod: ", ship.velocity.normalized() * throttle_direction * linear_acceleration * delta, " Facing: ", facing)
		ship.velocity += facing * throttle_direction * linear_acceleration * delta
		ship.velocity = ship.velocity.limit_length(ship.max_linear_speed)
