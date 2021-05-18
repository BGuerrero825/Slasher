extends Node2D


func _on_player_player_killed():
	$"CanvasLayer/Death Notice".visible = true
	get_tree().paused = true
	
