extends Node2D

const ASTEROID: = preload("res://asteroids/asteroid.tscn")

const SPEED: = {
	Asteroid.Size.HUGE: 30,
	Asteroid.Size.BIG: 50,
	Asteroid.Size.MEDIUM: 70,
	Asteroid.Size.SMALL: 80,
}


func _ready() -> void:
	randomize()
	
	for asteroid: Asteroid in find_children("*", "Asteroid"):
		var random_direction: = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
		asteroid.velocity = random_direction  * SPEED[asteroid.size]
		
		asteroid.split.connect(_on_asteroid_split.bind(asteroid))


func _on_asteroid_split(new_asteroids: int, new_size: Asteroid.Size, node: Asteroid) -> void:
	var random_direction: = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
			
	for i in new_asteroids:
		var new_asteroid: = ASTEROID.instantiate()
		add_child(new_asteroid)
		new_asteroid.split.connect(_on_asteroid_split.bind(new_asteroid))
		
		new_asteroid.global_position = node.global_position
		new_asteroid.size = new_size
		
		var speed = SPEED[new_asteroid.size]
		new_asteroid.velocity = random_direction.rotated(360.0/new_asteroids * i)*speed
