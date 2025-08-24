@tool
class_name Weapon extends Node2D

enum STATUS { INACTIVE, PRIMARY, SECONDARY }

const INPUT_EVENT: Dictionary[String, StringName] = {
	"primary" = &"fire_primary",
	"secondary" = &"fire_secondary",
}

@export var projectile_scene: PackedScene:
	set(value):
		projectile_scene = value
		if value != null:
			var new_scene = projectile_scene.instantiate()
			if new_scene is not Projectile:
				printerr("Cannot set %s as projectile, it must be Projectile type!" \
					% new_scene.name)
				projectile_scene = null
			new_scene.free()
		
		update_configuration_warnings()

var parent_ship: Ship

@onready var origin: Node2D = $Origin


func _ready() -> void:
	if not Engine.is_editor_hint():
		assert(projectile_scene, "Weapon %s has no projectile set!" % name)
		parent_ship.register_weapon(self)


func _get_configuration_warnings() -> PackedStringArray:
	var msg: = []
	if projectile_scene == null:
		msg.append("The interaction must have a Projectile set!")
	if parent_ship == null:
		msg.append("A Weapon must be the direct child of a Ship!")
	return msg


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PARENTED:
			parent_ship = get_parent() as Ship
			update_configuration_warnings()


func fire() -> void:
	var projectile: Projectile = projectile_scene.instantiate()
	projectile.global_position = origin.global_position
	projectile.fire_velocity = (projectile.fire_speed)*_get_fire_direction()
	projectile.origin_ship = parent_ship
	
	Events.projectile_fired.emit(projectile)


# Returns a unit vector in the direction that the projectile should be fired.
# Could add a random element here to give spread to sequentially fired projectiles.
func _get_fire_direction() -> Vector2:
	var fire_direction: = Vector2.RIGHT
	return fire_direction.rotated(origin.global_rotation + randf_range(-0.2, 0.2))
