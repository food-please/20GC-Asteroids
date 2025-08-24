extends Marker2D


@onready var _anim: AnimationPlayer = $AnimationPlayer


func explode() -> void:
	_anim.play("explode")
	await _anim.animation_finished
	queue_free()
