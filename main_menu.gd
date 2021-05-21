extends Node2D


func _ready():
	get_tree().paused = false


func _process(delta):
	if Input.is_action_just_released("ui_accept"):
		get_tree().change_scene("res://Base.tscn")

