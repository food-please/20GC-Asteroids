class_name Hit extends RefCounted

var damage: int

var hull_sfx: AudioStream
var shield_sfx: AudioStream

var global_position: Vector2

## On contact with an object, the magnitude of the velocity is multiplied by
## [member knockback_damping] and then applied at [member knockback_direciton] to the target.
var transferred_velocity: = Vector2.ZERO
var knockback_direction: = Vector2.ZERO
var knockback_damping: = 1.0
