extends RigidBody2D

@export var engine_power = 800
@export var spin_power = 10000

var thrust = Vector2.ZERO
var rotation_dir = 0

func get_input():
	thrust = Vector2.ZERO
	if Input.is_action_pressed("throttle_up"):
		thrust = transform.x * engine_power
	elif Input.is_action_pressed("throttle_down"):
		thrust = transform.x * -engine_power
	rotation_dir = Input.get_axis("rotate_cw", "rotate_ccw")

func _physics_process(_delta):
	get_input()
	constant_force = thrust
	constant_torque = rotation_dir * spin_power
	print(spin_power)
