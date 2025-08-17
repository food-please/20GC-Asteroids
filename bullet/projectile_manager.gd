extends Node2D


func _ready() -> void:
	Events.projectile_fired.connect(
		func _on_projectile_fired(projectile: Projectile) -> void:
			add_child(projectile)
	)
