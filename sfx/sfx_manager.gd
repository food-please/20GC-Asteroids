extends Node


func play(audio: AudioStream, is_spatial: = false, position: = Vector2.ZERO) -> void:
	var new_audio_player
	if is_spatial:
		new_audio_player = AudioStreamPlayer2D.new()
		new_audio_player.global_position = position
	
	else:
		new_audio_player = AudioStreamPlayer.new()
	
	add_child(new_audio_player)
	new_audio_player.finished.connect(new_audio_player.queue_free)
	new_audio_player.stream = audio
	new_audio_player.play()
