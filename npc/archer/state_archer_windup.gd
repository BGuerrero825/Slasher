extends BaseNPCState


func enter(npc : KinematicBody2D):
	npc.play("windup")


func run(npc: KinematicBody2D):
	if not npc.animation_player.is_playing():
		npc.recovery_time = npc.heavy_recovery_time
		return "attack"
