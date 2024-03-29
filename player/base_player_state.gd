extends Node2D
class_name BasePlayerState

export var tag : String = ""

func _ready():
	tag = name.to_lower()

func enter(player: KinematicBody2D):
	player.play(tag)

func run(player: KinematicBody2D):
	return null

func exit(player: KinematicBody2D):
	if player and player.animation_player:
		player.animation_player.clear_queue()
