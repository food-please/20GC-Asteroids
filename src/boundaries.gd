extends Area2D


func _on_body_exited(body: Node2D) -> void:
	if body.global_position.x < 0:
		body.global_position.x = 1152 + 40
	elif body.global_position.x > 1152:
		body.global_position.x = 0 -40
	
	if body.global_position.y < 0:
		body.global_position.y = 648 + 40
	elif body.global_position.y > 648:
		body.global_position.y = 0 - 40
