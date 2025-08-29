class_name Stats extends Resource

signal shields_depleted
signal hull_depleted


@export_range(1, 1, 1.0, "or_greater") var max_hull: float = 1.0
@export_range(1, 1, 1.0, "or_greater") var hull: float:
	set(value):
		hull = clampf(value, 0, max_hull)
		if is_equal_approx(hull, 0.0):
			hull_depleted.emit()

@export_range(0, 1, 1.0, "or_greater") var max_shields: float
var shields: float:
	set(value):
		shields = clampf(value, 0, max_shields)
		if is_equal_approx(shields, 0.0):
			shields_depleted.emit()


@export var score: int
