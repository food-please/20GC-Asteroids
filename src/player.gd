extends Node

signal score_changed

var ship: Node2D

var lives: = 3
var score: = 0


func add_score(change: int) -> void:
	score += change
	print(change)
	score_changed.emit()
