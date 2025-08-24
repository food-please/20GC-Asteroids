extends Node

@onready var ship: = get_parent() as Ship

#func _ready() -> void:
	#ship.velocity = ship.global_position.direction_to(get_parent().get_parent().get_node("Ship").global_position) * ship.max_linear_speed

#func _process(delta: float) -> void:
	#print(ship.velocity)
