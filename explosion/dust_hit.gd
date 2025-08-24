extends Marker2D

@onready var _anim: AnimationPlayer = $AnimationPlayer
@onready var _particles: CPUParticles2D = $CPUParticles2D


func explode(direction: Vector2) -> void:
	_particles.direction = direction
	
	_anim.play("explode")
	await _anim.animation_finished
	queue_free()
