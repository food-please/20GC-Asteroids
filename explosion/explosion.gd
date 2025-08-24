extends Marker2D

signal explosion_frame

@export var particle_colours: Gradient

@onready var _anim: AnimationPlayer = $AnimationPlayer
@onready var _particles: CPUParticles2D = $CPUParticles2D


func _ready() -> void:
	_particles.color_initial_ramp = particle_colours


func explode() -> void:
	SFX.play(load("res://sfx/sfx_exp_medium1.wav"))
	_anim.play("explode")
	await _anim.animation_finished
	queue_free()


func signal_explosion_frame() -> void:
	explosion_frame.emit()
