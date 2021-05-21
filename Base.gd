extends Node2D


var player_is_dead : bool = false

func _on_player_player_killed():
	$death_overlay.show()
#	pause_mode = Node.PAUSE_MODE_STOP
	get_tree().paused = true
