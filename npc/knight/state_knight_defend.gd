extends BaseNPCState


func enter(npc : KinematicBody2D):
	.enter(npc)
	npc.is_blocking = true


func run(npc : KinematicBody2D):
	if not npc.animation_player.is_playing():
		return "idle"


func exit(npc : KinematicBody2D):
	.exit(npc)
	npc.is_blocking = false
