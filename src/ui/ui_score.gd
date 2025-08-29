extends MarginContainer

@onready var _label: Label = $Label


func _ready() -> void:
	Player.score_changed.connect(
		func _on_score_changed() -> void:
			_label.text = "SCORE: %d" % Player.score
			print(Player.score)
	)
