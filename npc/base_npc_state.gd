extends Node2D
class_name BaseNPCState

export var tag : String = ""

func _ready():
	tag = name.to_lower()

func enter(npc: KinematicBody2D):
	npc.play(tag)

func run(npc: KinematicBody2D):
	return null

func exit(npc: KinematicBody2D):
	if npc and npc.animation_player:
		npc.animation_player.clear_queue()
